//
//  FilterInventoryVC.swift
//  Grading
//


import UIKit
import FSCalendar

class FilterInventoryVC: BaseVC {
    
    @IBOutlet weak var containerUV: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var calendarUV: FSCalendar!
    @IBOutlet weak var lbSortBy: UILabel!
    @IBOutlet weak var lbGrader: UILabel!
    @IBOutlet weak var lbProductType: UILabel!
    @IBOutlet weak var lbProgress: UILabel!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd, yyyy"
        return formatter
    }()
    
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date]?
    var productTypeValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIView()
    }
    
    func initUIView() {
        
        calendarUV.appearance.caseOptions = [.headerUsesCapitalized]
        calendarUV.appearance.eventDefaultColor = Color.eventDate
        calendarUV.appearance.selectionColor = Color.selectedDate
        calendarUV.appearance.todayColor = Color.eventDate
        calendarUV.scope = .month
        calendarUV.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarUV.appearance.headerTitleColor = .white
        calendarUV.appearance.titleFont = UIFont.appFontSemiBold(ofSize: 18)
        calendarUV.allowsMultipleSelection = true
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
    
    @IBAction func onTapCancelUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSaveUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapClearAll(_ sender: Any) {
        productTypeValues = ["A flower"]
        lbSortBy.text = "Date Graded"
        lbGrader.text = "Any"
        lbProgress.text = "Any"
        lbProductType.text = productTypeValues.joined(separator: ", ")
    }
    
    @IBAction func productTypeTap(_ sender: Any) {
        let vc = ProductTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.onValueChanged = { productTypeValues in
            self.lbProductType.text = productTypeValues.joined(separator: ", ")
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func sortTypeTap(_ sender: Any) {
        let vc = SortTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.onValueChanged = { type in
            self.lbSortBy.text = type
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
}

extension FilterInventoryVC: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
        } else if firstDate != nil && lastDate == nil { // only first date is selected:
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                print("datesRange contains: \(datesRange!)")
            }
            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last
            for d in range {
                calendar.select(d)
            }
            datesRange = range
            print("datesRange contains: \(datesRange!)")
        } else if firstDate != nil && lastDate != nil { // both are selected:
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
        
        if let selectedDates = datesRange?.map({self.dateFormatter.string(from: $0)}) {
            print("selected dates is \(selectedDates)")
            if monthPosition == .next || monthPosition == .previous {
                calendar.setCurrentPage(date, animated: true)
            }
            if selectedDates.count > 1 {
                dateLB.text = selectedDates.first! + " to " + selectedDates.last!
            } else if selectedDates.count > 0 {
                dateLB.text = selectedDates[0]
            } else {
                dateLB.text = "---"
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
}
