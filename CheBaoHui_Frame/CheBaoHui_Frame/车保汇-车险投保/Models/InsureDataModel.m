//
//  InsureDataModel.m
//  Template_Joker
//
//  Created by  李知洋 on 16/2/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InsureDataModel.h"

@implementation InsureDataModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"方法名：%s,行：%d,未识别的key:%@",__func__,__LINE__,key);
}


-(NSString *)description{
    return [NSString stringWithFormat:@"sx_date:%@,cd_date:%@",self.sx_date,self.cd_date];
}

@end
