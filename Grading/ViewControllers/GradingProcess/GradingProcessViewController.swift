//
//  GradingProcessViewController.swift
//  Grading
//


import UIKit

protocol GradingProcessDelegate: class {
    func didFinishGradingProcess()
}

class GradingProcessViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var leftUB: UIButton!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var rightUB: UIButton!
    @IBOutlet weak var topbarheight: NSLayoutConstraint!
    @IBOutlet weak var bottombarheight: NSLayoutConstraint!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    private var pageTitle: [String] = []
    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            titleLB.text = pageTitle[currentIndex]
        }
    }
    
    var isEditingViewType: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    
    @IBAction func backStepAction(_ sender: Any) {
        showPreItem()
    }
    
    func showPreItem() {
        guard currentIndex > 0 else {
            dismiss(animated: true, completion: nil)
            return
        }
        currentIndex -= 1
        if currentIndex == 2 {
            self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height)
            bottombarheight.constant = 0
            topbarheight.constant = 0
        } else {
            self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width, height: self.containerView.frame.height)
            bottombarheight.constant = 51
            topbarheight.constant = 100
        }
        pageController.setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func nextStepAction(_ sender: Any) {
        showNextItem()
    }
    
    func showNextItem() {
        guard currentIndex < pages.count-1 else {
            if isEditingViewType {
                self.showToast("Update Successful")
                DispatchQueue.main.asyncAfter(deadline: .now() + ToastManager.shared.duration) {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            navigationController?.pushViewController(LotCompleteViewController.instantiate(from: .schedule), animated: true)
            return
        }
        currentIndex += 1
        if currentIndex == 2 {
            self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height)
            bottombarheight.constant = 0
            topbarheight.constant = 0
        } else {
            self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containerView.frame.width, height: self.containerView.frame.height)
            bottombarheight.constant = 51
            topbarheight.constant = 100
        }
        pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        showNextItem()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GradingProcessViewController {
    
    private func setupPageController() {
        
        let inventoryVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingInventoryVC") as! GradingInventoryVC

        let productVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingProductVC") as! GradingProductVC

        let materialPhotosVC = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GradingMaterialCaptureVC") as! GradingMaterialCaptureVC
        materialPhotosVC.delegate = self
        
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
        
        self.titleLB.text = pageTitle[0]
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

extension GradingProcessViewController: GradingMaterialCaptureVCDelegate {
    func didCompleteCapture() {
        showNextItem()
    }
    
    func didTapSkipUB() {
        showNextItem()
    }

    func didTapBackUB() {
        showPreItem()
    }
}

extension GradingProcessViewController: GradingProcessDelegate {
    func didFinishGradingProcess() {
        showNextItem()
    }
}

