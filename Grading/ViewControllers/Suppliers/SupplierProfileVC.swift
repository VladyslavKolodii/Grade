//
//  SupplierDetailsVC.swift
//  Grading
//


import UIKit

class SupplierProfileVC: BaseVC {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbUBI: UILabel!
    @IBOutlet weak var ctrHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var lbPacket: UILabel!
    @IBOutlet weak var lbNetwork: UILabel!
    
    var supplier: Supplier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }
    
    func configView() {
        lbName.text = supplier?.name
        lbLocation.text = supplier?.location
        lbNote.text = supplier?.note
        lbNumber.text = supplier?.licenseNumber.string
        lbUBI.text = supplier?.ubi.string
        lbPacket.text = supplier?.farmPacket == true ? "Yes" : "No"
        lbNetwork.text = supplier?.networkAgreement == true ? "Yes" : "No"
        ctrHeightTableView.constant = CGFloat((supplier?.info.count ?? 0)*190)
    }
    
    @IBAction func detailTap(_ sender: Any) {
        let vc = SupplierDetailVC.instantiate(from: .suppliers)
        vc.hidesBottomBarWhenPushed = true
        vc.supplier = self.supplier
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController()
    }
}

extension SupplierProfileVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierProfileCell", for: indexPath) as! SupplierProfileCell
        let info = supplier?.info[indexPath.row]
        cell.info = info
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplier?.info.count ?? 0
    }
}

extension SupplierProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
