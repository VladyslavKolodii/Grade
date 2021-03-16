//
//  PhotosController.swift
//  Demo
//
//

import UIKit

class PhotoControlVC: UIViewController {
    
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var  scrollView: UIScrollView!
    @IBOutlet weak var nextUB: UIButton!
    @IBOutlet weak var preUB: UIButton!
    
    var imagesArray:[String]?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    //MARK:- App lifeCycle:------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let array = imagesArray {
            pageControl.numberOfPages = array.count > 1 ? array.count : 0
            preUB.isHidden = array.count > 1 ? false : true
            nextUB.isHidden = true
        } else {
            pageControl.numberOfPages = 0
            preUB.isHidden = true
            nextUB.isHidden = true
        }
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        DispatchQueue.main.async {
            self.addScrollImages(arrayImages: self.imagesArray!)
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
extension PhotoControlVC: UIScrollViewDelegate {
    
    func addScrollImages(arrayImages: [String]) {
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
            imageView.loadImage(url: RequestInfoFactory.rootURL + obj)
            imageView.clipsToBounds = true
            
            let locationLB = UILabel()
            locationLB.frame = CGRect(x: xPosition, y: scrollView.frame.height - 240, width: scrollView.frame.width, height: 120)
            locationLB.text = "N 142.1234 \nW 34.1239"
            locationLB.font = .systemFont(ofSize: 18.0)
            locationLB.textColor = .white
            locationLB.textAlignment = .center
            locationLB.numberOfLines = 2
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            scrollView.addSubview(locationLB)
            scrollView.delegate = self
            i = i + 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}
