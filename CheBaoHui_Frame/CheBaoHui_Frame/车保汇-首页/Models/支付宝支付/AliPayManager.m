//
//  AliPayManager.m
//  Template_Joker
//
//  Created by Bella on 16/1/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AliPayManager.h"

#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"
#import "DataSigner.h"


@implementation AliPayManager



-(void)configureInfoWithtradeNO:(NSString *)tradeNO
                    productName:(NSString *)productName
             productDescription:(NSString *)productDescription
                         amount:(CGFloat)amount{
    
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121458158764";
    NSString *seller = @"jiangxiaoyan@hrnpfs.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMFAyJ/KdSCXFasGWlvod3eZBPLXlTFQ96C38jw/6ADpBfTsWBSWcv2nF+eYfEyrZ0IZ0C4Rog3Y2NumxgcTn2j58+fqKU1CoswO6UV9giqhKUFySqXl1kTvW+mnKw1slv6xPxmZdU1tv2A9LvCC2MODYRKR2FK8bTIYrfUcGmJ3AgMBAAECgYEAhFcpDMRIkZjlbclb97Sqm2xexy57LNqVuao+aKQa7QSm36M6bl7ZQHs9E4yJErgObmXe+q14nKLzXvhGhHIbp0daw8tGrVhcD0FJMurVZ96jlDXBSN8RV0UsFrHK/NfSwS9Sur3coFwycORK/Y6OPVaQr9HiLP51Da3Cvo4GvYECQQDhOfwaOCsZDwP+Fd5dSPZOqKaDjfrSURMHUm4Uv4hsMiMT2DfDwLVDZrRWVKEOpUQ8oLqNeW8NHQhl/BOBJeQ9AkEA26htAojb5LWY/OG1IoyDs0UVcvMSBZb0oUl7xD3NogcTo9wCgSbHHesT/1XfmV7HzhwHgZNfnrDtLEIaGCQowwJBAMaiRAO/u8rK4mOJV+Z/vbLbrJdjdW1dUWHowesMjL2XbjZHP88luvdpsexdkPmAqfCqdDzndxhinZCMQ4toJqUCQDIYDRRA5fUYvRUe3FJOvVJK9QNMD9YagRuvSHyOo7DJ8F60NBYEI/Dcxai7iszNYr/MgKG6XFoye0RWpuDOjkUCQQCYwVqZ8Eg/t3HzfIT1dFLrZM9FLUf65tGjPRybH8zvzX9vyWKXNZ47Wiy+GUG7+YzhXr4v2MG63Ea/vkRbM6M8";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    order.notifyURL =  @"http://www.hrnpfs.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"chebaohuiAliPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
    
}



@end
