//
//  AppDelegate.swift
//  home-monitoring
//
//  Created by Konrad on 12.06.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
    let beaconManager = ESTBeaconManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        // Add placeholders here
        ESTConfig.setupAppID("home-monitoring-jl5", andAppToken: "f433d2de4223c70c1f057763d665b85d")
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        return true
    }

}

