//
//  GradingPhotoGuideVC.swift
//  Grading
//


import UIKit

class GradingPhotoGuideVC: UIViewController {

    @IBOutlet weak var pageLB: UILabel!
    @IBOutlet weak var containUV: UIView!
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages: [UIViewController] = []
    private var currentIndex: Int = 0 {
        didSet {
            pageLB.text = "\(currentIndex + 1)/9"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupPageController() {
        
        for i in 0..<9 {
            let itemVC1 = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "GuidePhotoItemVC") as! GuidePhotoItemVC
            itemVC1.strIndex = "\(i + 1)"
            self.pages.append(itemVC1)
        }
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.pageController.view.frame = CGRect(x: 0,y: 0,width: self.containUV.frame.width, height: self.containUV.frame.height)
        self.addChild(self.pageController)
        self.containUV.addSubview(self.pageController.view)
        let initialVC = pages[0]
        
        self.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        self.pageController.didMove(toParent: self)
        
        for v in pageController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).isScrollEnabled = false
            }
        }
    }

    @IBAction func onTapCloseUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapNextUB(_ sender: Any) {
        if currentIndex >= pages.count - 1 {
            return
        }
        currentIndex += 1
        pageController.setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func onTapPreUB(_ sender: Any) {
        if currentIndex == 0 {
            return
        }
        currentIndex -= 1
        pageController.setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
    }
}

extension GradingPhotoGuideVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
