//
//  InventoryVC.swift
//  Grading
//

import UIKit

class InventoryVC: BaseVC {
    
    @IBOutlet weak var tbMain: UITableView!
    
    let sections = ["From Today (09/15/2020)", "From This Week (09/13 - 09/19)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = "Inventory"
        self.tbMain.reloadData()
    }
    @IBAction func filterTap(_ sender: Any) {
    }
    
}

extension InventoryVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierHeaderCell") as! SupplierHeaderCell
        cell.lbTitle.text = sections[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

 }

extension InventoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
