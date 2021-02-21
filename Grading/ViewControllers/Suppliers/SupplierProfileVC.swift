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
        let vc = SupplierDetailVC.instantiate(from: .suppliers)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController()
    }
    

}
