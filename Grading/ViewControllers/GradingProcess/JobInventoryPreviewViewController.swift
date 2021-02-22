//
//  JobInventoryPreviewViewController.swift
//  Grading
//
//  Created by QTS Coder on 2/22/21.
//

import UIKit

class JobInventoryPreviewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var jobInventories: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobInventories = [Bool](repeating: false, count: 10)
        setupTableView()
    }
    
    @IBAction func addMoreInventoryAction(_ sender: Any) {
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension JobInventoryPreviewViewController {
    private func setupTableView() {
        tableView.registerNibCell(identifier: JobInventoryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.contentInset.top = 16
    }
}

extension JobInventoryPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobInventories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobInventoryTableViewCell.identifier, for: indexPath) as! JobInventoryTableViewCell
        cell.overlayView.alpha = jobInventories[indexPath.row] ? 1.0 : 0.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < jobInventories.count else { return nil }
        
        if jobInventories[indexPath.row] == true {
            let undoAction = UIContextualAction(style: .normal, title: nil, handler: { (action, view, completionHandler) in
                self.jobInventories[indexPath.row].toggle()
                self.tableView.reloadRows(at: [indexPath], with: .none)
                completionHandler(true)
            })
            
            undoAction.backgroundColor = UIColor.white
            undoAction.image = UIImage(named: "editAction_undo")
            
            let configuration = UISwipeActionsConfiguration(actions: [undoAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
            
        } else {
            let deleteAction = UIContextualAction(style: .normal, title: nil, handler: { (action, view, completionHandler) in
                self.jobInventories[indexPath.row].toggle()
                self.tableView.reloadRows(at: [indexPath], with: .none)
                completionHandler(true)
            })
            
            let shareAction = UIContextualAction(style: .normal, title: nil, handler: { (action, view, completionHandler) in
                self.navigationController?.view.makeToast("Share Action")
                completionHandler(true)
            })
            
            let editAction = UIContextualAction(style: .normal, title: nil, handler: { (action, view, completionHandler) in
                self.showToast("Edit Action")
//                self.navigationController?.view.makeToast("Edit Action")
                completionHandler(true)
            })

            deleteAction.backgroundColor = UIColor(named: "DestructiveAction") ?? UIColor.init(hex: "FF453A")
            shareAction.backgroundColor = UIColor(named: "Gray5") ?? UIColor.init(hex: "212121")
            editAction.backgroundColor = UIColor(named: "Gray5") ?? UIColor.init(hex: "212121")
            
            deleteAction.image = UIImage(named: "editAction_delete")
            shareAction.image = UIImage(named: "editAction_share")
            editAction.image = UIImage(named: "editAction_edit")
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, shareAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration

        }
        
        
    }
}
