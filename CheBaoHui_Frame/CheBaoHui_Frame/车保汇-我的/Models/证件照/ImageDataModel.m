//
//  ImageDataModel.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ImageDataModel.h"

@implementation ImageDataModel


static  ImageDataModel *  sharedSingleton = nil;


+(ImageDataModel * ) sharedInstance
{
    if(sharedSingleton==nil){
        sharedSingleton = [[ImageDataModel alloc] init];
    }
    return sharedSingleton;
}

@end
