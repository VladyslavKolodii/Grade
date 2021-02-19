//
//  InventoryVC.swift
//  Grading
//


import UIKit

class InventoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        
        self.navigationItem.title = "Inventory"
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
