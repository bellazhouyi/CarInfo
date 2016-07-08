//
//  AliPayManager.h
//  Template_Joker
//
//  Created by Bella on 16/1/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayManager : NSObject

/**
 *  配置请求信息
 *
 *  @param tradeNO            订单号
 *  @param productName        商品标题
 *  @param productDescription 商品描述
 *  @param amount             总金额
 */
-(void)configureInfoWithtradeNO:(NSString *)tradeNO
                    productName:(NSString *)productName
             productDescription:(NSString *)productDescription
                          amount:(CGFloat)amount;

@end
