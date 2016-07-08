//
//  CarInfo.m
//  Template_Joker
//
//  Created by Bella on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CarInfo.h"

@implementation CarInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s 不识别的key:%@",__FUNCTION__,key);
}


-(NSString *)description{
    return [NSString stringWithFormat:@"车主姓名:%@,车牌号:%@,车架号:%@",self.cz_name,self.cph_no,self.cjh_no];
    
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    
    
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
    }
    return self;
}


@end
