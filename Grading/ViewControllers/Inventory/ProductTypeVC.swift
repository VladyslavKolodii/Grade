//
//  ProductTypeVC.swift
//  Grading
//


import UIKit

class ProductTypeVC: BaseVC {


    @IBOutlet weak var segment: WMSegment!
    @IBOutlet weak var tbMaster: UITableView!
    @IBOutlet weak var tbExtract: UITableView!
    var onValueChanged: (([FilterType]) ->())?

    var masters = [FilterType]()
    var extracts = [FilterType]()
    var selectedValues = [FilterType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
        self.setupData()
        self.tbMaster.reloadData()
        self.tbExtract.reloadData()
    }

    func setupData() {
        let types = FilterTypeData.listProductTypes.filter({$0.parentId == 0})
        for type in types {
            if type.name.lowercased().hasSuffix("Matter".lowercased()) {
                masters = FilterTypeData.listProductTypes.filter({$0.parentId == type.id})
            } else {
                extracts = FilterTypeData.listProductTypes.filter({$0.parentId == type.id})
            }
        }
    }
    
    func configureView() {
        self.segment.selectedFont = UIFont.appFontBold(ofSize: 14)
        self.segment.normalFont = UIFont.appFontBold(ofSize: 14)
        segment.onValueChanged = { [self] index in
            if index == 0 {
                tbMaster.isHidden = false
                tbExtract.isHidden = true
            } else {
                tbMaster.isHidden = true
                tbExtract.isHidden = false
            }
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        self.onValueChanged?(selectedValues)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProductTypeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbMaster {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
            let type = masters[indexPath.row]
            cell.lbTilte.text = type.name
            cell.isSelectedType = selectedValues.contains(where: {$0.id == type.id})
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
            let type = extracts[indexPath.row]
            cell.lbTilte.text = type.name
            cell.isSelectedType = selectedValues.contains(where: {$0.id == type.id})
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbMaster {
            return masters.count
        } else {
            return extracts.count
        }
    }

 }

extension ProductTypeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbMaster {
            let type = masters[indexPath.row]
            if let index = selectedValues.firstIndex(where: {$0.id == type.id}) {
                selectedValues.remove(at: index)
            } else {
                selectedValues.append(type)
            }
        } else {
            let type = extracts[indexPath.row]
            if let index = selectedValues.firstIndex(where: {$0.id == type.id}) {
                selectedValues.remove(at: index)
            } else {
                selectedValues.append(type)
            }
        }
        tableView.reloadData()
    }
}
