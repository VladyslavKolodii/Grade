//
//  BaseNavigationController.swift
//  Grading
//


import UIKit

class BaseNavigationController: UINavigationController {
    public var requiredStatusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        requiredStatusBarStyle
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.init(hex: "101332")
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [
            .font: UIFont.appFontBold(ofSize: 18),
            .foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [
            .font: UIFont.appFontSemiBold(ofSize: 34),
            .foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
