//
//  CarList.m
//  Template_Joker
//
//  Created by Bella on 16/2/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CarList.h"

@implementation CarList


static  CarList *  sharedSingleton = nil;


+(CarList *)sharedInstance
{
    if(sharedSingleton==nil){
        sharedSingleton = [[CarList alloc] init];
    }
    return sharedSingleton;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未识别的key:%@",key);
}


-(NSString *)description{
    return [NSString stringWithFormat:@"key:%@",self.key];
}


@end
