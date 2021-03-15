//
//  SupplierVC.swift
//  Grading
//


import UIKit
import SVProgressHUD
import SwiftyJSON
class SuppliersVC: BaseVC {
    
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    var sections = [SupplierSection]()
    var suppliers = [Supplier]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.getSupplierList()
    }
    
    func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = "Suppliers"
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tbMain.refreshControl = refreshControl
    }
    
    @objc func refreshData(refreshControl: UIRefreshControl) {
        self.getSupplierList()
        refreshControl.endRefreshing()
    }
    
    func filterDatas() {
        var users = [Supplier]()
        if let text = tfSearch.text, !text.isEmpty {
            users = suppliers.filter({ obj -> Bool in
                obj.name.lowercased().range(of: text.lowercased()) != nil
            })
        } else {
            users = suppliers
        }
        let groupedDictionary = Dictionary(grouping: users, by: {String($0.name.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        self.sections = keys.map{ SupplierSection(letter: $0, supplier: groupedDictionary[$0]!.sorted(by: ({$0.name < $1.name}))) }
        self.tbMain.reloadData()
    }
    
    func initSections() {
        self.sections.removeAll()
        let groupedDictionary = Dictionary(grouping: suppliers, by: {String($0.name.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        self.sections = keys.map{ SupplierSection(letter: $0, supplier: groupedDictionary[$0]!.sorted(by: ({$0.name < $1.name}))) }
    }
}

extension SuppliersVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath) as! SupplierCell
        let section = sections[indexPath.section]
        let supplier = section.supplier[indexPath.row]
        cell.lbName.text = supplier.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierHeaderCell") as! SupplierHeaderCell
        cell.lbTitle.text = sections[section].letter
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].supplier.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters.map{$0.uppercased()}
    }
}

extension SuppliersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let supplier = section.supplier[indexPath.row]
        self.getSupplierDetail(supplier: supplier) {
            let vc = SupplierProfileVC.instantiate(from: .suppliers)
            vc.hidesBottomBarWhenPushed = true
            vc.supplier = supplier
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension SuppliersVC: UITextFieldDelegate {
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
extension SuppliersVC {
    func getSupplierList(completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getSupplierList { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"].arrayValue
                self.suppliers.removeAll()
                for object in response {
                    let supplier = Supplier(object)
                    self.suppliers.append(supplier)
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
    
    func getSupplierDetail(supplier:Supplier, completion: (() -> Void)? = nil) {
        let service = AppService()
        SVProgressHUD.show()
        service.getSupplierDetail(id: supplier.id) { json in
            let statusCode = json["status"].intValue
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                let response = json["response"]
                supplier.mapInfoData(response)
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
