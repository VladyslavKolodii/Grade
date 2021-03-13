import Foundation
import SwiftyJSON

class SupplierService {
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
 
}


