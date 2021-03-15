//
//  StringExtensions.swift
//  Grading
//


import Foundation
import UIKit
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
    
    func phoneNumber() -> String {
        var string = self
        string = string.replacingOccurrences(of: " ", with: "")
        string = string.replacingOccurrences(of: "(", with: "")
        string = string.replacingOccurrences(of: ")", with: "")
        string = string.replacingOccurrences(of: "-", with: "")
        return string
    }
    func dola() -> String {
        return "$"+self
    }
    
    func stringToDate(format: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = format
        let strDate = df.date(from: self)
        return strDate!
    }
    
}

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff"
    ]
    
    var mimeType: String? {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? nil
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Int {
    var boolValue: Bool { return self != 0 }
}

extension Bundle {
    var appName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App"
    }
}
