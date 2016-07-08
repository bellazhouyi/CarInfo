//
//  Insurance.h
//  Template_Joker
//
//  Created by Bella on 16/2/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Insurance : NSObject

/**
 *  是否选择该险种 标志位
 */
@property(nonatomic,assign) BOOL isSelectedInsuranceFlag;


/**
 *  险种名称
 */
@property(nonatomic,strong) NSString *insuranceName;


/**
 *  险种的报价金额
 */
@property(nonatomic,strong) NSString *InsurancePrice;


/**
 *  不计免赔 是否选中的标志
 */
@property(nonatomic,assign) BOOL notDutyFlag;


/**
 *  车子产地
 */
@property(nonatomic,strong) NSString *state;


/**
 *  投保回来的险种金额
 */
@property(nonatomic,strong) NSString *insuranceValue;


/**
 *  投保回来的不计免赔的金额
 */
@property(nonatomic,strong) NSString *insuranceNotDutyValue;


@end
