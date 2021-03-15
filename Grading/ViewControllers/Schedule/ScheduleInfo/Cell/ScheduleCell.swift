//
//  ScheduleCell.swift
//  Grading
//


import UIKit

protocol ScheduleCellDelegate {
    func didTapActionUB(id: Int)
}

class ScheduleCell: UITableViewCell {
    
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    var delegate: ScheduleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func onTapActionBtn(_ sender: Any) {
        delegate?.didTapActionUB(id: btnAction.tag)
    }
}
