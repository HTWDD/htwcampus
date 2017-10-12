//
//  ScheduleDetailContentView.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 23/03/2017.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import Cartography

class ScheduleDetailContentViewModel {

    private let lecture: Lecture

    init(lecture: Lecture) {
        self.lecture = lecture
    }

    var tag: String {
        return self.lecture.name
    }

}

class ScheduleDetailContentView: View {

    let viewModel: ScheduleDetailContentViewModel

    private let label = UILabel()

    init(viewModel: ScheduleDetailContentViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)
        self.label.text = self.viewModel.tag

        self.addSubview(label)
        constrain(self, self.label) { container, label in
            label.edges == container.edgesWithinMargins
        }

        self.backgroundColor = .white

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.4
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }

}