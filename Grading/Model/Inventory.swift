//
//  Inventory.swift
//  Grading
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
    var lotId: String = ""
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
    var images: [String] = [String]()

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.date = json["date"].stringValue.date(withFormat: "yyyy-MM-dd HH:mm:ss") ?? Date()
        self.mixedMaterial = json["mixedMaterial"].intValue
        self.appraised = json["appraised"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
        self.list = json["list"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
        self.totalValue = json["totalValue"].doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven)
    }
    func mapInfoData(_ json: JSON) {
        self.lotId = json["lotId"].stringValue
        self.productType = json["productType"].stringValue
        self.totalGrams = json["totalGrams"].intValue
        self.totalGrams = json["totalGrams"].intValue
        self.processed = json["processed"].stringValue
        self.environment = json["environment"].stringValue
        let appraisedRanges = json["appraisedRange"].array
        self.appraisedRange.removeAll()
        for range in appraisedRanges ?? [] {
            self.appraisedRange.append(range.doubleValue.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrEven))
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
        self.images.removeAll()
        let imgs = json["img"].array
        for url in imgs ?? [] {
            self.images.append(url.stringValue)
        }
    }
}
class InventorySection {
    var date : String = ""
    var inventory : [Inventory] = [Inventory]()
    
    init(date: String, inventory : [Inventory]) {
        self.date = date
        self.inventory = inventory
    }
}

class FilterType {
    var id: Int = 0
    var name: String = ""
    var parentId: Int = 0
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.parentId = json["parent_id"].intValue
    }
}

struct FilterTypeData {
    static var listGraders: [FilterType] = [FilterType]()
    static var listSuppliers: [FilterType] = [FilterType]()
    static var listSorts: [SortType] = SortType.allCases
    static var listProductTypes: [FilterType] = [FilterType]()
    static var listProcess: [FilterType] = [FilterType]()
    static var listEnvironments: [FilterType] = [FilterType]()
    static var listSolds: [SoldType] = SoldType.allCases

    static var sortSelected: SortType = .date
    static var dateFrom: Date?
    static var dateTo: Date?
    static var soldSelected: SoldType?
    static var supplierSelected: [FilterType]?
    static var environmentSelected: [FilterType]?
    static var graderSelected: [FilterType]?
    static var productTypeSelected: [FilterType]?
    static var processSelected: [FilterType]?
}

enum SortType: String, CaseIterable {
    case date = "Date Graded"
    case price = "Price"
    case total = "Total Grade"
    case product = "Product Type"
    case grader = "Grader"
    case quantity = "Quantity"
}

enum SoldType: String, CaseIterable {
    case any = "Any"
    case sold = "Sold"
    case notSold = "Not Sold"
}

enum FilterTypeAPI: String {
    case productType = "product-type"
    case process = "process"
    case environment = "environment"
    case grader = "user"
    case supplier = "supplier"
}
