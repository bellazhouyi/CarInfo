//
//  ShortNameForCity.m
//  Template_Joker
//
//  Created by Bella on 16/1/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ShortNameForCity.h"

@implementation ShortNameForCity

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"不识别的key:%@",key);
}

-(NSString *)description{
    return [NSString stringWithFormat:@"城市名称:%@",self.AreaName];
}




@end
