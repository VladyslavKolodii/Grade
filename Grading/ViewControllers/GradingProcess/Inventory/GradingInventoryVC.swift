//
//  GradingInventoryVC.swift
//  Grading
//


import UIKit

class GradingInventoryVC: UIViewController {

    @IBOutlet weak var plantMatterUB: UIButton!
    @IBOutlet weak var extractUB: UIButton!
    @IBOutlet weak var entryNameTF: UITextField!
    @IBOutlet weak var qrCodeTF: UITextField!
    @IBOutlet weak var dateLB: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initUIView() {
        plantMatterUB.backgroundColor = UIColor(named: "appSecondaryColor")
        extractUB.backgroundColor = .clear
        entryNameTF.attributedPlaceholder = NSAttributedString(string: "Entry Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "appGrey3Color")!])
        qrCodeTF.attributedPlaceholder = NSAttributedString(string: "QR Code", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "appGrey3Color")!])
        
        dateLB.text = Date().dateToString(format: "EEEE, MMM dd, yyyy")
    }    
    
    @IBAction func onTapSwitchUB(_ sender: UIButton) {
        if sender.tag == 0 {
            plantMatterUB.backgroundColor = UIColor(named: "appSecondaryColor")
            extractUB.backgroundColor = .clear
        } else {
            plantMatterUB.backgroundColor = .clear
            extractUB.backgroundColor = UIColor(named: "appSecondaryColor")
        }
    }
    @IBAction func onTapCalenderUB(_ sender: Any) {
        let vc = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "CalendarPickerVC") as! CalendarPickerVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onTtapQRUB(_ sender: Any) {
        let vc = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingInventoryScanVC") as! GradingInventoryScanVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension GradingInventoryVC: CalendarPickerVCDelegate {
    func didSelectDate(date: String) {
        self.dateLB.text = date
    }
}

extension GradingInventoryVC: GradingQRScanDelegate {
    func returnScanValue(val: String) {
        qrCodeTF.text = val
    }
}
