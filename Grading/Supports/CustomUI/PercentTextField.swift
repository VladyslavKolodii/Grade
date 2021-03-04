//
//  PercentTextField.swift
//  Grading
//


import UIKit

private var kAssociationKeyMaxLength: Int = 0

class PercentTextField: UITextField {
    
    @IBInspectable
    var placeholderColor: UIColor = .darkGray {
        didSet {
            update()
        }
    }
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
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
        self.delegate = self
    }

}

extension PercentTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if string.isEmpty { return true }
      let currentText = textField.text ?? ""
      let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
      return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmed, !text.isEmpty else { return }
        let split = text.components(separatedBy: ".")
        var digits = split.count == 2 ? split.first ?? "" : ""
        if digits.count > 2, digits.hasPrefix("0") {
            digits = String(digits.dropFirst())
        }
    }
}
