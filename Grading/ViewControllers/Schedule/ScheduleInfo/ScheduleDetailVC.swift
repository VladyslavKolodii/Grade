//
//  ViewController.swift
//  Demo
//
//

import UIKit

class ScheduleDetailVC: UIViewController {
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!  
    @IBOutlet weak var mainUIMG: UIImageView!
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    //MARK:- App lifeCycle:------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
               
        mainUIMG.layer.shadowOffset = CGSize(width: 0, height: 5)
        mainUIMG.layer.shadowColor = UIColor.gray.cgColor
        mainUIMG.layer.shadowOpacity = 1
        mainUIMG.layer.shadowRadius = 3
        mainUIMG.layer.masksToBounds = false
    }
    
    @IBAction func onTapBackUB(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapLocationUB(_ sender: Any) {
        self.performSegue(withIdentifier: "locationDetail", sender: nil)
    }
}

