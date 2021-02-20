//
//  GradingInventoryVC.swift
//  Grading
//
//  Created by Aira on 20.02.2021.
//

import UIKit

class GradingInventoryVC: UIViewController {

    @IBOutlet weak var plantMatterUB: UIButton!
    @IBOutlet weak var extractUB: UIButton!
    @IBOutlet weak var entryNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initUIView() {
        plantMatterUB.backgroundColor = UIColor(named: "appSecondaryColor")
        extractUB.backgroundColor = .clear
        entryNameTF.attributedPlaceholder = NSAttributedString(string: "Entry Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "appGrey3Color")!])
    }
    
    @IBAction func onTapSwitchUB(_ sender: UIButton) {
        if sender.tag == 0 {
            plantMatterUB.backgroundColor = UIColor(named: "appSecondaryColor")
            extractUB.backgroundColor = .clear
        } else {
            plantMatterUB.backgroundColor = .clear
            extractUB.backgroundColor = UIColor(named: "appSecondaryColor")
        }
    }
    
}
