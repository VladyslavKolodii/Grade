//
//  Utility.swift
//  Grading
//


import UIKit

struct Screen {
    
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

struct Color {

    static let tabBG = UIColor(hex: "212121")
    static let tabTintBG = UIColor(hex: "0A84FF")
    static let navBG = UIColor(hex: "101332")
    static let selectedDate = UIColor(hex: "0A84FF")
    static let eventDate = UIColor(hex: "0A84FF").withAlphaComponent(0.4)
    
}

class Util: NSObject {
    
    static var gUserID: Int?
    
    class func showTabbar() {
        if let ctrl = TabBarController.storyboardInstance() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = ctrl
        }
    }
}
