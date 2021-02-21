//
//  GradingVC.swift
//  Grading
//
//  Created by Aira on 20.02.2021.
//

import UIKit
import ASValueTrackingSlider

class GradingVC: UIViewController, ASValueTrackingSliderDataSource {

    @IBOutlet weak var colorSlider: ASValueTrackingSlider!
    @IBOutlet weak var aromaticSlider: ASValueTrackingSlider!
    @IBOutlet weak var structureSlider: ASValueTrackingSlider!
    @IBOutlet weak var trichomeSlider: ASValueTrackingSlider!
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
        colorSlider.popUpViewColor = UIColor(named: "appSecondaryColor")
        colorSlider.popUpViewCornerRadius = 20.0
        colorSlider.textColor = .white
        colorSlider.font = .systemFont(ofSize: 12, weight: .bold)
        colorSlider.popUpViewWidthPaddingFactor = 1.0
        colorSlider.popUpViewHeightPaddingFactor = 2.0
        colorSlider.dataSource = self
        
        aromaticSlider.popUpViewColor = UIColor(named: "appSecondaryColor")
        aromaticSlider.popUpViewCornerRadius = 20.0
        aromaticSlider.textColor = .white
        aromaticSlider.font = .systemFont(ofSize: 12, weight: .bold)
        aromaticSlider.popUpViewWidthPaddingFactor = 1.0
        aromaticSlider.popUpViewHeightPaddingFactor = 2.0
        aromaticSlider.dataSource = self
        
        structureSlider.popUpViewColor = UIColor(named: "appSecondaryColor")
        structureSlider.popUpViewCornerRadius = 20.0
        structureSlider.textColor = .white
        structureSlider.font = .systemFont(ofSize: 12, weight: .bold)
        structureSlider.popUpViewWidthPaddingFactor = 1.0
        structureSlider.popUpViewHeightPaddingFactor = 2.0
        structureSlider.dataSource = self
        
        trichomeSlider.popUpViewColor = UIColor(named: "appSecondaryColor")
        trichomeSlider.popUpViewCornerRadius = 20.0
        trichomeSlider.textColor = .white
        trichomeSlider.font = .systemFont(ofSize: 12, weight: .bold)
        trichomeSlider.popUpViewWidthPaddingFactor = 1.0
        trichomeSlider.popUpViewHeightPaddingFactor = 2.0
        trichomeSlider.dataSource = self
    }
    
    func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        let value = Int(value)
        return "\(String(format: "%3d", value))%"
    }
    
}
