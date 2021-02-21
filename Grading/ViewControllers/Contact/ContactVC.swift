//
//  ProfileInfoVC.swift
//  Grading
//
//  Created by VietTuan on 19/02/2021.
//

import UIKit

class ContactVC: BaseVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureView() {
        self.navigationItem.title = "Contact Verdica"
    }

}
