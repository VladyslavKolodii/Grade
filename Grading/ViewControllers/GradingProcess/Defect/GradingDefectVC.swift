//
//  GradingDefectVC.swift
//  Grading
//


import UIKit
import StepSlider

class GradingDefectVC: UIViewController {

    @IBOutlet weak var moldSlider: StepSlider!
    @IBOutlet weak var fungusSlider: StepSlider!
    @IBOutlet weak var seedSlider: StepSlider!
    @IBOutlet weak var hermSlider: StepSlider!
    @IBOutlet weak var postSlider: StepSlider!
    @IBOutlet weak var defectNoteTV: UITextView!
    @IBOutlet weak var foreignSlider: StepSlider!
    
    let labelsOfSlider = ["None\nFound", "Possible\nTrace", "Some\nFound", "Moderate\nAmount", "Substantial\nAmount"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initUIView() {
        defectNoteTV.delegate = self
        defectNoteTV.selectedTextRange = defectNoteTV.textRange(from: defectNoteTV.beginningOfDocument, to: defectNoteTV.beginningOfDocument)
        
        moldSlider.labels = labelsOfSlider
        fungusSlider.labels = labelsOfSlider
        seedSlider.labels = labelsOfSlider
        hermSlider.labels = labelsOfSlider
        postSlider.labels = labelsOfSlider
        foreignSlider.labels = labelsOfSlider
        
        moldSlider.labelFont = .systemFont(ofSize: 9)
        fungusSlider.labelFont = .systemFont(ofSize: 9)
        seedSlider.labelFont = .systemFont(ofSize: 9)
        hermSlider.labelFont = .systemFont(ofSize: 9)
        postSlider.labelFont = .systemFont(ofSize: 9)
        foreignSlider.labelFont = .systemFont(ofSize: 9)
    }
}

extension GradingDefectVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText: NSString = textView.text! as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        if updatedText.isEmpty {
            textView.text = "Defect Notes"
            textView.textColor = UIColor(named: "appGrey3Color")
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        }
        else if textView.textColor == UIColor(named: "appGrey3Color") && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor(named: "appwhiteColor")
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor(named: "appGrey3Color") {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
