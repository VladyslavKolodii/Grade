//
//  InventoryVC.swift
//  Grading
//

import UIKit

struct Inventory {
    let letter : String
    let titles : [String]
}

class InventoryVC: BaseVC {
    
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var tfSearch: UITextField!

    let titles = ["Aernier Inc", "Akiles Group", "Aoehm Extracts", "Bahringer Supply Co.", "Batterfield Growers", "Busche Gardens", "Cahringer Supply Co.","Catterfield Growers"]
    var inventories = [Inventory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = "Inventory"
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        let keys = ["From Today (09/15/2020)", "From This Week (09/13 - 09/19)"]
        inventories = keys.map{ Inventory(letter: $0, titles: titles) }
        self.tbMain.reloadData()
    }
    
    func filterDatas() {
        inventories = [Inventory]()
        var users = [String]()
        if let text = tfSearch.text, !text.isEmpty {
            users = titles.filter({ obj -> Bool in
                obj.lowercased().range(of: text.lowercased()) != nil
            })
        } else {
            users = titles
        }
        if users.count > 0 {
            let keys = ["From Today (09/15/2020)", "From This Week (09/13 - 09/19)"]
            inventories = keys.map{ Inventory(letter: $0, titles: users) }
        }
        self.tbMain.reloadData()
    }
    
    @IBAction func filterTap(_ sender: Any) {
        let vc = FilterInventoryVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
}

extension InventoryVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return inventories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        let section = inventories[indexPath.section]
        let title = section.titles[indexPath.row]
        cell.lbTitle.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierHeaderCell") as! SupplierHeaderCell
        cell.lbTitle.text = inventories[section].letter
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventories[section].titles.count
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

extension InventoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.filterDatas()
        return true
    }
    @objc func textFieldDidChange(textField: UITextField){
        self.filterDatas()
    }
}
