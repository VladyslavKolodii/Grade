//
//  InventoryVC.swift
//  Grading
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class InventoryVC: BaseVC {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var addMoreButton: UIButton!
    
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var isPreviewJobInventory: Bool = false
    
    var sections = [InventorySection]()
    var inventories = [Inventory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.getInventoryList()
    }
    
    func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.text = isPreviewJobInventory ? "Job Inventory" : "Inventory"
        self.navigationItem.title = isPreviewJobInventory ? "Job Inventory" : "Inventory"
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        doneButton.isHidden = !isPreviewJobInventory
        addMoreButton.isHidden = !isPreviewJobInventory
        filterButton.isHidden = isPreviewJobInventory
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tbMain.refreshControl = refreshControl
    }
    
    @objc func refreshData(refreshControl: UIRefreshControl) {
        self.getInventoryList()
        refreshControl.endRefreshing()
    }
    
    func initSections() {
        let groupedDictionary = Dictionary(grouping: inventories, by: {$0.date.string(withFormat: "yyyy-MM-dd")})
        let keys = groupedDictionary.keys.sorted()
        self.sections = keys.map{ InventorySection(date: $0, inventory: groupedDictionary[$0]!.sorted(by: ({$0.id < $1.id}))) }
        self.tbMain.reloadData()
    }
    
    func filterDatas() {
        var datas = [Inventory]()
        self.sections.removeAll()
        if let text = tfSearch.text, !text.isEmpty {
            datas = inventories.filter({ obj -> Bool in
                obj.title.lowercased().range(of: text.lowercased()) != nil
            })
        } else {
            datas = inventories
        }
        if datas.count > 0 {
            let groupedDictionary = Dictionary(grouping: datas, by: {$0.date.string(withFormat: "yyyy-MM-dd")})
            let keys = groupedDictionary.keys.sorted()
            self.sections = keys.map{ InventorySection(date: $0, inventory: groupedDictionary[$0]!.sorted(by: ({$0.id < $1.id}))) }
        }
        self.tbMain.reloadData()
    }
    
    @IBAction func filterTap(_ sender: Any) {
        let vc = FilterInventoryVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func addMoreAction(_ sender: Any) {
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension InventoryVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        let section = sections[indexPath.section]
        let inventory = section.inventory[indexPath.row]
        cell.inventory = inventory
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isPreviewJobInventory {
            return nil
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierHeaderCell") as! SupplierHeaderCell
        cell.lbTitle.text = sections[section].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].inventory.count
    }
}

extension InventoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isPreviewJobInventory {
            return CGFloat.leastNonzeroMagnitude
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let section = sections[indexPath.section]
//        let inventory = section.inventory[indexPath.row]
//        self.getInventoryDetail(inventory: inventory) {
//            let vc = ProductDetailVC.instantiate(from: .inventory)
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        let vc = ProductDetailVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

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

// MARK: Webservice
extension InventoryVC {
    func getInventoryList(completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getInventoryList { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                self.inventories.removeAll()
                for object in response {
                    let inventory = Inventory(object)
                    self.inventories.append(inventory)
                }
                self.initSections()
                self.tbMain.reloadData()
            default:
                if let message = json["messages"].string{
                    self.showErrorAlert(message: message)
                } else {
                    self.showErrorAlert(message: "Something went wrong. Please try again.")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func getInventoryDetail(inventory: Inventory, completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getInventoryDetail(id: 5) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"]
                inventory.mapInfoData(response)
                completion?()
            default:
                if let message = json["messages"].string{
                    self.showErrorAlert(message: message)
                } else {
                    self.showErrorAlert(message: "Something went wrong. Please try again.")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}
