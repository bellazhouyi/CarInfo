//
//  AppDelegate+Configuration.m
//  Template_Joker
//
//  Created by Dev2015 on 16/1/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AppDelegate+Configuration.h"

@implementation AppDelegate (Configuration)

void uncaughtExceptionHandler(NSException *exception) {
    D_NSLog(@"CRASH: %@", exception);
    D_NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

#pragma mark -
#pragma mark - 网络监听
/*!
 * 监听网络状态
 */
- (void)startNetworkMonitoring{
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];//开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                D_NSLog(@"当前网络:无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                D_NSLog(@"当前网络:WIFI");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                D_NSLog(@"当前网络:WWAN");
                break;
            }
            default:
                break;
        }
        
    }];
}


//处理icon消息数量
-(void)updateApplicationIconBadgeNumber{
    
    //D_NSLog(@"更新图标消息数量");
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}
//处理收到APNS消息
-(void)handleAPNSMessage:(NSDictionary*)userInfo application:(UIApplication*)application{
    
    //D_NSLog(@"APNS收到推送消息:%@",userInfo);
    
}

@end
