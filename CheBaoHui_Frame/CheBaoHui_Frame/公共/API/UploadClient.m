//
//  UploadClicent.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "UploadClient.h"
#import "MJExtension.h"
#import "ResultModel.h"

@interface UploadClient()


@end


@implementation UploadClient


static  UploadClient *  sharedSingleton = nil;

+(UploadClient * ) sharedInstance
{
    if(sharedSingleton==nil){
        sharedSingleton = [[UploadClient alloc] init];
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
    NSLog(@"%@",responseObject);
    
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        if ([@"0" isEqualToString:result.code]) {//成功
            if (successBlock) {
                successBlock(result.msg,result);
            }
        }else{//失败
    
            if (failureBlock) {
                failureBlock(result.msg,Message_Stauts_Failure);
            }
        }
    
    
}

@end
