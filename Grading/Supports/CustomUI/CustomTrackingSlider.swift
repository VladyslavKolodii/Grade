//
//  CustomTrackingSlider.swift
//  Grading
//


import UIKit
import ASValueTrackingSlider

@IBDesignable class CustomTrackingSlider: UIView {
    
    var strColor: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    var stackForMenter: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    var defaultSlder: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = UIColor(named: "appGrey3Color")
        slider.value = 0.0
        slider.thumbTintColor = UIColor(named: "appSecondaryColor")
        return slider
    }()
    
    var trackingSlider: ASValueTrackingSlider = {
        let slider = ASValueTrackingSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.value = 0.0
        slider.thumbTintColor = .clear
        slider.popUpViewColor = UIColor(named: "appSecondaryColor")
        slider.popUpViewCornerRadius = 20.0
        slider.textColor = .white
        slider.font = .systemFont(ofSize: 14, weight: .bold)
        slider.popUpViewWidthPaddingFactor = 1.5
        slider.popUpViewHeightPaddingFactor = 1.5
        slider.popUpViewArrowLength = 10.0
        return slider
    }()
    
    var customThumb: UIView = UIView()
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        self.addSubview(stackForMenter)
        stackForMenter.spacing = (self.frame.size.width - (3 * 11)) / 10
        for _ in 0..<11 {
            let subView: UIView = UIView()
            subView.backgroundColor = UIColor(named: "appGrey3Color")
            subView.widthAnchor.constraint(equalToConstant: 3.0).isActive = true
            subView.heightAnchor.constraint(equalToConstant: 11.0).isActive = true
            stackForMenter.addArrangedSubview(subView)
        }
        stackForMenter.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackForMenter.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackForMenter.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        stackForMenter.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.addSubview(defaultSlder)
        defaultSlder.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        defaultSlder.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        defaultSlder.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        defaultSlder.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.addSubview(trackingSlider)
        trackingSlider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        trackingSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trackingSlider.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        trackingSlider.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        trackingSlider.addTarget(self, action: #selector(trackingSliderValueChange), for: .valueChanged)
        trackingSlider.delegate = self
        trackingSlider.dataSource = self
        
    }
    
    func thumbImage(radius: CGFloat) -> UIImage {
        customThumb.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        customThumb.layer.cornerRadius = radius / 2
        customThumb.backgroundColor = UIColor(named: "appSecondaryColor")
        let renderer = UIGraphicsImageRenderer(bounds: customThumb.bounds)
        return renderer.image { (context) in
            customThumb.layer.render(in: context.cgContext)
        }
    }
    
    @objc func trackingSliderValueChange(slider: ASValueTrackingSlider) {
        handleDefaultSlider(slider.value)
        handleStackFroMeter(slider.value)
    }
    
}

extension CustomTrackingSlider: ASValueTrackingSliderDelegate, ASValueTrackingSliderDataSource {
    func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        let value = Int(value)
        return "\(String(format: "%3d", value))"
    }
        
    func sliderWillDisplayPopUpView(_ slider: ASValueTrackingSlider!) {
        if let handleView = self.trackingSlider.subviews.first {
            if let thumb = handleView.subviews.last {
                thumb.removeSubviews()
            }
        }
    }
    
    func sliderWillHidePopUpView(_ slider: ASValueTrackingSlider!) {
        print("popupview will hide")
        self.strColor.text = String(format: "%3d", Int(slider.value))
        showValueWhenHidePopUpView(slider.value)
    }
}

extension CustomTrackingSlider {
    func showValueWhenHidePopUpView(_ value: Float) {
        if Int(value) == 0 || Int(value) == 100{
            strColor.text = ""
        }
        strColor.translatesAutoresizingMaskIntoConstraints = false
        if let handleView = self.trackingSlider.subviews.first {
            if let thumb = handleView.subviews.last {
                thumb.addSubview(strColor)
                strColor.centerXAnchor.constraint(equalTo: thumb.centerXAnchor, constant: -2.0).isActive = true
                strColor.centerYAnchor.constraint(equalTo: thumb.centerYAnchor, constant: 0.0).isActive = true
            }
        }
    }
    
    func handleDefaultSlider(_ value: Float) {
        self.defaultSlder.value = value
    }
    
    func handleStackFroMeter(_ value: Float) {
        let index: Int = Int(floor(value / 100 * 11)) - 1
        for i in 0..<11 {
            stackForMenter.arrangedSubviews[i].backgroundColor = (i <= index) ? .white : UIColor(named: "appGrey3Color")
        }
    }
}

