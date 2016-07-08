//
//  ImageData+CoreDataProperties.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *competencyPage;
@property (nullable, nonatomic, retain) NSData *identityCardFront;
@property (nullable, nonatomic, retain) NSData *identityCardVerso;
@property (nullable, nonatomic, retain) NSString *identityID;
@property (nullable, nonatomic, retain) NSString *identityCardFrontId;
@property (nullable, nonatomic, retain) NSString *identityCardVersoId;
@property (nullable, nonatomic, retain) NSString *competencyPageId;

@end

NS_ASSUME_NONNULL_END
