//
//  ScheduleVC.swift
//  Grading
//


import UIKit
import FSCalendar

class ScheduleVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var lblSelectedDate: UILabel!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    var schedules:[Schedule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.dragView.addGestureRecognizer(self.scopeGesture)
        
        calendar.backgroundColor = .clear
        calendar.appearance.caseOptions = [.headerUsesCapitalized,.weekdayUsesSingleUpperCase]
        calendar.appearance.eventDefaultColor = Color.eventDate
        calendar.appearance.selectionColor = Color.selectedDate
        calendar.appearance.headerDateFormat = ""
        calendar.appearance.todayColor = Color.selectedDate
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .lightGray
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 16)
        
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 5)
        calendarView.layer.shadowColor = UIColor.gray.cgColor
        calendarView.layer.shadowOpacity = 1
        calendarView.layer.shadowRadius = 3
        calendarView.layer.masksToBounds = false
        
        offlineView.layer.cornerRadius = 10
        
        lblSelectedDate.text = self.dateFormatter.string(from: Date())
        
        createDummy()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "TH"
    }
    
    func createDummy() {
        
        schedules.append(Schedule.init(1, "Aernier Inc", "11:00am", .correct, .edit))
        schedules.append(Schedule.init(1, "Akiles Group", "11:00am", .load, .continueAction))
        schedules.append(Schedule.init(1, "Aoehm Extracts", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Bahringer Supply Co.", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Batterfield Growers", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Busche Gardens", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Aernier Inc", "11:00am", .correct, .edit))
        schedules.append(Schedule.init(1, "Akiles Group", "11:00am", .load, .continueAction))
        schedules.append(Schedule.init(1, "Aoehm Extracts", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Bahringer Supply Co.", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Batterfield Growers", "11:00am", .blank, .start))
        schedules.append(Schedule.init(1, "Busche Gardens", "11:00am", .blank, .start))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scheduleDetail" {
            let destVC = segue.destination as! ScheduleDetailVC
            destVC.hidesBottomBarWhenPushed = true
        }
    }
    
    //MARK: - USER INTERACTION
    
    @IBAction func toggleTap(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.appearance.headerDateFormat = ""
        } else {
            self.calendar.appearance.headerDateFormat = "MMMM yyyy"
        }
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: false)
        } else {
            self.calendar.setScope(.month, animated: false)
        }
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "TH"
    }
    
    @IBAction func prevTap(_ sender: Any) {
        var dc = DateComponents()
        if self.calendar.scope == .month {
            dc.setValue(-1, for: .month)
        } else {
            dc.setValue(-7, for: .weekday)
        }
        let date = self.calendar.gregorian.date(byAdding: dc, to: self.calendar.currentPage)
        self.calendar.setCurrentPage(date ?? Date(), animated: true)
    }
    
    @IBAction func nextTap(_ sender: Any) {
        var dc = DateComponents()
        if self.calendar.scope == .month {
            dc.setValue(1, for: .month)
        } else {
            dc.setValue(7, for: .weekday)
        }
        let date = self.calendar.gregorian.date(byAdding: dc, to: self.calendar.currentPage)
        self.calendar.setCurrentPage(date ?? Date(), animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}

extension ScheduleVC: FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = self.scopeGesture.velocity(in: self.view)
        switch self.calendar.scope {
        case .month:
            self.calendar.appearance.headerDateFormat = ""
            return velocity.y < 0
        case .week:
            self.calendar.appearance.headerDateFormat = "MMMM yyyy"
            return velocity.y > 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        lblSelectedDate.text = selectedDates[0]
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}

extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        
        let record = schedules[indexPath.row]
        cell.lblTitle.text = record.title
        cell.lblTime.text = record.time
        
        switch record.status {
        case .blank:
            cell.btnRadio.setImage(UIImage.init(named: "circle_blank"), for: .normal)
            break
        case .correct:
            cell.btnRadio.setImage(UIImage.init(named: "circle_correct"), for: .normal)
            break
        case .load:
            cell.btnRadio.setImage(UIImage.init(named: "circle_load"), for: .normal)
            break
        }
        
        switch record.action {
        case .edit:
            cell.btnAction.setTitle("Edit ", for: .normal)
            cell.btnAction.setImage(UIImage.init(named: "edit"), for: .normal)
            break
        case .start:
            cell.btnAction.setTitle("Start ", for: .normal)
            cell.btnAction.setImage(UIImage.init(named: "arrow_right_blue"), for: .normal)
            break
        case .continueAction:
            cell.btnAction.setTitle("Continue ", for: .normal)
            cell.btnAction.setImage(UIImage.init(named: "arrow_right_blue"), for: .normal)
            break
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension ScheduleVC: ScheduleCellDelegate {
    func didTapActionUB() {
        self.performSegue(withIdentifier: "scheduleDetail", sender: nil)
    }
}
