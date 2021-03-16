//
//  AddAppointVC.swift
//  Grading
//
//  Created by Aira on 20.02.2021.
//

import UIKit
import FSCalendar
import SVProgressHUD

class AddAppointVC: UIViewController {

    @IBOutlet weak var containerUV: UIView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var supplierTF: UITextField!
    @IBOutlet weak var noteTF: UITextField!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var calendarUV: FSCalendar!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd, yyyy"
        return formatter
    }()
    
    fileprivate lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    var selectedSupplier: Supplier = Supplier()
    
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
        
        titleTF.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "appGrey3Color")!])
        supplierTF.attributedPlaceholder = NSAttributedString(string: "Supplier", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "appGrey3Color")!])
        noteTF.attributedPlaceholder = NSAttributedString(string: "Notes", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "appGrey3Color")!])
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        calendarUV.appearance.caseOptions = [.headerUsesCapitalized]
        calendarUV.appearance.eventDefaultColor = Color.eventDate
        calendarUV.appearance.selectionColor = Color.selectedDate
        calendarUV.appearance.todayColor = Color.selectedDate
        calendarUV.scope = .month
        calendarUV.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarUV.appearance.headerTitleColor = .white
        calendarUV.appearance.titleFont = UIFont.boldSystemFont(ofSize: 18)
        
        calendarUV.delegate = self
        
        dateLB.text = Date().dateToString(format: "EEEE, MMM dd, yyyy")
        timeLB.text = timeFormatter.string(from: timePicker.date)
        
    }
    
    @IBAction func onTapCalenderControlUB(_ sender: UIButton) {
        var dc = DateComponents()
        if sender.tag == 1 {
            dc.setValue(-1, for: .month)
        } else {
            dc.setValue(1, for: .month)
        }
        let date = self.calendarUV.gregorian.date(byAdding: dc, to: self.calendarUV.currentPage)
        self.calendarUV.setCurrentPage(date ?? Date(), animated: true)
    }
    
    @IBAction func getSelectedTime(_ sender: UIDatePicker) {
        let selectedTime = timeFormatter.string(from: sender.date)
        print(selectedTime)
        timeLB.text = selectedTime
    }
    
    @IBAction func onTapCancelUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onTapAddSupplierUB(_ sender: Any) {
        let vc = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "AddSupplierAppointment") as! AddSupplierAppointment
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onTapSaveUB(_ sender: Any) {
        let strDateTime: String = dateLB.text! + " " + timeLB.text!
        let dateTime: Date = strDateTime.stringToDate(format: "EEEE, MMM dd, yyyy hh:mm a")
        let param: [String: String] = [
            "title": titleTF.text!,
            "supplier": "\(selectedSupplier.id)",
            "note": noteTF.text!,
            "date": dateTime.dateToString(format: "yyyy-MM-dd HH:mm:ss")
        ]
        let service = AppService()
        SVProgressHUD.show()
        service.addAppointment(param: param) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                self.dismiss(animated: true, completion: nil)
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

extension AddAppointVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        dateLB.text = selectedDates[0]
    }
}

extension AddAppointVC: AddSupplierAppointmentDelegate {
    func didDismiss(supplier: Supplier) {
        self.selectedSupplier = supplier
        self.supplierTF.text = supplier.name
    }
}
