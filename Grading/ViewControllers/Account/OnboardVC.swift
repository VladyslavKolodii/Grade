//
//  OnboardVC.swift
//  Grading
//


import UIKit

class OnboardVC: UIViewController {

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
    

    func configureView() {
        
        
    }
    
    func showTabs() {
        
        Util.showTabbar()
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
