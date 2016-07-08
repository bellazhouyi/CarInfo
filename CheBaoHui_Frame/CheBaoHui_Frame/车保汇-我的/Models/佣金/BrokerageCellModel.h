//
//  BrokerageCellModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerageCellModel : NSObject


/**
 *  周
 */
@property (copy, nonatomic)  NSString *week;

/**
 *  佣金
 */
@property (copy, nonatomic)  NSString *commission;
/**
 *  日期
 */
@property (copy, nonatomic)  NSString *date;


@end
