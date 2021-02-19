//
//  CustomView.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class CustomView: UIView {

    @IBInspectable
    var rounded: Bool = false
    
    @IBInspectable
    var radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if rounded {
            self.layer.cornerRadius = self.frame.height/2
        } else {
            self.layer.cornerRadius = radius
        }
    }
    
}
