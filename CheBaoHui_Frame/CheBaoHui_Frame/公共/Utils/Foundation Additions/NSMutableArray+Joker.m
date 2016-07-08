//
//  NSMutableArray+Joker.m
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import "NSMutableArray+Joker.h"

@implementation NSMutableArray (Joker)
- (id)safeObjectAtIndex:(NSUInteger)index
{
    if([self count] > 0 && [self count] > index){
        return [self objectAtIndex:index];
    }
    return nil;
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if(to != from)
    {
        id obj = [self safeObjectAtIndex:from];
        [self removeObjectAtIndex:from];
        
        if(to >= [self count]){
            [self addObject:obj];
        }else{
            [self insertObject:obj atIndex:to];
        }
    }
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

+ (NSMutableArray *)sortArrayByKey:(NSString *)key array:(NSMutableArray *)array ascending:(BOOL)ascending
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray removeAllObjects];
    [tempArray addObjectsFromArray:array];
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:brandDescriptor, nil];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
    [tempArray removeAllObjects];
    tempArray = (NSMutableArray *)sortedArray;
    [array removeAllObjects];
    [array addObjectsFromArray:tempArray];
    
    return array;
}

- (void)insertArray:(NSArray *)newAdditions atIndex:(NSUInteger)index
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for(NSUInteger i = index;i < newAdditions.count+index;i++)
    {
        [indexes addIndex:i];
    }
    [self insertObjects:newAdditions atIndexes:indexes];
}
@end
