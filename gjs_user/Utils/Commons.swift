//
//  utils.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

class Commons {
    // 设置闪屏页
    class func showSplashView(duration: Int = 6,
      defaultImage: UIImage?,
      tapSplashImageBlock: ((_ actionUrl: String?) -> Void)?,
      splashViewDismissBlock: ((_ initiativeDismiss: Bool) -> Void)?){}
    
    //判断手机号码格式
    static func isPhone(phone:String) -> Bool{
        if(phone.count != 11){
            return false
        }
        let pattern = "^1[2|3|4|5|6|7|8|9]\\d{9}$"
        let isPhone = NSPredicate(format: "SELF MATCHES %@",pattern)
        return isPhone.evaluate(with: phone)
    }
    
    //判断是否为金额
    static func isMoney(money:String) -> Bool{
        if(money.count < 1){
            return false
        }
        let pattern = "(^[1-9](\\d+)?(\\.\\d{1,2})?$)|(^(0){1}$)|(^\\d\\.\\d{1,2}?$)"
        let isMoney = NSPredicate(format: "SELF MATCHES %@",pattern)
        return isMoney.evaluate(with: money)
    }
    
    // 将String转成Double
    static func strToDou(_ str: String) -> Double {
        let dbVal = ( str as NSString ).doubleValue
        return dbVal
    }
    
    //将String转保留两位小数的字符串
    static func strToDoubleStr(str:String) -> String{
        let value:Double = (str as NSString).doubleValue
        return String(format:"%.2f",value)
    }
    
    //数组转json
    static func getJSONStringFromArray(array:NSArray) -> String {
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    // JSONString转换为字典
    static func getDictionaryFromJSONString(_ jsonString:String) -> NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    // 根据会员等级计算佣金比例
    static func getScale () -> Double {
        let sysParameter = UserDefaults.getSys()
        let service = 1.00 - strToDou(sysParameter["service"] as! String) / 100.00
        let one = strToDou(sysParameter["one"] as! String) / 100.00
        let two = strToDou(sysParameter["two"] as! String) / 100.00
        let three = strToDou(sysParameter["three"] as! String) / 100.00
        var memberStatus = 1
        let info = UserDefaults.getInfo()
        if info["id"] as! String != "" {
            memberStatus = Int(UserDefaults.getInfo()["memberStatus"] as! String)!
        }
        var scale : Double = 0.00
        if memberStatus == 1 {
            scale = service * one
        } else if memberStatus == 2 {
            scale = service * two
        } else {
            scale = service * three
        }
        
        let scaleStr = String(format:"%.2f",scale)
        scale = strToDou(scaleStr)
        
        return scale
    }
    
    // 超级会员佣金比例
    static func vip1Scale () -> Double {
        let sysParameter = UserDefaults.getSys()
        let service = 1.00 - strToDou(sysParameter["service"] as! String) / 100.00
        let one = strToDou(sysParameter["one"] as! String) / 100.00
        var scale : Double = 0.00
        scale = service * one
        
        let scaleStr = String(format:"%.2f",scale)
        scale = strToDou(scaleStr)
        
        return scale
    }
    
    // 团长佣金比例
    static func vip2Scale () -> Double {
        let sysParameter = UserDefaults.getSys()
        let service = 1.00 - strToDou(sysParameter["service"] as! String) / 100.00
        let two = strToDou(sysParameter["two"] as! String) / 100.00
        var scale : Double = 0.00
        scale = service * two
        
        let scaleStr = String(format:"%.2f",scale)
        scale = strToDou(scaleStr)
        
        return scale
    }
    
    // 合作伙伴佣金比例
    static func vip3Scale () -> Double {
        let sysParameter = UserDefaults.getSys()
        let service = 1.00 - strToDou(sysParameter["service"] as! String) / 100.00
        let three = strToDou(sysParameter["three"] as! String) / 100.00
        var scale : Double = 0.00
        scale = service * three
        
        let scaleStr = String(format:"%.2f",scale)
        scale = strToDou(scaleStr)
        
        return scale
    }
    
    // 截取字符串中的数字
    static func stringToNum (Str : String) -> [Int] {
        let numbers = Str.characters
            .split(omittingEmptySubsequences: true) { !"0123456789".contains(String($0))}
            .map {Int(String($0))!}
            .filter {$0 != nil}
            .sorted {$0 > $1}
        return numbers
    }
}
