//
//  CarOwnerModel.m
//  Template_Joker
//
//  Created by Bella on 16/2/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CarOwnerModel.h"

@implementation CarOwnerModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未识别的key:%@",key);
}


-(NSString *)description{
    return [NSString stringWithFormat:@"是否显示:%d,姓名:%@,电话:%@,正面照id:%@,反面照id:%@",self.isShowCarOwner,self.name,self.phone,self.frontalViewId,self.negativeViewId];
}

@end
