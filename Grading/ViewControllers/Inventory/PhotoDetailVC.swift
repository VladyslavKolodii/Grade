//
//  PhotosController.swift
//  Demo
//
//

import UIKit
import Kingfisher
class PhotoDetailVC: UIViewController {
    
    //MARK:- @IBOutlet Variables
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var  scrollView: UIScrollView!
    
    var imagesArray:[String] = [String]()
    var index: Int = 0
    
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
            self.pageControl.currentPage = self.index
            if self.index != 0 {
                self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.pageControl!.currentPage)*Screen.width, y: -50), animated: false)
            }
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
    
    @IBAction func onTapBackUB(_sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PhotoDetailVC: UIScrollViewDelegate {
    
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
            imageView.contentMode = .scaleToFill
            let url = URL(string: obj)
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ic_slide_document_empty"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    imageView.image = value.image
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    imageView.image = UIImage(named: "ic_slide_document_empty")
                }
            }
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
