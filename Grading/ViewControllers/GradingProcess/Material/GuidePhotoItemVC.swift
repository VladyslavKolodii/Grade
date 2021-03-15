//
//  GuidePhotoItemVC.swift
//  Grading
//


import UIKit

class GuidePhotoItemVC: UIViewController {

    @IBOutlet weak var guideIndex: UILabel!
    
    var strIndex: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        guideIndex.text = strIndex
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
