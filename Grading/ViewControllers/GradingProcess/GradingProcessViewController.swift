//
//  GradingProcessViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

class GradingProcessViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    private var pageTitle: [String] = []
    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            navigationItem.title = pageTitle[currentIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    
    @IBAction func backStepAction(_ sender: Any) {
        guard currentIndex > 0 else {
            dismiss(animated: true, completion: nil)
            return
        }
        currentIndex -= 1
        pageController.setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func nextStepAction(_ sender: Any) {
        guard currentIndex < pages.count-1 else {
            navigationController?.pushViewController(LotCompleteViewController.instantiate(from: .schedule), animated: true)
            return
        }
        currentIndex += 1
        pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        guard currentIndex < pages.count-1 else {
            navigationController?.pushViewController(LotCompleteViewController.instantiate(from: .schedule), animated: true)
            return }
        currentIndex += 1
        pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GradingProcessViewController {
    
    private func setupPageController() {
        
        let inventoryVC = UIViewController()
        inventoryVC.view.backgroundColor = .clear
        
        let productVC = UIViewController()
        productVC.view.backgroundColor = .cyan
        
        let materialPhotosVC = UIViewController()
        materialPhotosVC.view.backgroundColor = .purple
        
        let gradingVC = UIViewController()
        gradingVC.view.backgroundColor = .systemPink
        
        let defectsVC = UIViewController()
        defectsVC.view.backgroundColor = .darkGray
        
        let labResultsVC = GradingProcessLabSeletedViewController.instantiate(from: .schedule)
        
        let appraisalVC = GradingProcessAppraisalViewController.instantiate(from: .schedule)
        
        pages = [inventoryVC, productVC, materialPhotosVC, gradingVC, defectsVC, labResultsVC, appraisalVC]
        pageTitle = ["Inventory", "Product", "Material Photos", "Grading", "Defects", "Lab Results", "Appraisal"]
        
        self.pageControl.numberOfPages = pages.count
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width, height: self.containerView.frame.height)
        self.addChild(self.pageController)
        self.containerView.addSubview(self.pageController.view)
        let initialVC = pages[0]
        
        self.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        self.pageController.didMove(toParent: self)
        
        for v in pageController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).isScrollEnabled = false
            }
        }
        
        self.navigationItem.title = pageTitle[0]
    }
}

extension GradingProcessViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private func viewController(comingFrom viewController: UIViewController, indexModifier: Int) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        let newIndex = index + indexModifier
        guard newIndex >= 0 && newIndex < pages.count else { return nil }
        return pages[newIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.viewController(comingFrom: viewController, indexModifier: -1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.viewController(comingFrom: viewController, indexModifier: 1)
    }
}
