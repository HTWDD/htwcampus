//
//  AppDelegate.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 07/11/2016.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if NSClassFromString("XCTestCase") != nil {
            return true
        }
        
        Tracker.track(.start)

        let window = UIWindow()

		self.appCoordinator = AppCoordinator(window: window)
		self.window = window

		self.stylizeUI()

		Fabric.with([Crashlytics.self])
        
        UserDefaults.standard.saveAppVersion()

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Tracker.track(.open)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let viewController = url.host?.removingPercentEncoding
        
        if(viewController == "schedule") {
            let tababarController = self.window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 0
        }
        return true
    }
    
	// MARK: - UI Apperance
	
	private func stylizeUI() {
		UIRefreshControl.appearance().tintColor = .white
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = UIColor.htw.blue
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
		if #available(iOS 11.0, *) { UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white] }
	}

}
