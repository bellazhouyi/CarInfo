//
//  AddCarSectionModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddCarSectionModel : NSObject

@property (nonatomic , copy) NSString  * sectionHeaderName;/**< 传空表示分组无名称*/

@property (nonatomic ,assign) CGFloat  sectionHeaderHeight; /**<      分组header高度*/

@property (nonatomic , strong) NSArray * itemArray; /**< item模型数组*/

@property (nonatomic ,  strong )  NSMutableArray *data;

@property(nonatomic , strong)  UIColor  *sectionHeaderBgColor; /**< 背景色*/


@end
