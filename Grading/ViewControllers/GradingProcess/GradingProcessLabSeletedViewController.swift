//
//  GradingProcessLabSeletedViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class GradingProcessLabSeletedViewController: UIViewController {
    
    private var mediaPicker: ImagePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        mediaPicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false)
    }
    
    @IBAction func attachAction(_ sender: Any) {
        mediaPicker?.present(title: "Attach a file", message: nil, from: self.view)
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        navigationController?.pushViewController(GradingProcessLabPhotoViewController.instantiate(from: .schedule), animated: true)
    }
    
    @IBAction func manualAction(_ sender: Any) {
    }
}

extension GradingProcessLabSeletedViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        let controller = GradingProcessLabPhotoPreviewViewController.instantiate(from: .schedule)
        controller.takenImage = image
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didSelect(videoURL: URL?) {
    }
}
