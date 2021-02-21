//
//  GradingProductVC.swift
//  Grading
//
//  Created by Aira on 20.02.2021.
//

import UIKit
import StepSlider

class GradingProductVC: UIViewController {
    
    @IBOutlet weak var productNoteTV: UITextView!
    @IBOutlet weak var sliderUV: UIView!
    
    let slider: StepSlider = {
        let slider = StepSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maxCount = 4
        slider.index = 0
        slider.labels = ["Indoor", "Greenhouse", "Hoop House", "Outdoor"]
        slider.adjustLabel = true
        slider.sliderCircleColor = UIColor(named: "appSecondaryColor")
        slider.trackColor = UIColor(named: "appGrey3Color")
        slider.labelOffset = 4.0
        slider.tintColor = .white
        return slider
    }()
    
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
        productNoteTV.delegate = self
        productNoteTV.selectedTextRange = productNoteTV.textRange(from: productNoteTV.beginningOfDocument, to: productNoteTV.beginningOfDocument)
        
        sliderUV.addSubview(slider)
        slider.centerXAnchor.constraint(equalTo: sliderUV.centerXAnchor).isActive = true
        slider.centerYAnchor.constraint(equalTo: sliderUV.centerYAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: sliderUV.leftAnchor, constant: 40).isActive = true
        
    }
}

extension GradingProductVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText: NSString = textView.text! as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        if updatedText.isEmpty {
            textView.text = "Product Notes (Customer-facing)"
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
