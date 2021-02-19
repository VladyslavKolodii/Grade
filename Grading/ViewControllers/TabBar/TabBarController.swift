//
//  TabBarController.swift
//  Grading
//


import UIKit

class TabBarController: UITabBarController {

    static func storyboardInstance() -> TabBarController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as? TabBarController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
    }
    
    private func setupControllers() {
        let schedule = UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController()!
        let supplier = UIStoryboard(name: "Suppliers", bundle: nil).instantiateInitialViewController()!
        let inventory = UIStoryboard(name: "Inventory", bundle: nil).instantiateInitialViewController()!
        viewControllers = [schedule, supplier, inventory]
        tabBar.barTintColor = Color.tabBG
        tabBar.backgroundColor = .clear
        tabBar.tintColor = Color.tabTintBG
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
    }
    
}
