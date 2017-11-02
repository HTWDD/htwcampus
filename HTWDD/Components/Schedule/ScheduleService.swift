//
//  ScheduleService.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation
import RxSwift

class ScheduleService: Service {

    struct Auth: Hashable, Codable {
        let year: String
        let major: String
        let group: String

        var hashValue: Int {
            return self.year.hashValue ^ self.major.hashValue ^ self.group.hashValue
        }

        static func ==(lhs: ScheduleService.Auth, rhs: ScheduleService.Auth) -> Bool {
            return lhs.year == rhs.year && lhs.major == rhs.major && lhs.group == rhs.group
        }
    }

    struct Information: Codable, Equatable {
        let lectures: [Day: [Lecture]]
        let semesters: [SemesterInformation]
        
        init(lectures: [Day: [Lecture]], semesters: [SemesterInformation]) {
            self.lectures = lectures
            self.semesters = semesters
        }
        
        private enum CodingKeys : CodingKey {
            case lectures, semesters
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.lectures = try values.decode(CodableDictionary.self, forKey: .lectures).decoded
            self.semesters = try values.decode([SemesterInformation].self, forKey: .semesters)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(CodableDictionary(self.lectures), forKey: .lectures)
            try container.encode(self.semesters, forKey: .semesters)
        }
        
        static func ==(lhs: Information, rhs: Information) -> Bool {
            guard lhs.lectures.count == rhs.lectures.count else {
                return false
            }
            let allSame = lhs.lectures.reduce(true) { p, n -> Bool in
                guard let rhsHas = rhs.lectures[n.key] else {
                    return false
                }
                return p && rhsHas == n.value
            }
            return allSame && lhs.semesters == rhs.semesters
        }
    }

    private let network = Network()

    private var cachedInformation = [Auth: Information]()

    func load(parameters: Auth) -> Observable<Information> {
        if let cached = self.cachedInformation[parameters] {
            return Observable.just(cached)
        }

        let lecturesObservable = Lecture.get(network: self.network, year: parameters.year, major: parameters.major, group: parameters.group)
            .map(Lecture.groupByDay)

        let informationObservable = SemesterInformation.get(network: self.network)
        
        let cached = self.loadFromCache()
        let internetLoading: Observable<Information> = Observable.combineLatest(lecturesObservable, informationObservable) { [weak self] l, s in
            let information = Information(lectures: l, semesters: s)
            self?.cachedInformation[parameters] = information
            self?.saveToCache(info: information)
            return information
        }
        return Observable.merge(cached, internetLoading).distinctUntilChanged()
    }
    
    private func loadFromCache() -> Observable<Information> {
        guard let data = UserDefaults.standard.data(forKey: "SavedSchedule") else {
            return Observable.empty()
        }
        guard let info = try? JSONDecoder().decode(Information.self, from: data) else {
            return Observable.empty()
        }
        return Observable.just(info)
    }
    
    private func saveToCache(info: Information) {
        guard let data = try? JSONEncoder().encode(info) else {
            Log.error("Tried to save \(info) to cache, but json encoding failed.")
            return
        }
        UserDefaults.standard.set(data, forKey: "SavedSchedule")
    }

}

// MARK: - Dependency management

extension ScheduleService: HasSchedule {
    var scheduleService: ScheduleService { return self }
}
