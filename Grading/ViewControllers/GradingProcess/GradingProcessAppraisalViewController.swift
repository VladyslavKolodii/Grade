//
//  GradingProcessAppraisalViewController.swift
//  Grading
//


import UIKit

class GradingProcessAppraisalViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var priceTextField: CustomTextField!
    
    weak var delegate: GradingProcessDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.textContainerInset.left = 10
        noteTextView.textContainerInset.top = 10
        noteTextView.tintColor = UIColor.white
        noteTextView.delegate = self
        priceTextField.delegate = self
    }
    
    @IBAction func doneAction(_ sender: Any) {
        delegate?.didFinishGradingProcess()
    }
}

extension GradingProcessAppraisalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}

extension GradingProcessAppraisalViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard var value = textField.text?.trimmed else { return }
        if value.hasPrefix("$") == true {
            value = String(value.dropFirst())
            textField.text = value
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text?.trimmed, !value.isEmpty else { return }
        if value.hasPrefix("$") == false {
            textField.text = "$" + value
        }
    }
}
