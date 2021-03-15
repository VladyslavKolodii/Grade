//
//  SettingVC.swift
//  Grading
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Kingfisher

class SettingVC: BaseVC {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    var user: UserInfo? {
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
        let url = URL(string: user?.image ?? "")
        let processor = DownsamplingImageProcessor(size: imgAvatar.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 30)
        imgAvatar.kf.indicatorType = .activity
        imgAvatar.kf.setImage(
            with: url,
            placeholder: UIImage(named: "img_avatar_user_empty"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                self.imgAvatar.image = value.image
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                self.imgAvatar.image = UIImage(named: "img_avatar_user_empty")
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
                let user = UserInfo(response)
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
