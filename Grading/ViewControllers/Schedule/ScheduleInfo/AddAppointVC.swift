//
//  AddAppointVC.swift
//  Grading
//
//  Created by Aira on 20.02.2021.
//

import UIKit
import FSCalendar

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
