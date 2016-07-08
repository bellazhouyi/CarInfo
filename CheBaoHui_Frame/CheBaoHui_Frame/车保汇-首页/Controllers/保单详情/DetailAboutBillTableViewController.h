//
//  DetailAboutBillTableViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailAboutBillTableViewController : UITableViewController


/**
 *  关于投保方案情况的数组
 */
@property(nonatomic,strong) NSArray *arrayAboutInsuranceInfo;


/**
 *  保单号
 */
@property(nonatomic,strong) NSString *cntr_id;

/**
 *  保险公司名称
 */
@property(nonatomic,strong) NSString *companyName;

/**
 *  总保价
 */
@property(nonatomic,assign) CGFloat totalPrice;

/**
 *  投保人
 */
@property(nonatomic,strong) NSString *policyHolder;

/**
 *  被保人
 */
@property(nonatomic,strong) NSString *insuredPerson;

@end
