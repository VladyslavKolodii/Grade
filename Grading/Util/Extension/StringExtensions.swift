//
//  StringExtensions.swift
//  Grading
//


import Foundation

extension String {
    
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeparator = formatter.decimalSeparator ?? "."
        
        if let number = formatter.number(from: self) {
            if number.doubleValue > 100 {
                return false
            }
            
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""

            return digits.count <= maxDecimalPlaces
        }
        
        return false
    }
}
