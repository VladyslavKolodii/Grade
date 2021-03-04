//
//  ProductTypeCell.swift
//  Grading
//


import UIKit

class ProductTypeCell: UITableViewCell {

    @IBOutlet weak var lbTilte: UILabel!
    @IBOutlet weak var icCheckMark: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icCheckMark.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            icCheckMark.isHidden = false
        } else {
            icCheckMark.isHidden = true
        }
        // Configure the view for the selected state
    }

}
