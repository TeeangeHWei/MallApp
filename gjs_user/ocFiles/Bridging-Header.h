//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef BridgingHeader_h
#define BridgingHeader_h

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "../Frameworks/AlibabaAuthSDK.framework/Headers/ALBBSDK.h"
#import "MyUtils.h"

// 分享模块的oc文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "MJRefresh.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#import <UserNotifications/UserNotifications.h>
#endif

#endif /* BridgingHeader_h */

