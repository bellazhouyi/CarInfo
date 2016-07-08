//
//  BrokerageListModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerageListModel : NSObject

@property (nonatomic , copy ) NSString * Id;

@property(nonatomic,copy)NSString * BusinessUserId;

@property (nonatomic ,copy) NSString * Cntr_Id;

@property (nonatomic , copy) NSString * Cd_Date;

@property (nonatomic , strong) NSNumber * Amount;

@property (nonatomic , strong) NSNumber * CommissionRate;

@property (nonatomic , strong) NSNumber * CommissionAmount;

@property (nonatomic , copy) NSString * WithdrawalsDate;

@property (nonatomic , copy) NSString * OperatorNo;

@property (nonatomic ,copy) NSString * ValidateTime;

@property (nonatomic , copy) NSString * Status;

@property (nonatomic , copy) NSString * Cph_No;

@property (nonatomic , copy) NSString * Title;


@end
