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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
    
    private func showEditView() {
        let controller = GradingProcessViewController.instantiate(from: .schedule)
        controller.isEditingViewType = true
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

extension JobInventoryPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobInventories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobInventoryTableViewCell.identifier, for: indexPath) as! JobInventoryTableViewCell
        cell.setup(jobInventories[indexPath.row], indexPath: indexPath)
        cell.delegate = self
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
                self.showEditView()
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

extension JobInventoryPreviewViewController: JobInventoryTableViewCellDelegate {
    func undoAction(at indexPath: IndexPath) {
        self.jobInventories[indexPath.row].toggle()
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
