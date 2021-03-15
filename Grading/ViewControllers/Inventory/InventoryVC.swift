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
        setupData()
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
    
    func setupData() {
        self.getInventoryList()
        if FilterTypeData.listGraders.count == 0 {
            self.getGrader()
        }
        if FilterTypeData.listProcess.count == 0 {
            self.getProcess()
        }
        if FilterTypeData.listSuppliers.count == 0 {
            self.getSupplier()
        }
        if FilterTypeData.listEnvironments.count == 0 {
            self.getEnvironment()
        }
        if FilterTypeData.listProductTypes.count == 0 {
            self.getProductType()
        }
    }
    
    func initSections() {
        self.sections.removeAll()
        for inventory in inventories {
            if let section = self.sections.first(where: {$0.date == inventory.date.string(withFormat: "yyyy-MM-dd")}) {
                section.inventory.append(inventory)
            } else {
                var array = [Inventory]()
                array.append(inventory)
                let section = InventorySection(date: inventory.date.string(withFormat: "yyyy-MM-dd"), inventory: array)
                self.sections.append(section)
            }
        }
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
            for inventory in datas {
                if let section = self.sections.first(where: {$0.date == inventory.date.string(withFormat: "yyyy-MM-dd")}) {
                    section.inventory.append(inventory)
                } else {
                    var array = [Inventory]()
                    array.append(inventory)
                    let section = InventorySection(date: inventory.date.string(withFormat: "yyyy-MM-dd"), inventory: array)
                    self.sections.append(section)
                }
            }
        }
        self.tbMain.reloadData()
    }
    
    @IBAction func filterTap(_ sender: Any) {
        let vc = FilterInventoryVC.instantiate(from: .inventory)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.onSaveFilter = {
            self.getInventoryList()
        }
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
                self.inventories.removeAll()
                self.initSections()
                self.tbMain.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    func getInventoryDetail(inventory: Inventory, completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getInventoryDetail(id: inventory.id) { json in
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
    func getProductType() {
        let service = AppService()
        service.getFilterList(with: FilterTypeAPI.productType.rawValue) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                FilterTypeData.listProductTypes.removeAll()
                for object in response {
                    let item = FilterType(object)
                    FilterTypeData.listProductTypes.append(item)
                }
            default: break
            }
        }
    }
    func getProcess() {
        let service = AppService()
        service.getFilterList(with: FilterTypeAPI.process.rawValue) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                FilterTypeData.listProcess.removeAll()
                for object in response {
                    let item = FilterType(object)
                    FilterTypeData.listProcess.append(item)
                }
            default: break
            }
        }
    }
    func getEnvironment() {
        let service = AppService()
        service.getFilterList(with: FilterTypeAPI.environment.rawValue) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                FilterTypeData.listEnvironments.removeAll()
                for object in response {
                    let item = FilterType(object)
                    FilterTypeData.listEnvironments.append(item)
                }
            default: break
            }
        }
    }
    func getGrader() {
        let service = AppService()
        service.getFilterList(with: FilterTypeAPI.grader.rawValue) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                FilterTypeData.listGraders.removeAll()
                for object in response {
                    let item = FilterType(object)
                    FilterTypeData.listGraders.append(item)
                }
            default: break
            }
        }
    }
    func getSupplier() {
        let service = AppService()
        service.getFilterList(with: FilterTypeAPI.supplier.rawValue) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                FilterTypeData.listSuppliers.removeAll()
                for object in response {
                    let item = FilterType(object)
                    FilterTypeData.listSuppliers.append(item)
                }
            default: break
            }
        }
    }
}
