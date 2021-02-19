//
//  AppDelegate.swift
//  Grading
//
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let kClientID = "254893918378-70caq6tni2r2kk2g84usvrl7fs30pqpj.apps.googleusercontent.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        GIDSignIn.sharedInstance().clientID = kClientID
        
        UINavigationBar.appearance().barTintColor = Color.navBG // Navigation's BG Color
        UINavigationBar.appearance().tintColor = .white // Navigation's Button Color
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.absoluteString.contains("google") {
            GIDSignIn.sharedInstance().handle(url)
        }
        return true
    }

}

