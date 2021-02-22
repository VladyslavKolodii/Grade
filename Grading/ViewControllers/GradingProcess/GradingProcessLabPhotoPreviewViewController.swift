//
//  GradingProcessLabPhotoPreviewViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class GradingProcessLabPhotoPreviewViewController: UIViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    
    var takenImage: UIImage?
    weak var delegate: GradingProcessLabResultsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.image = takenImage
    }
    
    @IBAction func doneAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
        delegate?.didSelectedPhoto(takenImage)
    }
    
    @IBAction func retakeAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareAction(_ sender: Any) {
    }
    
    @IBAction func deleteAction(_ sender: Any) {
    }
}
