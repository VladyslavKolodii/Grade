//
//  Faq.swift
//  Grading
//
//  Created by Viet Tuan on 13/03/2021.
//

import Foundation
import SwiftyJSON

class Faq {
    var id: Int = 0
    var question: String = ""
    var answer: String = ""

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.question = json["question"].stringValue
        self.answer = json["answer"].stringValue
    }
}
