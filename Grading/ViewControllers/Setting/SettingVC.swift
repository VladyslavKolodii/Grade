//
//  SettingVC.swift
//  Grading
//
//  Created by VietTuan on 19/02/2021.
//

import UIKit

class SettingVC: BaseVC {

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
        self.navigationItem.title = "Settings"
    }

    @IBAction func profileTap(_ sender: Any) {
        let profileInfoVC = ProfileInfoVC()
        self.navigationController?.pushViewController(profileInfoVC, animated: true)
    }
    @IBAction func fapTap(_ sender: Any) {
        let faqVC = FaqVC()
        self.navigationController?.pushViewController(faqVC, animated: true)
    }
    @IBAction func contactTap(_ sender: Any) {
        let contactVC = ContactVC()
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
}
