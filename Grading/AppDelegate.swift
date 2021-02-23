//
//  AppDelegate.swift
//  Grading
//
//

import UIKit
import GoogleSignIn
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let kClientID = "254893918378-70caq6tni2r2kk2g84usvrl7fs30pqpj.apps.googleusercontent.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupToast()
        setupKeyboardManager()
        setupNavigationAppearence()

        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.absoluteString.contains("google") {
            GIDSignIn.sharedInstance().handle(url)
        }
        return true
    }
    
    private func setupToast() {
        ToastManager.shared.position = .top
        ToastManager.shared.duration = 2.0
        var style = ToastStyle()
        style.messageFont = UIFont.appFontBold(ofSize: 9)
        style.titleAlignment = .center
        style.verticalPadding = 3
        style.rounded = true
        ToastManager.shared.style = style
    }
    
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
    }

    private func setupNavigationAppearence() {
        UINavigationBar.appearance().barTintColor = Color.navBG
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.appFontBold(ofSize: 18)]
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18)], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18)], for: .selected)
    }
}

