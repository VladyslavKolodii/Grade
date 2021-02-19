//
//  ImagePicker.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit
import MobileCoreServices
import PhotosUI

enum MediaType: String {
    case image = "public.image"
    case video = "public.movie"
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
    func didSelect(videoURL: URL?)
}

class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var documentTypes: [String] = [kUTTypeJPEG as String, kUTTypePNG as String, kUTTypeImage as String]

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, mediaTypes: [MediaType], allowsEditing: Bool) {
        self.pickerController = UIImagePickerController()

        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowsEditing
        self.pickerController.videoQuality = .typeMedium
        self.pickerController.videoMaximumDuration = 30
        self.pickerController.mediaTypes = mediaTypes.map({$0.rawValue})
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(title: String? = nil, message: String? = nil, from sourceView: UIView) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        if let action = self.action(for: .photoLibrary, title: "Choose Photo") {
            alertController.addAction(action)
        }
        
        let text = "Browse..."
        let iCloudAction = UIAlertAction(title: text, style: .default) { (action) in
            self.openCloud()
        }
        
        alertController.addAction(iCloudAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, mediaURL: URL?) {
        controller.dismiss(animated: true, completion: nil)
        if image != nil {
            self.delegate?.didSelect(image: image)
        }
        if mediaURL != nil {
            self.delegate?.didSelect(videoURL: mediaURL)
        }
    }
    
    private func openCloud() {
        let document = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        document.delegate = self
        document.allowsMultipleSelection = false
        self.presentationController?.present(document, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, mediaURL: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var selectImage: UIImage?
        var selectMediaURL: URL?
        if let mediaURL = info[.mediaURL] as? URL {
            selectMediaURL = mediaURL
        } else if let image = info[.editedImage] as? UIImage {
            selectImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectImage = image
        }
        self.pickerController(picker, didSelect: selectImage, mediaURL: selectMediaURL)
    }
}

extension ImagePicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        if let url = urls.first, let data = try? Data(contentsOf: url) {
            delegate?.didSelect(image: UIImage(data: data))
        }
    }
}
