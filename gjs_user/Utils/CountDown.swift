//
//  CountDown.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

class CountDown {
    
    static var TIME : Int = 20
    /// 短信验证码倒计时
    ///
    /// - Parameters:
    ///   - btn: 按钮
    ///   - phone: 手机号码
    ///   - verifyCode: 图片验证码
    ///   - verifySign: 图片验证码签名
    ///   - phoneSign: 接收短信验证码参数
    ///   - type: 0:注册 1:其他
    static func countDown(btn:UIButton,phone:String,verify:String,verifySign:String,type:Int,
                          success:@escaping(_ data : String) -> Void){
        //倒计时时间
        let timeout = countDownTime()
        if(timeout == TIME){
            AlamofireUtil.post(url: "/sms/public/sendCode",
            param: [
                "phone":phone,
                "verifyCode":verify,
                "verifySign":verifySign,
                "type":type
            ],
            success: {(res, data) in
                IDToast.id_show(msg: "验证码发送成功", success:.success)
                let time = Int(Date(timeIntervalSinceNow: 0).timeIntervalSinceReferenceDate)
                UserDefaults.standard.set(time, forKey: "countDown")
                countDownSchedule(time:timeout - 1,btn: btn)
                success(res.allHeaderFields[AnyHashable("phonesign")] as! String)
            },
            error: {
            },
            failure: {
            })
        }else{
            success("warning")
            countDownSchedule(time:timeout,btn: btn)
        }
    }
    
    //验证码锁定时间
    static func countDownTime() -> Int{
        //当前时间戳（秒）
        let time = Int(Date(timeIntervalSinceNow: 0).timeIntervalSinceReferenceDate)
        if(UserDefaults.standard.integer(forKey: "countDown") != 0){
            if(time - UserDefaults.standard.integer(forKey: "countDown") < TIME){ //倒计时未完成
                return TIME - (time - UserDefaults.standard.integer(forKey: "countDown"))
            }else{ //倒计时超时
                return TIME
            }
        }else{ //倒计时未设置
            return TIME
        }
    }
    
    //每秒倒计时
    static func countDownSchedule(time:Int = countDownTime(), btn:UIButton){
        var timeout = time
        if(timeout < TIME){
            let queue:DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
            let _timer:DispatchSource = DispatchSource.makeTimerSource(flags: [], queue: queue) as! DispatchSource
            _timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1))
            //每秒执行
            _timer.setEventHandler(handler: { () -> Void in
                if(timeout<=0){ //倒计时结束，关闭
                    _timer.cancel();
                    DispatchQueue.main.sync(execute: { () -> Void in
                        btn.setTitle("获取验证码", for: .normal)
                        btn.isEnabled = true
                    })
                }else{//正在倒计时
                    DispatchQueue.main.sync(execute: { () -> Void in
                        btn.setTitle(String(timeout)+"秒后获取", for: .normal)
                        btn.isEnabled = false
                    })
                    timeout -= 1;
                }
            })
            _timer.resume()
        }
    }
}
