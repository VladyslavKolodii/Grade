//
//  FaqCell.swift
//  Grading
//


import UIKit

class FaqCell: UITableViewCell {

    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbAnswer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

