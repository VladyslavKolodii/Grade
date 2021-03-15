//
//  SupplierDetailsVC.swift
//  Grading


import UIKit

class SupplierDetailVC: BaseVC {
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbUBI: UILabel!
    @IBOutlet weak var lbPacket: UILabel!
    @IBOutlet weak var lbNetwork: UILabel!

    var supplier: Supplier?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController()
    }
    
    func configView() {
        lbNote.text = supplier?.note
        lbNumber.text = supplier?.licenseNumber.string
        lbUBI.text = supplier?.ubi.string
        lbPacket.text = supplier?.farmPacket == true ? "Yes" : "No"
        lbNetwork.text = supplier?.networkAgreement == true ? "Yes" : "No"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
