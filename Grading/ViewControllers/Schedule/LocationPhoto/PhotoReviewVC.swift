//
//  PhotoReviewController.swift
//  Demo
//
//

import UIKit

class PhotoReviewVC: UIViewController {
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var imgView: UIImageView!

    var selectedImage: UIImage?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    //MARK:- App lifeCycle:------
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.image = selectedImage
        // Do any additional setup after loading the view.

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    @IBAction func onTapBackUB(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
