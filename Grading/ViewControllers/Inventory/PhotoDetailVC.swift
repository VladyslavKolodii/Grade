//
//  PhotosController.swift
//  Demo
//
//

import UIKit

class PhotoDetailVC: UIViewController {
    
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var  scrollView: UIScrollView!
    
    let imagesArray:[UIImage] = [#imageLiteral(resourceName: "img3"),#imageLiteral(resourceName: "img2")]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    //MARK:- App lifeCycle:------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pageControl.numberOfPages = imagesArray.count
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        DispatchQueue.main.async {
            self.addScrollImages(arrayImages: self.imagesArray)
        }
    }
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        if pageControl.currentPage > 0 {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl!.currentPage-1)*Screen.width, y: -50), animated: true)
        }
    }
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        if pageControl.currentPage < 1 {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl!.currentPage+1)*Screen.width, y: -50), animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func onTapBackUB(_sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PhotoDetailVC: UIScrollViewDelegate {
    
    func addScrollImages(arrayImages: [UIImage]) {
        scrollView.isPagingEnabled = true
        pageControl.numberOfPages = arrayImages.count
        self.pageControl.isHidden = false
        if arrayImages.count == 1 {
            self.pageControl.isHidden = true
        }
        var i = 0
        arrayImages.forEach { (obj) in
            let imageView = UIImageView()
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: -40, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageView.image = obj
            imageView.clipsToBounds = true
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            scrollView.delegate = self
            i = i + 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}
