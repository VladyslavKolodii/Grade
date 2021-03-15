//
//  ProfileInfoVC.swift
//  Grading

import UIKit
import Alamofire
class ProfileInfoVC: BaseVC {

    var user: User?

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRole: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureView() {
        self.navigationItem.title = "Account"
        self.lbName.text = user?.name
        self.lbRole.text = user?.role
        self.lbEmail.text = user?.email
        AF.request(user?.image ?? "",method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                self.imgAvatar.image = UIImage(data: responseData!, scale:1)
            case .failure( _):
                self.imgAvatar.image = UIImage(named: "ic_avatar")
            }
        }
    }

}
