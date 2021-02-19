//
//  GradingProcessLabPhotoViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit
import Photos

class GradingProcessLabPhotoViewController: UIViewController {
    
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var takenImageView: UIImageView!
    
    let cameraController = CameraController()
    
    private var takenImage: UIImage? {
        didSet {
            takenImageView.isHidden = takenImage == nil
            takenImageView.image = takenImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCameraController()
        takenImageView.isHidden = true
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        if takenImage != nil {
            takenImage = nil
            return
        }
        
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.takenImage = image
            print(image)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        let controller = GradingProcessLabPhotoPreviewViewController.instantiate(from: .schedule)
        controller.takenImage = takenImage
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension GradingProcessLabPhotoViewController {
    
    private func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
}
