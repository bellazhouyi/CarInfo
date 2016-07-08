//
//  DataModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject


//ValidateMsg
@property (nonatomic , copy) NSString * ValidateMsg;

//MobilePhone
@property (nonatomic , copy) NSString * MobilePhone;

//PhotoUrl
@property (nonatomic , copy) NSString * PhotoUrl;

//Id
@property (nonatomic , copy) NSString * Id;

//NickName
@property (nonatomic , copy) NSString * NickName;

//Name
@property (nonatomic , copy) NSString * Name;

//AreaName
@property (nonatomic , copy) NSString * AreaName;

@property ( nonatomic, copy) NSString *Status;

@property ( nonatomic, copy) NSString *StatusName;

@property ( nonatomic, copy) NSString *IdCardNoPhoto1Url;

@property ( nonatomic, copy) NSString *IdCardNoPhoto2Url;

@property ( nonatomic, copy) NSString *QCertificatePhotoUrl;

@property ( nonatomic, copy) NSString *IdCardNoPhoto1;

@property ( nonatomic, copy) NSString * IdCardNoPhoto2;

@property ( nonatomic, copy) NSString *QCertificatePhoto;

/**
 *  身份证号
 */
@property (nonatomic , copy) NSString * IdCardNo;

/**
 *  资格号
 */
@property (nonatomic, copy) NSString * QCertificateNo;

/**
 *  银行卡号
 */
@property (nonatomic , copy) NSString * BankNo;


@property (nonatomic , assign) NSInteger PageIndex;

@property (nonatomic , assign) NSInteger PageSize;

@property (nonatomic , assign) NSInteger TotalRowCount;

@property (nonatomic , assign) NSInteger TotalPage;

@property (nonatomic , strong)NSArray * Data;

@property (nonatomic , copy) NSString * Url;


@end
