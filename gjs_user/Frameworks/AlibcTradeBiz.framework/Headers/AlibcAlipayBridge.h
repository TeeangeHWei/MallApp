/*
 * AlibcAlipayBridge.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeBiz 
 * 版本号：4.0.0.0
 * 发布时间：2019-08-30
 * 开发团队：阿里巴巴商家服务引擎团队
 * 阿里巴巴电商SDK答疑群号：1488705339  2071154343(阿里旺旺)
 * Copyright (c) 2016-2020 阿里巴巴-淘宝-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

#ifndef AlibcAlipayBridge_h
#define AlibcAlipayBridge_h


/** 支付结果 */
@interface AlibcTradePayResult : NSObject
/** 支付成功订单 */
@property(nonatomic, copy, nullable, readonly) NSArray *paySuccessOrders;
/** 支付失败订单 */
@property(nonatomic, copy, nullable, readonly) NSArray *payFailedOrders;

@end

@interface AlibcAlipayBridge : NSObject

@property(nonatomic, copy, nullable) NSArray<NSString *> *orderIds;


+ (nonnull instancetype)sharedInstance;

+ (BOOL)isAlipayAvaleable;

+ (BOOL)isPaymentSuccess:(nullable NSDictionary *)payment;


/** 支付订单 */
- (void)payOrder:(nonnull NSString *)order scheme:(nonnull NSString *)scheme callback:(nullable void (^)(NSDictionary *__nullable result))callback;

/** 支付结果 */
- (void)receiptURL:(nullable NSURL *)url callback:(nullable void (^)(NSDictionary *__nullable result))callback;

/** 解析支付结果 */
- (void)processPayment:(NSDictionary *__nullable)payment callback:(nullable void (^)(AlibcTradePayResult *__nullable result, NSError *__nullable error))callback;


@end

#endif //AlibcAlipayBridge_h
