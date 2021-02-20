//
//  SupplierDetailsVC.swift
//  Grading
//
//  Created by Viet Tuan on 20/02/2021.
//

import UIKit

class SupplierProfileVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func detailTap(_ sender: Any) {
        navigationController?.pushViewController(SupplierDetailVC.instantiate(from: .suppliers), animated: true)
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController()
    }
    

}
