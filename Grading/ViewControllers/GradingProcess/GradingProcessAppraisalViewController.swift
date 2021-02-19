//
//  GradingProcessAppraisalViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class GradingProcessAppraisalViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.textContainerInset.left = 10
        noteTextView.textContainerInset.top = 10
        noteTextView.tintColor = UIColor.white
        noteTextView.delegate = self
    }
    
    @IBAction func doneAction(_ sender: Any) {
    }
}

extension GradingProcessAppraisalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}
