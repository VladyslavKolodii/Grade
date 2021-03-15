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
    @IBOutlet weak var lbSold: UILabel!
    @IBOutlet weak var lbSupplier: UILabel!
    @IBOutlet weak var lnEvn: UILabel!
    
    var sortSelected: SortType = .date
    var soldSelected: SoldType?
    var supplierSelected: [FilterType]?
    var environmentSelected: [FilterType]?
    var graderSelected: [FilterType]?
    var productTypeSelected: [FilterType]?
    var processSelected: [FilterType]?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd, yyyy"
        return formatter
    }()
    
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date]?
    var onSaveFilter: (() ->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUIView()
        sortSelected = FilterTypeData.sortSelected
        soldSelected = FilterTypeData.soldSelected
        graderSelected = FilterTypeData.graderSelected
        environmentSelected = FilterTypeData.environmentSelected
        processSelected = FilterTypeData.processSelected
        productTypeSelected = FilterTypeData.productTypeSelected
        supplierSelected = FilterTypeData.supplierSelected
        if FilterTypeData.dateFrom != nil, FilterTypeData.dateTo == nil {
            self.setDataDate(date: FilterTypeData.dateFrom!, calendar: calendarUV)
        }
        if FilterTypeData.dateFrom != nil, FilterTypeData.dateTo != nil {
            firstDate = FilterTypeData.dateFrom
            self.setDataDate(date: FilterTypeData.dateTo!, calendar: calendarUV)
        }
        self.setFilterData()
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
    
    func setFilterData() {
        lbSortBy.text = sortSelected.rawValue
        lbSold.text = soldSelected != nil ? soldSelected?.rawValue : "Any"
        lbGrader.text = graderSelected != nil ? graderSelected?.map({$0.name}).joined(separator: ", ") : "Any"
        lbProductType.text = productTypeSelected != nil ? productTypeSelected?.map({$0.name}).joined(separator: ", ") : "Any"
        lbProgress.text = processSelected != nil ? processSelected?.map({$0.name}).joined(separator: ", ") : "Any"
        lbSupplier.text = supplierSelected != nil ? supplierSelected?.map({$0.name}).joined(separator: ", ") : "Any"
        lnEvn.text = environmentSelected != nil ? environmentSelected?.map({$0.name}).joined(separator: ", ") : "Any"
    }
    
    func setDataDate(date:Date,calendar:FSCalendar) {
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            calendar.select(date)
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
            if selectedDates.count > 1 {
                dateLB.text = selectedDates.first! + " to " + selectedDates.last!
            } else if selectedDates.count > 0 {
                dateLB.text = selectedDates[0]
            } else {
                dateLB.text = "---"
            }
        }
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
        FilterTypeData.sortSelected = sortSelected
        FilterTypeData.soldSelected = soldSelected
        FilterTypeData.graderSelected = graderSelected
        FilterTypeData.environmentSelected = environmentSelected
        FilterTypeData.processSelected = processSelected
        FilterTypeData.productTypeSelected = productTypeSelected
        FilterTypeData.supplierSelected = supplierSelected
        FilterTypeData.dateFrom = firstDate
        FilterTypeData.dateTo = lastDate
        self.onSaveFilter?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapClearAll(_ sender: Any) {
        FilterTypeData.sortSelected = .date
        FilterTypeData.soldSelected = nil
        FilterTypeData.graderSelected = nil
        FilterTypeData.environmentSelected = nil
        FilterTypeData.processSelected = nil
        FilterTypeData.productTypeSelected = nil
        FilterTypeData.supplierSelected = nil
        for d in calendarUV.selectedDates {
            calendarUV.deselect(d)
        }
        firstDate = nil
        lastDate = nil
        datesRange = nil
        dateLB.text = "---"
        self.setFilterData()
    }
    
    @IBAction func productTypeTap(_ sender: Any) {
        let vc = ProductTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.selectedValues = productTypeSelected ?? []
        vc.onValueChanged = { arrSelected in
            self.productTypeSelected = arrSelected.count > 0 ? arrSelected : nil
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func sortTypeTap(_ sender: Any) {
        let vc = SortTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.onValueChanged = { type in
            self.sortSelected = type
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func soldTap(_ sender: Any) {
        let vc = SoldTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.onValueChanged = { type in
            self.soldSelected = type
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func supplierTap(_ sender: Any) {
        let vc = FilterTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.filterTypeAPI = .supplier
        vc.arrSelected = supplierSelected ?? []
        vc.onValueChanged = {  type, arrSelected in
            self.saveDataSelected(type: type, arrSelected: arrSelected)
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func graderTap(_ sender: Any) {
        let vc = FilterTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.filterTypeAPI = .grader
        vc.arrSelected = graderSelected ?? []
        vc.onValueChanged = {  type, arrSelected in
            self.saveDataSelected(type: type, arrSelected: arrSelected)
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func enviromentTap(_ sender: Any) {
        let vc = FilterTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.filterTypeAPI = .environment
        vc.arrSelected = environmentSelected ?? []
        vc.onValueChanged = { type, arrSelected in
            self.saveDataSelected(type: type, arrSelected: arrSelected)
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func progressTap(_ sender: Any) {
        let vc = FilterTypeVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.filterTypeAPI = .process
        vc.arrSelected = processSelected ?? []
        vc.onValueChanged = {  type, arrSelected in
            self.saveDataSelected(type: type, arrSelected: arrSelected)
            self.setFilterData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func saveDataSelected(type: FilterTypeAPI, arrSelected: [FilterType]) {
        switch type {
        case .process:
            processSelected = arrSelected.count > 0 ? arrSelected : nil
        case .environment:
            environmentSelected = arrSelected.count > 0 ? arrSelected : nil
        case .grader:
            graderSelected = arrSelected.count > 0 ? arrSelected : nil
        case .supplier:
            supplierSelected = arrSelected.count > 0 ? arrSelected : nil
        default: break
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
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
