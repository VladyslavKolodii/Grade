//
//  CalendarPickerVC.swift
//  Grading
//
//  Created by Aira on 16.03.2021.
//

import UIKit
import FSCalendar

protocol CalendarPickerVCDelegate {
    func didSelectDate(date: String)
}

class CalendarPickerVC: UIViewController {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
    
    @IBOutlet weak var calenderUV: FSCalendar!
    
    var selectedDate: String = ""
    var delegate: CalendarPickerVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderUV.backgroundColor = .clear
        calenderUV.appearance.caseOptions = [.headerUsesCapitalized,.weekdayUsesSingleUpperCase]
        calenderUV.appearance.eventDefaultColor = Color.eventDate
        calenderUV.appearance.selectionColor = Color.selectedDate
        calenderUV.appearance.headerDateFormat = "MMMM yyyy"
        calenderUV.appearance.todayColor = Color.selectedDate
        calenderUV.scope = .month
        calenderUV.appearance.headerMinimumDissolvedAlpha = 0.0
        calenderUV.appearance.weekdayTextColor = .lightGray
        calenderUV.appearance.headerTitleColor = .white
        calenderUV.appearance.titleFont = UIFont.boldSystemFont(ofSize: 16)
        
        calenderUV.layer.shadowOffset = CGSize(width: 0, height: 0)
        calenderUV.layer.shadowColor = UIColor.gray.cgColor
        calenderUV.layer.shadowOpacity = 1
        calenderUV.layer.shadowRadius = 0
        calenderUV.layer.masksToBounds = false
        calenderUV.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        self.calenderUV.calendarWeekdayView.weekdayLabels[4].text = "TH"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onTapCalenderPreUV(_ sender: Any) {
        var dc = DateComponents()
        if self.calenderUV.scope == .month {
            dc.setValue(-1, for: .month)
        } else {
            dc.setValue(-7, for: .weekday)
        }
        let date = self.calenderUV.gregorian.date(byAdding: dc, to: self.calenderUV.currentPage)
        self.calenderUV.setCurrentPage(date ?? Date(), animated: true)
    }
    
    @IBAction func onTapCalendarNextUB(_ sender: Any) {
        var dc = DateComponents()
        if self.calenderUV.scope == .month {
            dc.setValue(1, for: .month)
        } else {
            dc.setValue(7, for: .weekday)
        }
        let date = self.calenderUV.gregorian.date(byAdding: dc, to: self.calenderUV.currentPage)
        self.calenderUV.setCurrentPage(date ?? Date(), animated: true)
    }
    
    
    @IBAction func onTapSaveUB(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectDate(date: self.selectedDate)
        }
    }
    @IBAction func onTapCancelUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CalendarPickerVC: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        selectedDate = date.dateToString(format: "EEEE, MMM dd, yyyy")
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}
