//
//  ViewController.swift
//  Demo
//
//

import UIKit
import SVProgressHUD

class ScheduleDetailVC: UIViewController {
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!  
    @IBOutlet weak var mainUIMG: UIImageView!
    @IBOutlet weak var scheduleTimeLB: UILabel!
    @IBOutlet weak var scheduleTitleLB: UILabel!
    @IBOutlet weak var supplierTV: UITableView!
    @IBOutlet weak var scheduleLocationLB: UILabel!
    @IBOutlet weak var supplierTVHeight: NSLayoutConstraint!
    
    var selectedID: Int?
    var appointment: Appointment?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    //MARK:- App lifeCycle:------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
               
        mainUIMG.layer.shadowOffset = CGSize(width: 0, height: 5)
        mainUIMG.layer.shadowColor = UIColor.gray.cgColor
        mainUIMG.layer.shadowOpacity = 1
        mainUIMG.layer.shadowRadius = 3
        mainUIMG.layer.masksToBounds = false
        
        supplierTV.delegate = self
        supplierTV.dataSource = self
        initData()
    }
    
    @IBAction func onTapBackUB(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapLocationUB(_ sender: Any) {
        self.performSegue(withIdentifier: "locationDetail", sender: nil)
    }
}

extension ScheduleDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierProfileCell", for: indexPath) as! SupplierProfileCell
        let info = appointment?.suppliers[indexPath.row]
        cell.info = info
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointment?.suppliers.count ?? 0
    }
}

extension ScheduleDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

extension ScheduleDetailVC {
    func initData() {
        SVProgressHUD.show()
        let service = AppService()
        service.getAppointmentDetail(selectedID: selectedID!) { (json) in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                self.appointment = Appointment()
                self.appointment?.initWithJSON(obj: json["response"])
                self.handleView(self.appointment!)
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
    
    func handleView(_ appointment: Appointment) {
        self.scheduleTimeLB.text = appointment.time
        self.scheduleTitleLB.text = appointment.title
        self.scheduleLocationLB.text = appointment.location
        supplierTVHeight.constant = CGFloat((appointment.suppliers.count ?? 0)*190)
        supplierTV.reloadData()
    }
}

