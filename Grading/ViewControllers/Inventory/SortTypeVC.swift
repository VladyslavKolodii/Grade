//
//  SortTypeVC.swift
//  Grading
//


import UIKit

class SortTypeVC: BaseVC {

    @IBOutlet weak var tbMain: UITableView!
    var onValueChanged: ((SortType) ->())?
    var sortSelected: SortType = .date

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sortSelected = FilterTypeData.sortSelected
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        self.onValueChanged?(sortSelected)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SortTypeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
        let type = FilterTypeData.listSorts[indexPath.row]
        cell.lbTilte.text = type.rawValue
        cell.isSelectedType = sortSelected == type
        return cell

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterTypeData.listSorts.count
    }
 }

extension SortTypeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sortSelected = FilterTypeData.listSorts[indexPath.row]
        self.tbMain.reloadData()
    }
}

