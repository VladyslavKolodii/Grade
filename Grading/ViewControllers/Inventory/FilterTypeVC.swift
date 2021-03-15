//
//  SortTypeVC.swift
//  Grading
//


import UIKit

class FilterTypeVC: BaseVC {
    
    @IBOutlet weak var tbMain: UITableView!
    var filterTypeAPI: FilterTypeAPI = .productType
    var arrSelected = [FilterType]()
    var arrData = [FilterType]()
    var onValueChanged: ((FilterTypeAPI,[FilterType]) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupData()
        self.tbMain.reloadData()
    }
    
    func setupData() {
        switch filterTypeAPI {
        case .process:
            arrData = FilterTypeData.listProcess
        case .environment:
            arrData = FilterTypeData.listEnvironments
        case .grader:
            arrData = FilterTypeData.listGraders
        case .supplier:
            arrData = FilterTypeData.listSuppliers
        default: break
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        self.onValueChanged?(filterTypeAPI,arrSelected)
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterTypeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
        let type = arrData[indexPath.row]
        cell.lbTilte.text = type.name
        cell.isSelectedType = arrSelected.contains(where: {$0.id == type.id})
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
}

extension FilterTypeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = arrData[indexPath.row]
        if filterTypeAPI == .environment {
            arrSelected.removeAll()
        }
        if let index = arrSelected.firstIndex(where: {$0.id == type.id}) {
            arrSelected.remove(at: index)
        } else {
            arrSelected.append(type)
        }
        self.tbMain.reloadData()
    }
}
