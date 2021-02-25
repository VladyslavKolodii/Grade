//
//  UIViewControllerExtensions.swift
//
//  Created by QTS.
//

import UIKit

// MARK: - Properties
public extension UIViewController {

    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }

}

// MARK: - Methods
public extension UIViewController {
    
    enum StoryboardName: String {
        case tabbar = "TabBarController"
        case account = "Account"
        case schedule = "Schedule"
        case suppliers = "Suppliers"
        case inventory = "Inventory"
    }

    class func instantiate(from storyboard: StoryboardName) -> Self {
        let viewControllerIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else {
            preconditionFailure("Unable to instantiate view controller with identifier \(viewControllerIdentifier) as type \(type(of: self))")
        }
        return viewController
    }

    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) {
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.appFontSemiBold(ofSize: 17), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.appFontRegular(ofSize: 13), .foregroundColor: UIColor.black]
        
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttribute)
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showErrorAlert(title: String? = "Oops!", message: String?, errorColor: UIColor = .red) {
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.appFontSemiBold(ofSize: 17), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.appFontRegular(ofSize: 13), .foregroundColor: errorColor]
        
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttribute)
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let closeAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    func presentPopover(_ popoverContent: UIViewController, sourcePoint: CGPoint, size: CGSize? = nil, delegate: UIPopoverPresentationControllerDelegate? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        popoverContent.modalPresentationStyle = .popover

        if let size = size {
            popoverContent.preferredContentSize = size
        }

        if let popoverPresentationVC = popoverContent.popoverPresentationController {
            popoverPresentationVC.sourceView = view
            popoverPresentationVC.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationVC.delegate = delegate
        }

        present(popoverContent, animated: animated, completion: completion)
    }
    
    func showToast(_ message: String?) {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.makeToast(message)
    }
}
