//
//  Insurance.m
//  Template_Joker
//
//  Created by Bella on 16/2/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "Insurance.h"

@implementation Insurance

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"不识别的key:%@",key);
}


-(NSString *)description{
    return [NSString stringWithFormat:@"险种名称:%@,  是否显示:%d,  险种金额:%@,  不计免赔:%d ,产地:%@,投保价:%@",_insuranceName,_isSelectedInsuranceFlag,_InsurancePrice,_notDutyFlag,_state,_insuranceValue];
}


@end
