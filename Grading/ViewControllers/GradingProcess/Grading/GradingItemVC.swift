//
//  GradingItemVC.swift
//  Grading
//
//  Created by Aira on 20.02.2021.
//

import UIKit

class GradingItemVC: UIViewController {

    @IBOutlet weak var titleLB: UILabel!
    
    var strTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLB.text = "Grading - \(strTitle!)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}