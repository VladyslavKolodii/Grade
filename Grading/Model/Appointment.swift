//
//  Appointment.swift
//  Grading
//
//  Created by Aira on 15.03.2021.
//

import Foundation
import SwiftyJSON

class Appointment: NSObject {
    var id: Int = 0
    var title: String = ""
    var time: String = ""
    var location: String = ""
    var note: String = ""
    var suppliers: [SupplierInfo] = [SupplierInfo]()
    
    func initWithJSON(obj: JSON) {
        id = obj["id"].intValue
        title = obj["title"].stringValue
        let strDateTime = obj["time"].stringValue
        let dateTime = strDateTime.stringToDate(format: "yyyy-MM-dd HH:mm:ss")
        time = dateTime.dateToString(format: "MMM dd, HH:mm a")
        location = obj["location"].stringValue
        note = obj["note"].stringValue
        let supplierArr = obj["supplierObj"].arrayValue
        for supplier in supplierArr {
            let supplierModel: SupplierInfo = SupplierInfo(supplier)
            suppliers.append(supplierModel)
        }
    }
}
