//
//  CarList.h
//  Template_Joker
//
//  Created by Bella on 16/2/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarList : NSObject



+(CarList * ) sharedInstance;


@property(nonatomic,copy) NSString *key;

@property(nonatomic,copy) NSString *value;


@property(nonatomic,assign) BOOL flag;

@property (nonatomic , copy) NSString * image1;

@property (nonatomic , copy) NSString * image2;

@property(nonatomic,assign) BOOL isImage;


@end
