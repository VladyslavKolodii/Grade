//
//  Supplier.swift
//  Grading
//
//  Created by Viet Tuan on 13/03/2021.
//

import Foundation
import SwiftyJSON

struct SupplierSection {
    let letter : String
    let supplier : [Supplier]
}

class Supplier {
    var id: Int = 0
    var name: String = "anonymous"
    var info: [SupplierInfo] = [SupplierInfo]()
    var location: String = ""
    var note: String = ""
    var licenseNumber: Int = 0
    var ubi: Int = 0
    var farmPacket: Bool = false
    var networkAgreement: Bool = false
    
    init() {
    
    }

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
    func mapInfoData(_ json: JSON) {
        self.location = json["location"].stringValue
        self.note = json["note"].stringValue
        self.licenseNumber = json["licenseNumber"].intValue
        self.ubi = json["ubi"].intValue
        self.farmPacket = json["farmPacket"].intValue.boolValue
        self.networkAgreement = json["networkAgreement"].intValue.boolValue
        self.info.removeAll()
        let infos = json["supplierObj"].array
        for info in infos ?? [] {
            let supplierInfo = SupplierInfo(info)
            self.info.append(supplierInfo)
        }
    }
}


class SupplierInfo {
    var id: Int = 0
    var name: String = "anonymous"
    var phoneNumber: String = ""
    var textNumber: String = ""
    var email: String = ""
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.phoneNumber = json["phoneNumber"].stringValue
        self.textNumber = json["textNumber"].stringValue
        self.email = json["email"].stringValue
    }
}
