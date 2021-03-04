//
//  InventoryCell.swift
//  Grading
//
//  Created by Viet Tuan on 20/02/2021.
//

import UIKit

class InventoryCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ctrWidthViewDelete: NSLayoutConstraint!
    @IBOutlet weak var ctrLeftMainView: NSLayoutConstraint!
    @IBOutlet weak var ctrRightMainView: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeleft(sender:)))
        swipeleft.direction = .left
        self.addGestureRecognizer(swipeleft)
        
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiperight(sender:)))
        swiperight.direction = .right
        self.addGestureRecognizer(swiperight)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func swiperight(sender: UITapGestureRecognizer? = nil) {
        self.ctrLeftMainView.constant = 0
        self.ctrRightMainView.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeleft(sender: UITapGestureRecognizer? = nil) {
        self.ctrLeftMainView.constant = -ctrWidthViewDelete.constant
        self.ctrRightMainView.constant = ctrWidthViewDelete.constant
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func shareTap(_ sender: Any) {
        self.swiperight()
    }
    
    @IBAction func editTap(_ sender: Any) {
        self.swiperight()
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        self.swiperight()
    }
}
