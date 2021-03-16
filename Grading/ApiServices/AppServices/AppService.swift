import Foundation
import SwiftyJSON

class AppService {
    private var requestService: GradingHttpServiceable? {
        return GradingRequestService()
    }
    
    func saveUserInfo(userName: String, userEmail: String, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.saveUser
        let param: [String: String] = [
            "fullName": userName,
            "email": userEmail
        ]
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo){(reponse, serverData, json) in
            callBack(json)
        }
    }
    
    func getAppointmentList(date: String, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.appointmentURL
        let param: [String: String] = [
            "date": date
        ]
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo, callBack: { (responese, serverData, json) in
            callBack(json)
        })
    }
    
    func getAppointmentDetail(selectedID: Int, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.appointmentURL + "\(selectedID)"
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo, callBack: { (response, serverData, json) in
            callBack(json)
        })
    }
    
    func getAppointmentLocationDetail(selectedID: Int, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.appointmentURL + "location/\(selectedID)"
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo, callBack: { (response, serverData, json) in
            callBack(json)
        })
    }
    
    func addAppointmentLocationImage(selectedID: Int, image: UIImage, callBack: @escaping (_ json: JSON) -> ()) {
        let url = RequestInfoFactory.appointmentURL + "add-location-image/\(selectedID)"
        var parameters: [String:Any] = [String:Any]()
        do {
            let imageData = try image.resizeImage()?.rotated(by: CGFloat.zero)?.compressToDataSize()
            parameters["img[]"] = imageData
        } catch {
            print(error.localizedDescription)
        }
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(),body: parameters)
        requestService?.makeRequestUpload(to: url, withRequestInfo: requestInfo) { (response,serverData,json) in
            callBack(json)
        }
    }
    
    func addAppointment(param: [String: String], callBack: @escaping(_ json: JSON) -> ()) {
        let url = RequestInfoFactory.appointmentURL
        let requestInfo = RequestInfo(requestType: .post, header: RequestInfoFactory.defaultHeader(), body: param)
        requestService?.makeRequest(to: url, withRequestInfo: requestInfo, callBack: { (response, serverData, json) in
            callBack(json)
        })
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


