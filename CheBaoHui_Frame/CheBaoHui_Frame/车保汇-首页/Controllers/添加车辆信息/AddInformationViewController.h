//
//  AddInformationViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KevinBaseController.h"


@interface AddInformationViewController : KevinBaseController

/**
 *  存储车架号码
 */
@property(nonatomic,strong) NSString *frameNumber;

/**
 *  存储车牌号码
 */
@property(nonatomic,strong) NSString *licenseNumber;

/**
 *  车辆信息
 */
@property(nonatomic,strong) CarInfo *carInfo;

@end
