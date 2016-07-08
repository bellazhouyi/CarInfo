//
//  ContactmModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

/**
 *  显示到左侧的内容
 */
@property (copy, nonatomic) NSString * leftLabel;
/**
 *  显示text输入框中的提示
 */
@property (copy , nonatomic ) NSString  * placeholder;

/**
 *  输入内容
 */
@property(copy,nonatomic) NSString * inputText;


@end
