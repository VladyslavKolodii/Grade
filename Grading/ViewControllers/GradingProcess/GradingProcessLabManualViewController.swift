//
//  GradingProcessLabManualViewController.swift
//  Grading
//


import UIKit

class GradingProcessLabManualViewController: UIViewController {

    @IBOutlet weak var drawView: CanvasView!
    
    weak var delegate: GradingProcessLabResultsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func exportImage(from view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
    
    @IBAction func doneAction(_ sender: Any) {
        let controller = GradingProcessLabPhotoPreviewViewController.instantiate(from: .schedule)
        controller.takenImage = exportImage(from: drawView)
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func undoAction(_ sender: Any) {
        drawView.undo()
    }
    
    
    @IBAction func clearAction(_ sender: Any) {
        drawView.clear()
    }
}

