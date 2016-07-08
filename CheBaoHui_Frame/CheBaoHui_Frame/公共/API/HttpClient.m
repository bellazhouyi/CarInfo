//
//  BaseHttpClient.m
//  CQFishForIOS
//
//  Created by pengshuai on 15/7/20.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "HttpClient.h"
#import "JJBaseController.h"
@implementation HttpClient

/**
 *  处理请求参数(对参数加密等)
 *
 *  @param Parameters 请求参数
 *
 *  @return 处理后参数
 */
+(NSDictionary*)handleRequestParameters:(NSDictionary*)parameters{
    //TODO:对参数进行处理
    return parameters;
}

/**
 *  处理请求发送失败
 *
 *  @param error        错误信息
 *  @param failureBlock 请求失败执行的方法
 */
-(void)handleRequestFailure:(NSError *)error failureBlock:(JJResponseDataFailureBlock)failureBlock{

    D_NSLog(@"【DEBUG-JJHttpClient-ERROR】:%@",error);
    NSInteger errCode = Message_Stauts_Normal;
    NSString *errInfo = nil;
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        
        errCode = Message_Stauts_No_Network;//无网络
        
    }else if (error.code == -999) {//表示取消请求
    
        errCode = Message_Stauts_Cancel;
        
    }else{//请求出错了,比如操时等
        
        errCode = Message_Stauts_Error;//请求出错
        errInfo = errInfo.debugDescription;
    }
    
    if(failureBlock){
        failureBlock(errInfo,errCode);
    }
    
}

/**
 *  处理请求成功后返回的结果
 *
 *  @param responseObject 请求响应数据
 *  @param successBlock   如果返回的数据正常,执行方法
 *  @param failureBlock   如果返回的数据异常,执行方法
 */
-(void)handleResponseObject:(id)responseObject
               successBlock:(JJResponseDataSuccessBlock)successBlock
               failureBlock:(JJResponseDataFailureBlock)failureBlock{
    
    D_NSLog(@"【responseObject】:%@",responseObject);
    //TODO处理返回的数据
    //...
    
//    NSString *returnCode = responseObject[@"returnCode"];
//    NSString *errorMsg = responseObject[@"errorMsg"];
//    id result = responseObject[@"result"];
//    
//    if ([@"000000" isEqualToString:returnCode]) {//成功
//        
//        NSString *successMsg = responseObject[@"result"][@"succMsg"];
//        
//        if (successBlock) {
//            successBlock(successMsg,result);
//        }
//        
//    }else{//失败
//        
//        if (failureBlock) {
//            failureBlock(errorMsg,Message_Stauts_Failure);
//        }
//    }
}

@end














