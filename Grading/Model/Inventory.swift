//
//  Inventory.swift
//  Grading
//
//  Created by Viet Tuan on 14/03/2021.
//

import Foundation
import SwiftyJSON
class Inventory {
    var id: Int = 0
    var title: String = ""
    var date: Date = Date()
    var mixedMaterial: Int = 0
    var appraised: Double = 0
    var list: Double = 0
    var lotId: Int = 0
    var totalValue: Double = 0
    var productType: String = ""
    var totalGrams: Int = 0
    var totalGrade: Int = 0
    var processed: String = ""
    var environment: String = ""
    var appraisedRange: [Double] = [Double]()
    var appraisedPrice: Double = 0
    var listPrice: Double = 0
    var supplier: Supplier?

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.date = json["date"].stringValue.date(withFormat: "yyyy-MM-dd HH:mm:ss") ?? Date()
        self.mixedMaterial = json["mixedMaterial"].intValue
        self.appraised = json["appraised"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
        self.list = json["list"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
        self.totalValue = json["totalValue"].doubleValue.rounded(numberOfDecimalPlaces: 1, rule: .toNearestOrEven)
    }
    func mapInfoData(_ json: JSON) {
        self.productType = json["productType"].stringValue
        self.totalGrams = json["totalGrams"].intValue
        self.totalGrams = json["totalGrams"].intValue
        self.processed = json["processed"].stringValue
        self.environment = json["environment"].stringValue
        let appraisedRanges = json["appraisedRange"].array
        for range in appraisedRanges ?? [] {
            self.appraisedRange.append(range.doubleValue)
        }
        self.appraisedRange.sort(by: {$0 < $1})
        self.appraisedPrice = json["appraisedPrice"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
        self.listPrice = json["listPrice"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
        let suppliers = json["supplier"].array
        let sup = Supplier()
        for item in suppliers ?? [] {
            if let id = item.int {
                sup.id = id
            }
            if let name = item.string {
                sup.name = name
            }
        }
        self.supplier = sup
    }
}
struct InventorySection {
    let date : String
    let inventory : [Inventory]
}
