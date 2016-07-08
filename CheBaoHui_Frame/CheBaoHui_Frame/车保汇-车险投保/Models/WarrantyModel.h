//
//  WarrantyModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarrantyModel : NSObject


typedef NS_ENUM(NSInteger, WarantyType) {
        WarantyTypeStatus = 1,// 状态
    
};




/**
 *  左侧文字
 */
@property (nonatomic , copy) NSString *   leftText;


/**
 *  右侧文字
 */
@property (nonatomic , copy) NSString * rightText;


@property (nonatomic ,  assign)  WarantyType  warantyType;



@end
