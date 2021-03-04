//
//  JobInventoryTableViewCell.swift
//  Grading
//


import UIKit

protocol JobInventoryTableViewCellDelegate: class {
    func undoAction(at indexPath: IndexPath)
}

class JobInventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var overlayView: UIView!
    
    weak var delegate: JobInventoryTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
    }
    
    func setup(_ deleted: Bool, indexPath: IndexPath) {
        self.indexPath = indexPath
        overlayView.alpha = deleted ? 1.0 : 0.0
    }


    @IBAction func didTapUndo(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        delegate?.undoAction(at: indexPath)
    }
}
