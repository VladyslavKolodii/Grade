//
//  ProfileInfoVC.swift
//  Grading

import UIKit
import Alamofire
import Kingfisher
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

}
