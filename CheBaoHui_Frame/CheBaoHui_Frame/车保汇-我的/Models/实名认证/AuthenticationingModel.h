//
//  AuthenticationingModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationingModel : NSObject

/**
 *   名字
 */
@property (nonatomic ,copy) NSString * funcName;


/**
  信息
 */
@property (nonatomic,copy) NSString *detailText;


/**
 *  信息图片
 */
@property (nonatomic , copy ) NSString  * detailImageUrl;


@end
