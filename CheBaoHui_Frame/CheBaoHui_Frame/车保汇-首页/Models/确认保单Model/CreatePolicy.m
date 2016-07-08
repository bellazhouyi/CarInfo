//
//  CreatePolicy.m
//  Template_Joker
//
//  Created by Bella on 16/2/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CreatePolicy.h"

@implementation CreatePolicy

-(NSString *)description{
    return [NSString stringWithFormat:@"%s,%d,交强险起保时间:%@,商业险起保时间:%@",__FUNCTION__,__LINE__,self.jqxbegintime,self.syxbegintime];
}


@end
