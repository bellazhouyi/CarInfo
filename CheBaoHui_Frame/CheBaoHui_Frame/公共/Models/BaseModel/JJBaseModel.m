//
//  BaseModel.m
//
//  Created by pengshuai on 14/11/11.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//

#import "JJBaseModel.h"

@implementation JJBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

-(NSDictionary*)toDictionary{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSSet *set = [self.class propertyKeys];
    //迭代遍历
    NSEnumerator *enumerator = [set objectEnumerator];
    for (NSString *key in enumerator) {
        
        id value = [self valueForKey:key];
        if(value){
            [dic setObject:value forKey:key];
        }else{
            [dic setObject:@"" forKey:key];
        }
    }
    
    return dic;
}


@end
