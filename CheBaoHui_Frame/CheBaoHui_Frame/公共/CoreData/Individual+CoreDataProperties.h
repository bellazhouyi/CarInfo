//
//  Individual+CoreDataProperties.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Individual.h"

NS_ASSUME_NONNULL_BEGIN

@interface Individual (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *areaName;
@property (nullable, nonatomic, retain) NSString *individualId;
@property (nullable, nonatomic, retain) NSString *mobilePhone;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSString *photoUrl;
@property (nullable, nonatomic, retain) NSString *validateMsg;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *statusName;
@property (nullable, nonatomic, retain) NSString *idCardNoPhoto1Url;
@property (nullable, nonatomic, retain) NSString *idCardNoPhoto2Url;
@property (nullable, nonatomic, retain) NSString *qCertificatePhotoUrl;
@property (nullable, nonatomic, retain) NSString *idCardNoPhoto1;
@property (nullable, nonatomic, retain) NSString *idCardNoPhoto2;
@property (nullable, nonatomic, retain) NSString *qCertificatePhoto;


@end

NS_ASSUME_NONNULL_END
