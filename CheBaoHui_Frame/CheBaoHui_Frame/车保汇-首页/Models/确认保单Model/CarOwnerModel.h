//
//  CarOwnerModel.h
//  Template_Joker
//
//  Created by Bella on 16/2/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarOwnerModel : NSObject


/**
 *  是否显示车主或投诉人详情框
 */
@property(nonatomic,assign) BOOL isShowCarOwner;

@property(nonatomic,assign) BOOL isShowComplainant;

/**
 *  车主姓名
 */
@property(nonatomic,strong) NSString *name;


/**
 *  车主联系电话
 */
@property(nonatomic,strong) NSString *phone;

/**
 *  正面照id
 */
@property(nonatomic,strong) NSString *frontalViewId;

/**
 *  反面照id
 */
@property(nonatomic,strong) NSString *negativeViewId;






@end
