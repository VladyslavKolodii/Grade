//
//  CustomTextField.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class CustomTextField: UITextField {

    @IBInspectable
    var placeholderColor: UIColor = .darkGray {
        didSet {
            update()
        }
    }
    
    func update() {
        let attribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: placeholderColor,
                                                        NSAttributedString.Key.font: self.font ?? UIFont.appFontRegular(ofSize: 18)]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attribute)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.white
        update()
    }
}
