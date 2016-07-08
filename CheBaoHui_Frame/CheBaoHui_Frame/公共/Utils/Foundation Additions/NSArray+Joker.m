//
//  NSArray+Joker.m
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import "NSArray+Joker.h"

@implementation NSArray (Joker)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if([self count] > 0 && [self count] > index){
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSMutableArray *)reversedArray
{
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for(id element in enumerator){
        [arrayTemp addObject:element];
    }
    return arrayTemp;
}



- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end


@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

@end
