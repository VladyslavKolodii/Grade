//
//  PhotoReviewController.swift
//  Demo
//
//

import UIKit
import SVProgressHUD

class PhotoReviewVC: UIViewController {
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    var selectedImage: UIImage?
    var selectedID: Int?
    
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
    
    @IBAction func onTapDoneUB(_ sender: Any) {
        SVProgressHUD.show()
        let service = AppService()
        service.addAppointmentLocationImage(selectedID: self.selectedID!, image: self.selectedImage!) { (json) in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                for vc in self.navigationController!.viewControllers as Array {
                    if vc.isKind(of: LocationDetailVC.self) {
                        self.navigationController?.popToViewController(vc, animated: false)
                    }
                }
            default:
                if let message = json["messages"].string{
                    self.showErrorAlert(message: message)
                } else {
                    self.showErrorAlert(message: "Something went wrong. Please try again.")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}
