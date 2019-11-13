//
//  NetworkTool.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/16.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkToolProtocol {
    // MARK: - ---------------- 首页 --------------------
    // MARK: 首页顶部标题数据
    static func loadHomeClassfiyTitle(completionHandler: @escaping (_ classfiyTitle: [HWGeneralModel]) -> ())
    
}

extension NetworkToolProtocol{
    // MARK: - ---------------- 首页 --------------------
    // MARK: 首页顶部标题数据
    static func loadHomeClassfiyTitle(completionHandler: @escaping (_ classfiyTitle: [HWGeneralModel]) -> ()){
        let url = BASE_URL + "/gjz_service/product/public/classify"
        let params = ["":""]
        Alamofire.request(url,method: .post, parameters: params).responseJSON{ (response) in
            print(response)
            //网络错误提示
            if let Error = response.result.error{
                print(Error)
            }
            
            else if let jsonResult = response.result.value{
                let jsondic = JSON(jsonResult)
            if let dict = jsondic.dictionaryObject {
                if let resultDict = dict["result"] as? NSDictionary {
                     if let genArr = resultDict["general_classify"] as? Array<NSDictionary> {
                        for genDict in genArr{
                            var genModel = HWGeneralModel.init()
                            genModel.main_name = genDict["main_name"] as? String
                            }
                        
                        }
                    }
                }
            }
        }
    }
    
    
}
