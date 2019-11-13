//
//  MyUtils.m
//  Runner
//
//  Created by 大杉网络 on 2019/6/25.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//
#import "MyUtils.h"
#import "UIKit/UIApplication.h"
@implementation MyUtils



// 判断是否有安装某个APP
+(BOOL)checkAPPIsExist:(NSString*)urlScheme{
    NSURL* url;
    if ([urlScheme containsString:@"://"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlScheme]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",urlScheme]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        return YES;
    } else {
        return NO;
    }
}

@end
