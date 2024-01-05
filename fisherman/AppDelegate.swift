//
//  AppDelegate.swift
//  fisherman
//
//  Created by wangwenjian on 2023/12/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var keyWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initSDKs()
        keyWindow.rootViewController = HomeVC()
        keyWindow.makeKeyAndVisible()
        return true
    }


}

