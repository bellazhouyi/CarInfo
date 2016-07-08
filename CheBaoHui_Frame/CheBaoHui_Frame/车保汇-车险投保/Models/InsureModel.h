//
//  InsureDataModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  InsureDataModel;
@interface InsureModel : NSObject

//"code":0,
//"msg":null,
//"data"

@property (nonatomic , copy)  NSString * code;

@property (nonatomic , copy)  NSString * msg;

@property (nonatomic , strong ) InsureDataModel *  data;

@end
