//
//  Schedule.swift
//  Grading
//


import Foundation

enum ScheduleStatusType {
    case blank
    case correct
    case load
}

enum ScheduleActionType {
    case edit
    case continueAction
    case start
}

class Schedule {
    
    let id: Int
    var title: String?
    var time: String?
    var status: ScheduleStatusType = .blank
    var action: ScheduleActionType = .start
    
    init(_ id: Int, _ title: String, _ time: String, _ status: ScheduleStatusType, _ action: ScheduleActionType)
    {
        self.id = id
        self.title = title
        self.time = time
        self.status = status
        self.action = action
    }
}
