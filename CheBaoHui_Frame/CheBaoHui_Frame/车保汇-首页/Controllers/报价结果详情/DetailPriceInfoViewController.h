//
//  DetailPriceInfoViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceDetail;




@interface DetailPriceInfoViewController : UIViewController

/**
 *  接收传来的保险公司名称
 */
@property(nonatomic,strong) NSString *companyName;


/**
 *  接收上一个页面传过来的PriceDetail实例
 */
@property(nonatomic,strong) PriceDetail *priceDetail;


/**
 *  总价
 */
@property(nonatomic,assign) CGFloat totalPrice;


@property(nonatomic,strong) CarInfo *carInfo;


/**
 *  图片索引值
 */
@property(nonatomic,assign) NSInteger imageIndex;


/**
 *  保价情况
 */
@property(nonatomic,strong) NSArray *arrayOfInsurance;

@property(nonatomic,strong) NSDictionary *infoAboutSelectedInsurance;


/**
 *  接收 比价后的各个险种的保价金额
 */
@property(nonatomic,strong) NSArray *arrayAboutBasicInsuranceValue;

@property(nonatomic,strong) NSArray *arrayAboutExtraInsuranceValue;

@property(nonatomic,strong) NSArray *arrayAboutNotDutyInsuranceValue;


@end
