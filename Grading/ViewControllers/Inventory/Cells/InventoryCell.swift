//
//  InventoryCell.swift
//  Grading
//


import UIKit

class InventoryCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ctrWidthViewDelete: NSLayoutConstraint!
    @IBOutlet weak var ctrLeftMainView: NSLayoutConstraint!
    @IBOutlet weak var ctrRightMainView: NSLayoutConstraint!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbApp: UILabel!
    @IBOutlet weak var lbList: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbMix: UILabel!
    
    var inventory: Inventory? = nil {
        didSet {
            self.setData()
        }
    }
    var onDeletedInventory: ((Inventory) ->())?

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
    
    func setData() {
        guard let inventory = inventory else {
            return
        }
        self.lbDate.text = inventory.date.string(withFormat: "yyyy-MM-dd")
        self.lbTitle.text = inventory.title
        self.lbApp.text = inventory.appraised.string
        self.lbList.text = inventory.list.string
        self.lbMix.text = "Mixed Material · \(inventory.mixedMaterial) g"
        self.lbPrice.text = inventory.totalValue.string.dola()
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
        if let inventory = self.inventory {
            self.onDeletedInventory?(inventory)
        }
    }
}
