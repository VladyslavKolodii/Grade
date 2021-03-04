//
//  ProductTypeVC.swift
//  Grading
//


import UIKit

class ProductTypeVC: BaseVC {


    @IBOutlet weak var segment: WMSegment!
    @IBOutlet weak var tbMaster: UITableView!
    @IBOutlet weak var tbExtract: UITableView!
    var onValueChanged: (([String]) ->())?

    let masters = ["A-Flower", "B-Flower","Trim", "Mixed Material","Fan Leaf", "Fresh Frozen","Clone", "Crude","Pre-Roll", "Other"]
    let extracts = ["Crumble", "Diamonds","Shatter", "Wax","Kief", "Live Resin","RSO", "Distillate","Other"]
    var selectedValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
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
            cell.lbTilte.text = masters[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath) as! ProductTypeCell
            cell.lbTilte.text = extracts[indexPath.row]
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
            let value = masters[indexPath.row]
            if !selectedValues.contains(value) {
                selectedValues.append(value)
            } else {
                selectedValues.removeAll(value)
            }
        } else {
            let value = extracts[indexPath.row]
            if !selectedValues.contains(value) {
                selectedValues.append(value)
            } else {
                selectedValues.removeAll(value)
            }
        }
    }
}
