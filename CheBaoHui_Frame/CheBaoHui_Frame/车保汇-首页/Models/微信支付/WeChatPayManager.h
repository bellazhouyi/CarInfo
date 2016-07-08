//
//  WeChatPayManager.h
//  Template_Joker
//
//  Created by Bella on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  传递关于支付信息
 *
 *  @param msg <#msg description#>
 */
typedef void(^passMsgAboutPayInfo)(NSString *msg);


/**
 *  微信本地支付
 */
@interface WeChatPayManager : NSObject

//声明
@property(nonatomic,copy) passMsgAboutPayInfo passMsg;



/**
 *  调起支付
 */
-(void)toPayWithprepayid:(NSString *)prepayid nonceStr:(NSString *)nonceStr;



@end
