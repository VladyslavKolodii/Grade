//
//  DuplicateInventoryViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class DuplicateInventoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func continueAction(_ sender: Any) {
        navigationController?.setViewControllers([GradingProcessViewController.instantiate(from: .schedule)], animated: true)
    }
}
