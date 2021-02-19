//
//  LotCompleteViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class LotCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func duplicateAction(_ sender: Any) {
        navigationController?.pushViewController(DuplicateInventoryViewController.instantiate(from: .schedule), animated: true)
    }
    
    @IBAction func addInventoryAction(_ sender: Any) {
    }
    
    @IBAction func finishGradingAction(_ sender: Any) {
    }
}
