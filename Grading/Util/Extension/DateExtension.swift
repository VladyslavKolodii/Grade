//
//  DateExtension.swift
//  Grading
//
//  Created by Aira on 15.03.2021.
//

import Foundation

extension Date {
    func dateToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
