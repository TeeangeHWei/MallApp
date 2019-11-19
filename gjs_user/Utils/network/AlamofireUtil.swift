//
//  AlamofireUtil.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

class AlamofireUtil {

    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    
    // 是否是取消请求
    static var isCancel = false
    
//    static var BASE_IMG_URL = "http://192.168.0.11:8082"
//    static var BASE_URL = "http://192.168.0.11:8082/gjz_service"
    static var BASE_URL = "https://www.ganjinsheng.com/api/"
    static var BASE_IMG_URL = "https://www.ganjinsheng.com"
    
    //post 请求
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - param: 参数
    ///   - success: 成功回调 返回JSON对象
    ///   - error: 错误回调
    ///   - failure: 失败回调
    static func post(url:String,param: [String:Any],
                     closeError : Bool = false,
                     success:@escaping(_ res : HTTPURLResponse, _ data : JSON) -> Void,
                     error: @escaping () -> Void,
                     failure: @escaping () -> Void){
        let header = [
            "Authorization": UserDefaults.getAuthoToken(),
            "Content-type": "application/x-www-form-urlencoded"
        ]
        let oneRequest = Alamofire.request(BASE_URL+url, method: .post, parameters: param, encoding: URLEncoding.queryString, headers: header)
            .response{ data in
                switch data.response?.statusCode{
                case 200 :
                    if let temp = data.data{
                        let obj = JSON(temp)
                        switch obj["message"].description{
                        case "succ" :
                            success(data.response!,JSON(obj["result"]))
                        case "error" :
                            if !closeError {
                                IDToast.id_show(msg: obj["result"].description, success: .fail)
                            }
                            error()
                        default :
                            break
                        }
                    }
                    break
                case 401 :
                    // 密钥过期，清除本地密钥
//                    IDToast.id_show(msg: "您的登录过期了")
                    UserDefaults.removeAutho()
                    break
                case 403 :
                    IDToast.id_show(msg: "您无权进行该操作", success: .fail)
                    error()
                    break
                case 404 :
                    IDToast.id_show(msg: "请求出错了", success: .fail)
                    break
                case nil :
                    print("===========网络请求失败信息===========")
                    print(data)
                    IDToast.id_show(msg: "请联网后使用APP", success: .fail)
                    failure()
                default :
                    break;
                }
        }
        requestCacheArr.append(oneRequest)
    }
    
    //get方法
    static func get(url:String,
                    success:@escaping(_ res:HTTPURLResponse, _ data:Data)->(),
                    failure: @escaping () -> ()) {
        Alamofire.request(BASE_URL+url,method: .get).response{ data in
            switch data.response?.statusCode{
            case 200 :
                success(data.response!,data.data!)
                break
            case 401 :
                // 密钥过期，清除本地密钥
//                IDToast.id_show(msg: "您的登录过期了")
                UserDefaults.removeAutho()
                break
            case 403 :
                IDToast.id_show(msg: "您无权进行该操作", success: .fail)
                break
            case nil :
                print("=======请求失败信息=======")
                print(data)
                IDToast.id_show(msg: "请联网后使用APP", success: .fail)
                failure()
            default :
                break;
            }
        }
    }
    
    // upload方法
    static func upload(url:String, param: [String:Any],
                       success:@escaping(_ data : JSON) -> Void,
                       error: @escaping () -> Void,
                       failure: @escaping () -> Void){
        let header = [
            "Authorization": UserDefaults.getAuthoToken(),
            "Content-type": "application/x-www-form-urlencoded"
        ]
        Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in param {
                    multipartFormData.append(Data((value as! String).utf8), withName: key)
                }
            },
            to: BASE_URL+url,
            headers: header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            let json = JSON(value)
                            if(json["message"].description == "succ"){
                                success(JSON(json["result"]))
                            }else if(json["message"].description == "error"){
                                IDToast.id_show(msg: json["result"].description,success:.success)
                                error()
                            }
                        }
                    }
                    break
                case .failure(let encodingError):
                    print(encodingError)
                    failure()
                    break
                }
        })
        
    }
    
    // 取消所有请求
    static func cancelAll () {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
            (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach {
                print("被取消的请求:::::::::::::::::",$0)
                $0.cancel()
            }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
//        isCancel = true
//        let taskList = requestCacheArr.filter{$0 != nil}
//        let count = taskList.count
//        for task in requestCacheArr {
//            print("被取消的请求:::::::::::::::::",task)
//            task.cancel()
//        }
////        requestCacheArr.removeAll()
//        for _ in taskList {
//            requestCacheArr.remove(at: 0)
//        }
//        isCancel = false
    }
}
