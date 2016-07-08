//
//  ResultModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  DataModel,CarInfo;

/**
 *  访问服务端 返回的模型
 */
@interface ResultModel : NSObject

@property (nonatomic , copy) NSString * code;

@property (nonatomic ,  copy) NSString * msg;

@property (nonatomic , strong) DataModel * data;

@property (nonatomic , strong) CarInfo * carData;
 
@property (nonatomic , copy) NSString * strData;



@end
