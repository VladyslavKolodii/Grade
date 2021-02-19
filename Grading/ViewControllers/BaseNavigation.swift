//
//  UiViewController.swift
//  Grading
//
//  Created by VietTuan on 19/02/2021.
//

import UIKit

class BaseNavigation: UINavigationController {
    
    public var requiredStatusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        requiredStatusBarStyle
    }
}
