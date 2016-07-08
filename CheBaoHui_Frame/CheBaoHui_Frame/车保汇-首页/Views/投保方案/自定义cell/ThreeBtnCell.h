//
//  ThreeBtnCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Button+Lable+Lable+Button+Button
 */
@interface ThreeBtnCell : UITableViewCell

/**
 *  用于显示险种名称的Lable
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLable;
/**
 *  是否选择某种险种的Button
 */
@property (weak, nonatomic) IBOutlet UIButton *isSelectedInsuranceBtn;

/**
 *  选择报价金额
 */
@property (weak, nonatomic) IBOutlet UIButton *selectMoneyBtn;

/**
 *  不计免赔Button
 */
@property (weak, nonatomic) IBOutlet UIButton *notDutyBtn;

/**
 *  是否显示控件
 */
@property(nonatomic,assign) BOOL isShow;

-(void)notDutyAction:(BOOL)flag;

@end
