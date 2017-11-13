//
//  AppDelegate.swift
//  MagicCoin
//
//  Created by ASH on 7/21/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = MGCNavigationControllerViewController(rootViewController: InviteViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.setupPageControlAppearance()
        
        GMSServices.provideAPIKey("AIzaSyB9xRPxyNmThpJaGgAZFCdEcNFaPudILWE") //google maps
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //MARK: Private
    
    private func setupPageControlAppearance() {
        let pagecontrol = UIPageControl.appearance()
        pagecontrol.pageIndicatorTintColor = #colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 0.2)
        pagecontrol.currentPageIndicatorTintColor = #colorLiteral(red: 0.231372549, green: 0.137254902, blue: 0.08235294118, alpha: 1)
    }

}

