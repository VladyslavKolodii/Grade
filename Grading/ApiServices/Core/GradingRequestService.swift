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
                           fileName: String,
                           callBack: @escaping GradingResponseData)
    func makeRequestDownloadFile(with url: URL,
                                 fileName: String,
                                 callBack: @escaping (_ downloadedFileUrl: URL?) -> ())
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
                           fileName: String,
                           callBack: @escaping GradingResponseData) {
        let method = HTTPMethod(rawValue: withRequestInfo.requestType.rawValue)
        let headers = HTTPHeaders(withRequestInfo.header)
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in withRequestInfo.body {
                if let data = value as? Data {
                    if let mimeType = data.mimeType, self.isDataFileFormatImage(fromData: data) {
                        multipartFormData.append(data, withName: key, fileName: mimeType.replacingOccurrences(of: "/", with: "."), mimeType: mimeType)
                    } else {
                        let fileName = self.getFileName(urlString: fileName )
                        guard let fileExtension = fileName.components(separatedBy: ".").last, self.isFileExtensionSupported(fileExtension: fileExtension) else { return }
                        multipartFormData.append(data, withName: key, fileName: fileName, mimeType: "multipart/form-data")
                    }
                } else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: url, usingThreshold: UInt64.init(),  method: method, headers: headers).responseJSON { response in
            self.responseHandle(response: response, callBack: callBack)
        }
    }
    func makeRequestDownloadFile(with url: URL,
                                 fileName: String,
                                 callBack: @escaping (_ downloadedFileUrl: URL?) -> ()) {
        let destination: DownloadRequest.Destination
        if !fileName.isEmpty {
            destination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(fileName)
                return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        } else {
            destination = DownloadRequest.suggestedDownloadDestination()
        }
        AF.download(
            url,
            to: destination).response(completionHandler: { (result) in
                callBack(result.fileURL)
            })
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
    
    private func getFileName(urlString: String) -> String {
        let strings = urlString.components(separatedBy: "/")
        if let fileName = strings.last {
            return fileName
        }
        return ""
    }
    
    private func isFileExtensionSupported(fileExtension: String) -> Bool {
        let supportedFileExtensions = ["html", "htm", "css", "js", "jpeg", "jpg", "png", "gif", "tiff","tif", "bmp", "avi", "wmv", "mpg", "mov", "swf", "mp4", "mp3", "pdf", "txt", "docx", "xlsx", "pptx", "zip", "csv","doc","xls","ppt","txt","xml","rar","gz","flv","pps","xlr","odt","mkv","tar","log","dat"]
        return supportedFileExtensions.contains(fileExtension.lowercased())
    }
    
}
