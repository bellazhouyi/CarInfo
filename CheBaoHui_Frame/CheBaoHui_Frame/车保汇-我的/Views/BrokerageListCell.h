//
//  BrokerageListCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrokerageListModel;


typedef NS_ENUM(NSInteger, BrokerageType) {
    BrokerageTypeIncome,
    BrokerageTypeExamine,    // the same with system DisclosureIndicator
    BrokerageTypeWithdrawCash
};


@interface BrokerageListCell : UITableViewCell

//佣金明细数据模型
@property (nonatomic , strong) BrokerageListModel *  brokerage;

@property (nonatomic,copy) NSString *  descTitle;

@property (nonatomic , assign) BrokerageType  brokerageType;

@end
