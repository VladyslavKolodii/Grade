import Foundation
import SwiftyJSON

class AppService {
    private var requestService: GradingHttpServiceable? {
        return GradingRequestService()
    }
    
    func getSupplierList(callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.supplierURL
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func getSupplierDetail(id:Int, callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.supplierURL + "/\(id)"
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func getFaqList(page:Int,callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.faqURL
        let parameters: [String:Any] = [
            "page": page
        ]
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader(),body: parameters)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func getInfoUser(userId:Int,callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.userURL + "/\(userId)"
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func getInventoryList(dateFrom: Date? = FilterTypeData.dateFrom,
                          dateTo: Date? = FilterTypeData.dateTo,
                          sort: SortType? = FilterTypeData.sortSelected,
                          sold: SoldType? = FilterTypeData.soldSelected,
                          supplier: [FilterType]? = FilterTypeData.supplierSelected,
                          grader: [FilterType]? = FilterTypeData.graderSelected,
                          environment: [FilterType]? = FilterTypeData.environmentSelected,
                          productType: [FilterType]? = FilterTypeData.productTypeSelected,
                          process: [FilterType]? = FilterTypeData.processSelected,
                          callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.inventoryURL
        var parameters: [String:Any] = [String:Any]()
        if let dateFrom = dateFrom {
            parameters["dateFrom"] = dateFrom.string(withFormat: "yyyy-MM-dd")
        }
        if let dateTo = dateTo {
            parameters["dateTo"] = dateTo.string(withFormat: "yyyy-MM-dd")
        }
        if let sort = sort {
            parameters["sort"] = FilterTypeData.listSorts.firstIndex(where: {$0.rawValue == sort.rawValue})
        }
        if let sold = sold, sold != .any {
            parameters["sold"] = sold == .sold ? 1 : 0
        }
        if let supplier = supplier {
            parameters["supplier"] = "[\(supplier.map({String($0.id)}).joined(separator: ","))]"
        }
        if let grader = grader {
            parameters["grader"] = "[\(grader.map({String($0.id)}).joined(separator: ","))]"
        }
        if let environment = environment {
            parameters["environment"] = environment.first?.id
        }
        if let productType = productType {
            parameters["productType"] = "[\(productType.map({String($0.id)}).joined(separator: ","))]"
        }
        if let process = process {
            parameters["process"] = "[\(process.map({String($0.id)}).joined(separator: ","))]"
        }
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader(),body: parameters)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func getInventoryDetail(id:Int, callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.inventoryURL + "/\(id)"
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func getFilterList(with type: String,
                       callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.mainURL + type
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func addInventoryPhoto(id: Int,
                           image: UIImage,
                           callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.addImageURL + "/\(id)"
        var parameters: [String:Any] = [String:Any]()
        do {
            let imageData = try image.resizeImage()?.rotated(by: CGFloat.zero)?.compressToDataSize()
            parameters["images[]"] = imageData
        } catch {
            print(error.localizedDescription)
        }
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(),body: parameters)
        requestService?.makeRequestUpload(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func deleteInventory(id:Int, callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.inventoryURL + "/\(id)"
        let requestInfo = RequestInfo(requestType: .delete, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
}


