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
    
    weak var delegate: GradingProcessDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.textContainerInset.left = 10
        noteTextView.textContainerInset.top = 10
        noteTextView.tintColor = UIColor.white
        noteTextView.delegate = self
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
