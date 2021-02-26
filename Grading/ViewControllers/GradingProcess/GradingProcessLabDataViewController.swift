//
//  GradingProcessLabDataViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit
import StepSlider

class GradingProcessLabDataViewController: UIViewController {
    
    @IBOutlet weak var microbiaTestSlider: StepSlider!
    @IBOutlet weak var pesticideTestSlider: StepSlider!
    @IBOutlet weak var heavyMetalsTestSlider: StepSlider!
    
    private let testingStatus = ["Untested", "Pass", "Fail"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
    }
    
    private func setupSlider() {
        microbiaTestSlider.labels = testingStatus
        pesticideTestSlider.labels = testingStatus
        heavyMetalsTestSlider.labels = testingStatus
        
        microbiaTestSlider.labelFont = UIFont.appFontBold(ofSize: 11)
        pesticideTestSlider.labelFont = UIFont.appFontBold(ofSize: 11)
        heavyMetalsTestSlider.labelFont = UIFont.appFontBold(ofSize: 11)
        
        microbiaTestSlider.labelColor = UIColor.white
        pesticideTestSlider.labelColor = UIColor.white
        heavyMetalsTestSlider.labelColor = UIColor.white
    }
}
