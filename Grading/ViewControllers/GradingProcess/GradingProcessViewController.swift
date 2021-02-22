//
//  GradingProcessViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/19/21.
//

import UIKit

protocol GradingProcessDelegate: class {
    func didFinishGradingProcess()
    func updateRightButtonTitle(_ title: String)
}

class GradingProcessViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    private var pageTitle: [String] = []
    private var rightButtonTitle: [String] = []
    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            navigationItem.title = pageTitle[currentIndex]
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle[currentIndex], style: .plain, target: self, action: #selector(self.skip_continueAction))
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
    
    @objc private func skip_continueAction() {
        guard currentIndex < pages.count-1 else {
            navigationController?.pushViewController(LotCompleteViewController.instantiate(from: .schedule), animated: true)
            return }
        currentIndex = pages.count-1
        pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GradingProcessViewController {
    
    private func setupPageController() {
        
        let inventoryVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingInventoryVC") as! GradingInventoryVC

        let productVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingProductVC") as! GradingProductVC

        let materialPhotosVC = UIViewController()
        materialPhotosVC.view.backgroundColor = .purple

        let gradingVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingVC") as! GradingVC

        let defectsVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingDefectVC") as! GradingDefectVC
        
        let labResultsVC = GradingProcessLabSeletedViewController.instantiate(from: .schedule)
        labResultsVC.delegate = self
        let navi = UINavigationController(rootViewController: labResultsVC)
        navi.isNavigationBarHidden = true
        
        let appraisalVC = GradingProcessAppraisalViewController.instantiate(from: .schedule)
        appraisalVC.delegate = self
        
        pages = [inventoryVC, productVC, materialPhotosVC, gradingVC, defectsVC, navi, appraisalVC]
        pageTitle = ["Inventory", "Product", "Material Photos", "Grading", "Defects", "Lab Results", "Appraisal"]
        rightButtonTitle = ["Continue", "Continue", "Skip", "Skip", "Continue", "Skip", "Skip"]
        
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
        
        navigationItem.title = pageTitle[0]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle[0], style: .plain, target: self, action: #selector(self.skip_continueAction))
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

extension GradingProcessViewController: GradingProcessDelegate {
    func updateRightButtonTitle(_ title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.skip_continueAction))
    }
    
    func didFinishGradingProcess() {
        navigationController?.pushViewController(LotCompleteViewController.instantiate(from: .schedule), animated: true)
    }
}
