//
//  User.swift
//  Grading
//
//  Created by Viet Tuan on 13/03/2021.
//

import Foundation
import SwiftyJSON

class UserInfo {
    var id: Int = 0
    var name: String = ""
    var role: String = ""
    var email: String = ""
    var image: String = ""
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.role = json["role"].stringValue
        self.email = json["email"].stringValue
        self.image = json["image"].stringValue
    }
}
