//
//  OnboardVC.swift
//  Grading
//


import UIKit

class OnboardVC: BaseVC {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    static func storyboardInstance() -> OnboardVC? {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? OnboardVC
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.statusBarStyle = .darkContent
        } else {
            // Fallback on earlier versions
            self.statusBarStyle = .default
        }
    }

    func configureView() {
        
        
    }
    
    func showTabs() {
        
        Util.changeTabbarToRoot()
    }
    
    //MARK: - USER INTERACTION
    
    @IBAction func previousTap(_ sender: Any) {
        
        if pageControl.currentPage > 0 {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl!.currentPage-1)*Screen.width, y: 0), animated: true)
        }
    }
    
    @IBAction func nextTap(_ sender: Any) {
        
        if pageControl.currentPage < 2 {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl!.currentPage+1)*Screen.width, y: 0), animated: true)
        }
        else {
            showTabs()
        }
    }
    
    @IBAction func skipTap(_ sender: Any) {
        
        showTabs()
    }

    @IBAction func pageControlDidChange(_ sender: Any) {
        
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl!.currentPage)*Screen.width, y: 0), animated: true)
    }
    
}

extension OnboardVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = (scrollView.contentOffset.x / Screen.width)
        pageControl?.currentPage = Int(currentPage)
    }
}
