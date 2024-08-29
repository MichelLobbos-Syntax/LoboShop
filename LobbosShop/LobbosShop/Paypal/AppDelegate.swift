////
////  AppDelegate.swift
////  LobbosShop
////
////  Created by Michel Lobbos on 20.07.24.
////
//import UIKit
//import BraintreeCore
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        return true
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if BTAppContextSwitcher.canHandleOpen(url) {
//            return BTAppContextSwitcher.handleOpen(url)
//        }
//        return false
//    }
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if BTAppContextSwitcher.canHandleOpen(url) {
//            return BTAppContextSwitcher.handleOpen(url)
//        }
//        return false
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//}
