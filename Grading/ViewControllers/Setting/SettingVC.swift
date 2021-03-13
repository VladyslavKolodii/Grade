//
//  SettingVC.swift
//  Grading
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

class SettingVC: BaseVC {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    var user: User? {
        didSet {
            self.showInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        self.getInfoUser(userId: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureView() {
        self.navigationItem.title = "Settings"
    }
    
    func showInfo() {
        self.lbName.text = user?.name
        AF.request(user?.image ?? "",method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                self.imgAvatar.image = UIImage(data: responseData!, scale:1)
            case .failure( _):
                self.imgAvatar.image = UIImage(named: "ic_avatar")
            }
        }
    }
    
    @IBAction func profileTap(_ sender: Any) {
        let profileInfoVC = ProfileInfoVC()
        profileInfoVC.user = user
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

// MARK: Webservice
extension SettingVC {
    func getInfoUser(userId: Int,completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getInfoUser(userId: userId) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"]
                let user = User(response)
                self.user = user
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
