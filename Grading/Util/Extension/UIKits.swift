//
//  UIKits.swift
//  Grading
//
//  Created by VietTuan on 19/02/2021.
//

import Foundation
import UIKit

extension UITabBarController {
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        // hide tab bar
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)

        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)

        // animate tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY!)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                return
            }
        }
    }
    func tabBarIsVisible() ->Bool {
     
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
