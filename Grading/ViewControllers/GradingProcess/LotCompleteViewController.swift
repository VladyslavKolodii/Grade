//
//  LotCompleteViewController.swift
//  Grading
//


import UIKit

class LotCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func duplicateAction(_ sender: Any) {
        navigationController?.pushViewController(DuplicateInventoryViewController.instantiate(from: .schedule), animated: true)
    }
    
    @IBAction func addInventoryAction(_ sender: Any) {
        navigationController?.setViewControllers([GradingProcessViewController.instantiate(from: .schedule)], animated: true)
    }
    
    @IBAction func finishGradingAction(_ sender: Any) {
        let controller = InventoryVC.instantiate(from: .inventory)
        controller.isPreviewJobInventory = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
