//
//  ImageDataModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataModel : NSObject

+(ImageDataModel * ) sharedInstance;

@property ( nonatomic, weak) NSData *identityCardFront;
@property (nonatomic, weak) NSData *identityCardVerso;
@property ( nonatomic, weak) NSData *competencyPage;

@property ( nonatomic , copy) NSString *identityCardFrontId;
@property ( nonatomic, copy) NSString *identityCardVersoId;
@property ( nonatomic, copy) NSString *competencyPageId;


@end
