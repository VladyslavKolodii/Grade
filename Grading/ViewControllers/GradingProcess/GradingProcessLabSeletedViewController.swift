//
//  GradingProcessLabSeletedViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

protocol GradingProcessLabResultsDelegate: class {
    func didSelectedPhoto(_ image: UIImage?)
}

class GradingProcessLabSeletedViewController: UIViewController {
    
    private var mediaPicker: ImagePicker?
    weak var delegate: GradingProcessDelegate?
    
    private var rootNavigationController: UINavigationController? {
        if let pageViewController = self.parent?.parent as? UIPageViewController {
            return pageViewController.navigationController
        }
        
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mediaPicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false)
    }
    
    @IBAction func attachAction(_ sender: Any) {
        mediaPicker?.present(title: "Attach a file", message: nil, from: self.view)
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        let controller = GradingProcessLabPhotoViewController.instantiate(from: .schedule)
        controller.delegate = self
        rootNavigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func manualAction(_ sender: Any) {
        let controller = GradingProcessLabManualViewController.instantiate(from: .schedule)
        controller.delegate = self
        rootNavigationController?.pushViewController(controller, animated: true)
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

extension GradingProcessLabSeletedViewController: GradingProcessLabResultsDelegate {
    func didSelectedPhoto(_ image: UIImage?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.navigationController?.pushViewController(GradingProcessLabDataViewController.instantiate(from: .schedule), animated: true)
        }
    }
}
