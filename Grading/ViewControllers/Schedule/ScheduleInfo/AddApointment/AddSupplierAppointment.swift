//
//  AddSupplierAppointment.swift
//  Grading
//
//  Created by Aira on 16.03.2021.
//

import UIKit
import SVProgressHUD

protocol AddSupplierAppointmentDelegate {
    func didDismiss(supplier: Supplier)
}

class AddSupplierAppointment: UIViewController {

    @IBOutlet weak var supplierTF: UITableView!
    
    var suppliers: [Supplier] = [Supplier]()
    var isSelected: [Bool] = [Bool]()
    var selectedSupplier: Supplier = Supplier()
    
    var delegate: AddSupplierAppointmentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        supplierTF.delegate = self
        supplierTF.dataSource = self
        initData()
    }
    
    func initData() {
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
                    self.isSelected.append(false)
                }
                self.suppliers.sort() {
                    $0.name < $1.name
                }
                self.supplierTF.reloadData()
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
    
    @IBAction func onTapCancelUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapDone(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didDismiss(supplier: self.selectedSupplier)
        }
    }
    
}

extension AddSupplierAppointment: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelected[indexPath.row] = true
        self.selectedSupplier = suppliers[indexPath.row]
        for index in 0..<isSelected.count {
            if index != indexPath.row {
                isSelected[index] = false
            }
        }
        supplierTF.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suppliers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSupplierCell", for: indexPath) as! AddSupplierCell
        cell.nameLB.text = suppliers[indexPath.row].name
        cell.icCheck.isHidden = !isSelected[indexPath.row]
        return cell
    }
}

class AddSupplierCell: UITableViewCell {
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var icCheck: UIImageView!
}
