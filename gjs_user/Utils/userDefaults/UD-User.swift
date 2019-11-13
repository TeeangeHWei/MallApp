//
//  UserDefaults.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/29.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

extension UserDefaults{
    // token密钥
    static func setAuthoToken(value:String){
        UserDefaults.standard.set(value, forKey: "authoToken")
    }
    
    static func getAuthoToken() -> String{
        return UserDefaults.standard.string(forKey: "authoToken") ?? ""
    }
    
    static func removeAutho(){
        UserDefaults.standard.removeObject(forKey: "authoToken")
    }
    // 系统参数
    static func setSys(value:[String : String]){
        UserDefaults.standard.set(value, forKey: "sysParams")
    }
    
    static func getSys() -> [String : Any]{
        return UserDefaults.standard.dictionary(forKey: "sysParams") ?? ["id":"-1"]
    }
    
    static func removeSys(){
        UserDefaults.standard.removeObject(forKey: "sysParams")
    }
    // 用户信息
    static func setInfo(value:[String : String]){
        UserDefaults.standard.set(value, forKey: "info")
    }
    
    static func getInfo() -> [String : Any]{
        let info = UserDefaults.standard.dictionary(forKey: "info")
        if info == nil {
            return Info().toJSON()!
        }
        return info!
    }
    
    static func removeInfo(){
        UserDefaults.standard.removeObject(forKey: "info")
    }
    // 搜索历史 淘宝
    static func setHistory(value:[String]){
        UserDefaults.standard.set(value, forKey: "history")
    }
    
    static func getHistory() -> [Any]{
        return UserDefaults.standard.array(forKey: "history") ?? ["暂无历史"]
    }
    
    static func removeHistory(){
        UserDefaults.standard.removeObject(forKey: "history")
    }
    // 搜索历史 拼多多
    static func setHistoryPdd(value:[String]){
        UserDefaults.standard.set(value, forKey: "pddhistory")
    }
    
    static func getHistoryPdd() -> [Any]{
        return UserDefaults.standard.array(forKey: "pddhistory") ?? ["暂无历史"]
    }
    
    static func removeHistoryPdd(){
        UserDefaults.standard.removeObject(forKey: "pddhistory")
    }
    // 搜索历史 京东
    static func setHistoryJD(value:[String]){
        UserDefaults.standard.set(value, forKey: "jdhistory")
    }
    
    static func getHistoryJD() -> [Any]{
        return UserDefaults.standard.array(forKey: "jdhistory") ?? ["暂无历史"]
    }
    
    static func removeHistoryJD(){
        UserDefaults.standard.removeObject(forKey: "jdhistory")
    }
    // 是否显示活动
    static func setIsShow(value:Int){
        UserDefaults.standard.set(value, forKey: "isShow")
    }
    
    static func getIsShow() -> Int{
        return UserDefaults.standard.integer(forKey: "isShow")
    }
    
    static func removeIsShow(){
        UserDefaults.standard.removeObject(forKey: "isShow")
    }
}
