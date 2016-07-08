//
//  WeChatPayManager.m
//  Template_Joker
//
//  Created by Bella on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WeChatPayManager.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import <CommonCrypto/CommonDigest.h>

@implementation WeChatPayManager



-(void)toPayWithprepayid:(NSString *)prepayid nonceStr:(NSString *)nonceStr
{
    PayReq *request = [PayReq new];
    
    //商户ID
    request.partnerId = @"1311593501";
    
    //预支付订单号
    request.prepayId = prepayid;
    
    request.package = @"Sign=WXPay";
    
    //第一次的随机字符串
    request.nonceStr = nonceStr;
    
    //当前时间生成时间戳
    NSDate *date = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    UInt32 timeStamp = [time intValue];
    request.timeStamp = timeStamp;
    
    //生成签名
    NSString *stringA = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d",wechat_appid,nonceStr,request.package,request.partnerId,prepayid,(unsigned int)request.timeStamp];
    NSString *key = wechat_key;
    NSString *stringSignTemp = [stringA stringByAppendingString:[NSString stringWithFormat:@"&key=%@",key]];
    
    request.sign = [[self createMD5:stringSignTemp] uppercaseString];
    
    
    [WXApi sendReq:request];
    NSLog(@"结果:>>>>%d",[WXApi sendReq:request]);
}


-(NSString *)createMD5:(NSString *)stringSignTemp {
   
    const char *signStr = [stringSignTemp UTF8String];
    unsigned char result[16];
    CC_MD5(signStr, strlen(signStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
    
}


@end
