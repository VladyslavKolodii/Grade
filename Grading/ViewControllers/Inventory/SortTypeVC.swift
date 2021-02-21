//
//  SortTypeVC.swift
//  Grading
//
//  Created by Viet Tuan on 21/02/2021.
//

import UIKit

class SortTypeVC: BaseVC {

    @IBOutlet weak var tbMain: UITableView!
    let types = ["Date Graded", "Price","Total Grade", "Product Type","Grader", "Quantity"]
    
    var onValueChanged: ((String) ->())?
    var value: String = "Date Graded"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        self.onValueChanged?(value)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SortTypeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
        cell.lbTilte.text = types[indexPath.row]
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

 }

extension SortTypeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        value = types[indexPath.row]
    }
}
