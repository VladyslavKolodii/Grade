//
//  AppDelegate.swift
//  Grading
//
//

import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let kClientID = "254893918378-70caq6tni2r2kk2g84usvrl7fs30pqpj.apps.googleusercontent.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false

        GIDSignIn.sharedInstance().clientID = kClientID
        
        UINavigationBar.appearance().barTintColor = Color.navBG // Navigation's BG Color
        UINavigationBar.appearance().tintColor = .white // Navigation's Button Color
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.appFontBold(ofSize: 18)]
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18)], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18)], for: .selected)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.absoluteString.contains("google") {
            GIDSignIn.sharedInstance().handle(url)
        }
        return true
    }

}

