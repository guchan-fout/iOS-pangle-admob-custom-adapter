//
//  AppDelegate.swift
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 5000546 for video
        let configuration = BUAdSDKConfiguration()
        
        #if DEBUG
        // enable log print. default is none.
        configuration.logLevel = .debug
        #endif
        
        configuration.appID = "5064663"
        configuration.coppa = 0
        configuration.gdpr = 0
        
        //Set to true to NOT interrupt background app's audio playback
        configuration.allowModifyAudioSessionSetting = true
        
        BUAdSDKManager.start(asyncCompletionHandler:) { (success, error) in
            if ((error) != nil) {
                //init failed
            }
        };
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

