//
//  SupplierVC.swift
//  Grading
//
//  Created by Viet Tuan on 19/02/2021.
//

import UIKit

struct Supplier {
    let letter : String
    let names : [String]
}

class SuppliersVC: BaseVC {
    
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    let userNames = ["Aernier Inc", "Akiles Group", "Aoehm Extracts", "Bahringer Supply Co.", "Batterfield Growers", "Busche Gardens", "Cahringer Supply Co.","Catterfield Growers"]
    var suppliers = [Supplier]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = "Suppliers"
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        let groupedDictionary = Dictionary(grouping: userNames, by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        suppliers = keys.map{ Supplier(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        self.tbMain.reloadData()
        
    }
    
    func filterDatas() {
        var users = [String]()
        if let text = tfSearch.text, !text.isEmpty {
            users = userNames.filter({ obj -> Bool in
                obj.lowercased().range(of: text.lowercased()) != nil
            })
        } else {
            users = userNames
        }
        let groupedDictionary = Dictionary(grouping: users, by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        suppliers = keys.map{ Supplier(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        self.tbMain.reloadData()
    }
    
}

extension SuppliersVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return suppliers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath) as! SupplierCell
        let section = suppliers[indexPath.section]
        let username = section.names[indexPath.row]
        cell.lbName.text = username
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierHeaderCell") as! SupplierHeaderCell
        cell.lbTitle.text = suppliers[section].letter
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suppliers[section].names.count
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
        let vc = SupplierProfileVC.instantiate(from: .suppliers)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SuppliersVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.filterDatas()
        return true
    }
    @objc func textFieldDidChange(textField: UITextField){
        print("Text changed")
        self.filterDatas()
    }
}
