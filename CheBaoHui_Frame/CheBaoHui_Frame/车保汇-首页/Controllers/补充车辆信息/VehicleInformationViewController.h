//
//  VehicleInformationViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KevinBaseController.h"

@class CarInfo;
@interface VehicleInformationViewController : KevinBaseController

/**
 *  接收来自上一个页面 传过来的车牌号码
 */
@property(nonatomic,strong) NSString *licenseNumber;

/**
 *  存储车架号码
 */
@property(nonatomic,strong) NSString *frameNumber;

/**
 *  车辆信息
 */
@property(nonatomic,strong) CarInfo *carInfo;

@end
