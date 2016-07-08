//
//  DownImageClient.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DownImageClient.h"

@implementation DownImageClient


static  DownImageClient *  sharedSingleton = nil;

+(DownImageClient * ) sharedInstance
{
    if(sharedSingleton==nil){
        sharedSingleton = [[DownImageClient alloc] init];
    }
    return sharedSingleton;
}


/**
 *  处理请求成功后返回的结果
 *
 *  @param responseObject 请求响应数据
 *  @param successBlock   如果返回的数据正常,执行方法
 *  @param failureBlock   如果返回的数据异常,执行方法
 */
-(void)handleResponseObject:(id)responseObject successBlock:(JJResponseDataSuccessBlock)successBlock failureBlock:(JJResponseDataFailureBlock)failureBlock
{

}

@end
