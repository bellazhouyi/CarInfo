//
//  AppDelegate+Configuration.h
//  Template_Joker
//
//  Created by Dev2015 on 16/1/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Configuration)

/**
 *  打印错误日志
 *
 *  @param exception <#exception description#>
 */
void uncaughtExceptionHandler(NSException *exception);

/**
 *  监听网络状态
 */
- (void)startNetworkMonitoring;

/**
 *  处理icon消息数量
 */
-(void)updateApplicationIconBadgeNumber;

/**
 *  收到APNS消息
 *
 *  @param userInfo    <#userInfo description#>
 *  @param application <#application description#>
 */
-(void)handleAPNSMessage:(NSDictionary*)userInfo application:(UIApplication*)application;
@end
