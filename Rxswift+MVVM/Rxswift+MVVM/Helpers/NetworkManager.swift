//
//  NetworkManager.swift
//  Rxswift+MVVM
//
//  Created by xuanze on 2020/1/17.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class NetworkManager: NSObject {
    static let shareInstance = NetworkManager()
        var sessionManager:SessionManager!
        
        private override init() {
            super.init()
            
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                UrlHostType.Base.rawValue: .pinCertificates(
                    certificates: ServerTrustPolicy.certificates(in: Bundle.main),
                    validateCertificateChain: true,
                    validateHost: true
                ),
    //            UrlHostType.UClass.rawValue: .pinCertificates(
    //                certificates: ServerTrustPolicy.certificates(in: Bundle.main),
    //                validateCertificateChain: true,
    //                validateHost: true
    //            ),
    //            UrlHostType.SmallU.rawValue: .pinCertificates(
    //                certificates: ServerTrustPolicy.certificates(in: Bundle.main),
    //                validateCertificateChain: true,
    //                validateHost: true
    //            ),
                "insecure.expired-apis.com": .disableEvaluation
            ]
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 20//请求超时时间
            config.httpCookieAcceptPolicy = .always
            self.sessionManager = SessionManager.init(configuration: config, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        }
        
    open func requestNetworkData(_ method: HTTPMethod, hostType:UrlHostType, urlString:RequestUrlType,_ parameters:Parameters? = nil, _ body:String? = nil, successHandler: @escaping (_ code:Int, _ datas:JSON, _ desc:String) -> Swift.Void, falseHandler:  @escaping (_ error: Error?) -> Swift.Void) {
            
            let url = "\(hostType.rawValue)\(urlString.rawValue)"
            var printUrl = ""
            printUrl += url
            printUrl += "?"
            if parameters != nil {
                for key in parameters!.keys {
                    printUrl += key
                    printUrl += "="
                    let value = parameters![key]
                    printUrl += "\(value!)"
                    printUrl += "&"
                }
                printUrl = printUrl.subString(to: printUrl.count - 1)
            }
            
            CustomLog.e(printUrl)
            printUrl = printUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            var originalRequest: URLRequest?
            if let url = URL(string: printUrl) {
                originalRequest = URLRequest(url: url)
            } else {
                falseHandler(nil)
                return
            }
            originalRequest?.httpMethod = method.rawValue
            if let bodyStr = body {
                CustomLog.e("requstBody: \(bodyStr)")
                originalRequest?.httpBody = bodyStr.data(using: .utf8, allowLossyConversion: false)
                originalRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                originalRequest?.setValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            
            //公共参数
            
            //设置请求头
//            originalRequest?.setValue(token, forHTTPHeaderField: "token")

            self.sessionManager.request(originalRequest!).responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        debugPrint(response.result)
                        let json = JSON(value)
//                        var code = 0
//                        var msg = ""
//                        var datas:JSON?
//
//                        let result = json["result"]
//                        datas = json["datas"]
//                        if datas?.type != .dictionary {
//                            datas = json
//                        }
//                        if result.type == .dictionary {
//                            msg = result["msg"].stringValue
//                            code = result["code"].intValue
//                        }
                        
                        
                        //处理特殊错误码
                        
                        successHandler(OK_CODE,json,"")
                    }
                } else {
                    debugPrint(response.result)
                    ProgressHUD.showTextPrompt("网络异常")
                    falseHandler(response.error ?? nil)
                }
            }
        }
        
        open func requestCommon(_ method: HTTPMethod, hostType:UrlHostType, urlString:RequestUrlType?, _ parameters:Parameters? = nil, successHandler: @escaping (_ datas:JSON) -> Swift.Void, falseHandler:  @escaping () -> Swift.Void) {
            
            var urlString = "\(hostType.rawValue)\(urlString?.rawValue ?? "")"
            urlString += "?"
            
            if parameters != nil {
                for key in (parameters?.keys)! {
                    if let value = parameters?[key] {
                       urlString += "\(key)=\(value)&"
                    }
                }
                urlString = urlString.subString(to: urlString.count - 1)
            }
            
            
            let url = URL.init(string: urlString)
            if url == nil {
                falseHandler()
            }
            
            
            var originalRequest: URLRequest?
            if let url = URL(string: urlString) {
                originalRequest = URLRequest(url: url)
            } else {
                falseHandler()
                return
            }
            originalRequest?.httpMethod = HTTPMethod.get.rawValue
            originalRequest?.setValue( "x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.sessionManager.request(originalRequest!).responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        debugPrint(response.result)
                        let json = JSON(value)
                        successHandler(json)
                    }
                } else {
                    debugPrint(response.result)
                    ProgressHUD.showTextPrompt("网络异常")
                    falseHandler()
                }
            }
        }
        
        func upLoadImageRequest(hostType:UrlHostType, urlString:RequestUrlType, params:[String:String], data: [Data], name: [String],success: @escaping (_ code:Int, _ datas:JSON)->(), failture: @escaping (_ error : Error)->()){
            
            let urlString = "\(hostType.rawValue)\(urlString.rawValue)"
            
            let window = UIApplication.shared.keyWindow
            ProgressHUD.showLoadingAnimationAtView(window!, animated: true)
            
            let headers = ["content-type":"multipart/form-data"]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    //多张图片上传
                    let flag = params["fileType"]
                    
                    multipartFormData.append(flag!.data(using: String.Encoding.utf8)!, withName: "fileType")
                    
                    for i in 0..<data.count {
                        multipartFormData.append(data[i], withName: "file", fileName: name[i], mimeType: "image/jpg")
                    }
            },
                to: urlString,
                headers: headers,
                encodingCompletion: { encodingResult in
                    ProgressHUD.hideLoadingAnimationAtView(window!, animated: true)
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            if let value = response.result.value{
                                debugPrint("上传成功")
                                debugPrint(response.result)
                                
                                let json = JSON(value)
                                var code = 0
                                var datas:JSON?
                                
                                let result = json["result"]
                                datas = json["datas"]
                                if result.type == .dictionary {
                                    code = result["code"].intValue
                                }
                                
                                success(code,datas!)
                            } else {
                                if let error = response.result.error {
                                    failture(error)
                                }
                            }
                        }
                    case .failure(let encodingError):
                        ProgressHUD.hideLoadingAnimationAtView(window!, animated: true)
                        CustomLog.e(encodingError)
                        failture(encodingError)
                    }
            }
                
            )
        }
}
