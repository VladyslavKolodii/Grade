//
//  SortTypeVC.swift
//  Grading
//


import UIKit

class SoldTypeVC: BaseVC {

    @IBOutlet weak var tbMain: UITableView!
    var soldSelected: SoldType?
    var onValueChanged: ((SoldType?) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        soldSelected = FilterTypeData.soldSelected
        self.tbMain.reloadData()
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        self.onValueChanged?(soldSelected)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SoldTypeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
        let type = FilterTypeData.listSolds[indexPath.row]
        cell.lbTilte.text = type.rawValue
        cell.isSelectedType = soldSelected == type
        return cell

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterTypeData.listSolds.count
    }
 }

extension SoldTypeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soldSelected = FilterTypeData.listSolds[indexPath.row]
        self.tbMain.reloadData()
    }
}

