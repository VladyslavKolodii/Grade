//
//  SuppliersVC.swift
//  Grading
//


import UIKit

class SuppliersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        
        self.navigationItem.title = "Suppliers"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}
