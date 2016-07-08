//
//  PriceDetail.m
//  Template_Joker
//
//  Created by Bella on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PriceDetail.h"

@implementation PriceDetail


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s  不识别的key:%@",__FUNCTION__,key);
}

-(NSString *)description{
    return [NSString stringWithFormat:@"公司%@,policyId：%@",self.company_name,self.policyId];
}

-(NSString *)company_name{
    return _company_name;
}

@end
