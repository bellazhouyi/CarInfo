//
//  InsurePayWayUIView.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  支付方式
 */
typedef NS_ENUM(NSInteger, PayWayType) {
    /**
     *  微信支付
     */
    PayWayTypeWeixinChat =1,
    /**
     *  支付宝
     */
    PayWayTypeAlipay,
    
    /**
     *  刷卡
     */
    PayWayTypeShuaKa
    
};

@protocol InsurePayWayUIViewDelegate   <NSObject>

@optional
/**
 *  实现此代理 关闭弹出pop
 */
-(void) insurePayWayCallBackColsePop;

/**
 *实现此代理, 回调 实现调用支付
 *  @param payType 支付方式
 */
-(void)  insurePayWayType:(NSString *)  payType;


@end

/**
 *  支付方式
 */
@interface InsurePayWayUIView : UIView

/**
 *  支付方式
 */
@property (nonatomic , strong) NSString   *payType;

/**
 *  二维码地址
 */
@property (nonatomic ,copy ) NSString * erweimaUrl;


@property(nonatomic , weak) id delegate;


//-(void) initInsurePayWayName:(NSString * ) name orImage:(NSString * ) image;

@end
