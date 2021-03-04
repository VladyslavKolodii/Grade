//
//  DuplicateInventoryViewController.swift
//  Grading
//


import UIKit

class DuplicateInventoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func continueAction(_ sender: Any) {
        navigationController?.setViewControllers([GradingProcessViewController.instantiate(from: .schedule)], animated: true)
    }
}
