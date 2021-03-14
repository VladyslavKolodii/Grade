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
    
    func getInventoryList(callBack: @escaping (_ json: JSON) -> ()){
        let url = RequestInfoFactory.inventoryURL
        let requestInfo = RequestInfo(requestType: .get, header: RequestInfoFactory.defaultHeader())
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
}


