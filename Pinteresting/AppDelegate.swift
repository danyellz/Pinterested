//
//  AppDelegate.swift
//  Pinteresting
//
//  Created by Ty Daniels on 4/4/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import UIKit
import PinterestSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PDKClient.configureSharedInstance(withAppId: "4893484700066134227")
        
        if let token = PDKClient.sharedInstance().oauthToken {
            print(token)
            setupMain()
        } else {
            setupLogin()
        }
        
        return true
    }
    
    fileprivate func setupLogin() {
        let authNavController = UINavigationController(rootViewController: AuthenticateViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = authNavController
        window?.makeKeyAndVisible()
    }
    
    fileprivate func setupMain() {
        let mainNavConroller = UINavigationController(rootViewController: MainBoardsViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainNavConroller
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return PDKClient.sharedInstance().handleCallbackURL(url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return PDKClient.sharedInstance().handleCallbackURL(url)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

