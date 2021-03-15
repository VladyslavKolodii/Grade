//
//  GradingPhotoCell.swift
//  Grading
//

import UIKit

protocol GradingPhotoCellDelegate {
    func didTapCloseUB(indexPath: Int)
}

class GradingPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var indexLB: UILabel!
    
    var delegate: GradingPhotoCellDelegate?
    var indexPath: Int?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onTapCloseUB(_ sender: Any) {
        delegate?.didTapCloseUB(indexPath: indexPath!)
    }
}
