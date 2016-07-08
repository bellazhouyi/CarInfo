//
//  PolicyModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  保险单的模型
 
 */
@interface PolicyModel : NSObject

/**
 *   "code":0,
 "msg":null,
 "data"
 */

@property (nonatomic , copy) NSString * code;

@property (nonatomic , copy) NSString * msg;

@property (nonatomic,strong) NSArray * data;

@end
