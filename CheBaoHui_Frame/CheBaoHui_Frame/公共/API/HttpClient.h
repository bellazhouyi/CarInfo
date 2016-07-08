//
//  BaseHttpClient.h
//  CQFishForIOS
//
//  Created by pengshuai on 15/7/20.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "JJHttpClient.h"
@interface HttpClient : JJHttpClient

#pragma mark - 
#pragma mark - override methods

/**
 *  处理请求参数(对参数加密等)
 *
 *  @param Parameters 请求参数
 *
 *  @return 处理后参数
 */
+(NSDictionary*)handleRequestParameters:(NSDictionary*)parameters;

/**
 *  处理请求发送失败
 *
 *  @param error        错误信息
 *  @param failureBlock 请求失败执行的方法
 */
-(void)handleRequestFailure:(NSError *)error failureBlock:(JJResponseDataFailureBlock)failureBlock;

/**
 *  处理请求成功后返回的结果
 *
 *  @param responseObject 请求响应数据
 *  @param successBlock   如果返回的数据正常,执行方法
 *  @param failureBlock   如果返回的数据异常,执行方法
 */
-(void)handleResponseObject:(id)responseObject successBlock:(JJResponseDataSuccessBlock)successBlock failureBlock:(JJResponseDataFailureBlock)failureBlock;

@end






