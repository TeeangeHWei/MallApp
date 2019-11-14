//
//  AppDelegate.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/8.
//  Copyright © 2019 大杉网络. All rights reserved.
//

@_exported import UIKit
@_exported import IDealist
@_exported import SnapKit
@_exported import Alamofire
@_exported import SwiftyJSON
@_exported import AlamofireImage
@_exported import yoga
@_exported import YogaKit
@_exported import HandyJSON
@_exported import Kingfisher
@_exported import GTMRefresh
@_exported import AlibcTradeBiz
@_exported import JXSegmentedView
@_exported import FWPopupView
import UserNotifications
@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        UIViewController.initClass()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        getIsShow()
        
        AlibcTradeSDK.sharedInstance()?.setEnv(AlibcEnvironment.release)
        //阿里百川初始化
        AlibcTradeSDK.sharedInstance().asyncInit(success: {
            print("初始化成功")
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
        AlibcTradeSDK.sharedInstance()?.setDebugLogOpen(true)
        
        
        let root = TabBarViewController()
        self.window?.rootViewController = root
        self.window?.backgroundColor = kWhite
        
        /// 取得用户授权 显示通知（上方提示条/声音/badgeNumber）
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert, .carPlay]) { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        NetworkReachabilityManager.init()?.startListening()
        let urlCache = URLCache.init(memoryCapacity: 4*1024*1024, diskCapacity: 20*1024*1024, diskPath: nil)
        URLCache.shared = urlCache
        getSysParams()
        _ = shareConfig()
        return true
    }
    
    // 淘宝授权回调（不写，进入淘宝后无法返回APP）
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (!AlibcTradeSDK .sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)) {
            
        }
        return true;
    }
    // 淘宝授权回调（不写，进入淘宝后无法返回APP）
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var cars = [String: Any?]();
        for item in options{
            let ss = item.key.rawValue as! String
            cars = [ ss : item.value];
        }
        if #available(iOS 9.0, *) {
            AlibcTradeSDK.sharedInstance().application(app, open: url, options: cars)
        } else {
            // Fallback on earlier versions
        };
        return true;
    }
    
    // 识别剪贴板中的内容
    func pasteboard () {
        // 识别剪贴板中的内容
        if let paste = UIPasteboard.general.string {
            if paste == "" {
                return
            }
            searchStr = paste
            shearPlate(str : paste)
            UIPasteboard.general.string = ""
        }
    }
    
    // 剪切板弹窗
    func shearPlate (str : String) {
        let dialog = ShearPlateView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH), copyStr: str)
        self.window?.addSubview(dialog)
    }
    
    // 获取系统参数
    func getSysParams () {
        AlamofireUtil.post(url:"/sys/public/selectSysParams", param: [:],
        success:{(res, data) in
            var sys = [String : String]()
            let sysParamsData = sysParams.deserialize(from: data.description)!
            sys["service"] = sysParamsData.service
            sys["beginDay"] = sysParamsData.beginDay
            sys["endDay"] = sysParamsData.endDay
            sys["directNums"] = sysParamsData.directNums
            sys["indirectNums"] = sysParamsData.indirectNums
            sys["one"] = sysParamsData.one
            sys["two"] = sysParamsData.two
            sys["three"] = sysParamsData.three
            UserDefaults.setSys(value: sys)
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 是否显示活动的参数(用于审核时隐藏部分页面及代码)
    func getIsShow () {
        AlamofireUtil.post(url:"/sys/public/getIsShowContent", param: [:],
        success:{(res, data) in
            UserDefaults.setIsShow(value: data.int!)
        },
        error:{
            
        },
        failure:{
            
        })
    }
    
    // 跳转页面
    func jumpPage () {
        let tab = window!.rootViewController
        let nav = tab!.children[0].children[0].navigationController
        let result = SearchResultController.init()
        result.hidesBottomBarWhenPushed = true
        nav!.pushViewController(result, animated: true)
    }
    
    // 分享注册
    func shareConfig() -> Bool{
        ShareSDK.registerActivePlatforms(
            [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.typeWechat.rawValue,
                SSDKPlatformType.typeQQ.rawValue
            ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "2812491596",
                                                appSecret: "69734b4707784b8d907b4bc8d10b85ea",
                                                redirectUri: "http://www.sharesdk.cn",
                                                authType: SSDKAuthTypeBoth)
                    
//                case SSDKPlatformType.typeWechat:
//                    //设置微信应用信息
//                    appInfo?.ssdkSetupWeChat(byAppId: "wxd25146be82f03e80",
//                                             appSecret: "b557f88008c3903e07afa89e6b56d161")
                    case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wxc95db815c74b1718",
                                             appSecret: "81fab92710e94f5391e8343b396c120f")
                    
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: "1108863659",
                                         appKey: "qDvRCNG5jynH1FPI",
                                         authType: SSDKAuthTypeWeb)
                default:
                    break
                }
        })
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if !isFirst {
            pasteboard()
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
