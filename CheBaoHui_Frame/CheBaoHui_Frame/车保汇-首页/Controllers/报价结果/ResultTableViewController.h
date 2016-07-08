//
//  ResultTableViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarInfo;

@interface ResultTableViewController : UITableViewController


@property(nonatomic,strong) CarInfo *carInfo;

/**
 *  保价情况
 */
@property(nonatomic,strong) NSArray *arrayInsuranceData;


/**
 *  接收来自投保方案的保价信息
 */
@property(nonatomic,strong) NSDictionary *infoAboutSelectedInsurance;


@end
