import Alamofire
import SwiftyJSON
import SVProgressHUD
typealias GradingResponseData = (_ response: HTTPURLResponse?, _ responseData: Data?, _ jsonData: JSON) -> ()

protocol GradingHttpServiceable {
    func makeRequest(to url: String,
                     withRequestInfo: RequestInfo,
                     callBack: @escaping GradingResponseData)
    func makeRequestUpload(to url: String,
                           withRequestInfo: RequestInfo,
                           callBack: @escaping GradingResponseData)
    func releaseAllRequests()
}

class GradingRequestService: GradingHttpServiceable {
    func makeRequest(to url: String,
                     withRequestInfo: RequestInfo,
                     callBack: @escaping GradingResponseData) {
        let method = HTTPMethod(rawValue: withRequestInfo.requestType.rawValue)
        let headers = HTTPHeaders(withRequestInfo.header)
        let encoding: ParameterEncoding = withRequestInfo.encoding == .url ? URLEncoding.default : JSONEncoding.default
        AF.request(url,
                   method: method,
                   parameters: withRequestInfo.body,
                   encoding: encoding,
                   headers: headers).responseJSON { response in
                    self.responseHandle(response: response, callBack: callBack)
                   }
    }
    func makeRequestUpload(to url: String,
                           withRequestInfo: RequestInfo,
                           callBack: @escaping GradingResponseData) {
        let method = HTTPMethod(rawValue: withRequestInfo.requestType.rawValue)
        let headers = HTTPHeaders(withRequestInfo.header)
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in withRequestInfo.body {
                if let data = value as? Data {
                    if let mimeType = data.mimeType, self.isDataFileFormatImage(fromData: data) {
                        multipartFormData.append(data, withName: key, fileName: mimeType.replacingOccurrences(of: "/", with: "."), mimeType: mimeType)
                    }
                } else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: url, usingThreshold: UInt64.init(),  method: method, headers: headers).responseJSON { response in
            self.responseHandle(response: response, callBack: callBack)
        }
    }
    func releaseAllRequests() {
        AF.session.getAllTasks { (tasks) in
            tasks.forEach{$0.cancel()}
        }
    }
}

// MARK: Logic Function Helper
extension GradingRequestService  {
    private func responseHandle(response: AFDataResponse<Any>, callBack: @escaping GradingResponseData){
        if let data = response.value {
            let json = JSON(data)
            self.showRequestLog(with: json, request: response.request)
            callBack(response.response, response.data,json)
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    private func showRequestLog(with json: JSON, request:URLRequest?) {
        print("\nRequest URL :", request?.url?.absoluteString ?? "")
        print("Request Header :", request?.allHTTPHeaderFields ?? "")
        print("Request Body :", String(decoding: request?.httpBody ?? Data(), as: UTF8.self))
        print("Response Body: ", json)
    }
    
    private func isDataFileFormatImage(fromData data: Data) -> Bool {
        return UIImage(data: data) != nil
    }
    
}
