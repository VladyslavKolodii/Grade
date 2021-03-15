//
//  PhotoPreviewVC.swift
//  Grading
//


import UIKit

class PhotoPreviewVC: UIViewController {

    @IBOutlet weak var imageUV: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUV.image = image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTapBackUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
