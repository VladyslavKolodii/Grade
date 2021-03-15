//
//  ProfileInfoVC.swift
//  Grading
//


import UIKit
import SwifterSwift
import SVProgressHUD
import SwiftyJSON

class FaqVC: BaseVC {
    
    @IBOutlet weak var tbMain: UITableView!
    var fags = [Faq]()
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        self.getFaqList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureView() {
        self.navigationItem.title = "FAQ"
        self.tbMain.register(nibWithCellClass: FaqCell.self)
    }
    
}

extension FaqVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FaqCell.self)
        let fag = fags[indexPath.row]
        cell.lbQuestion.text = fag.question
        cell.lbAnswer.text = fag.answer
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fags.count
    }
}

extension FaqVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: Webservice
extension FaqVC {
    func getFaqList(completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getFaqList(page: currentPage) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["data"]["data"].arrayValue
                for object in response {
                    let fag = Faq(object)
                    self.fags.append(fag)
                }
                self.tbMain.reloadData()
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
