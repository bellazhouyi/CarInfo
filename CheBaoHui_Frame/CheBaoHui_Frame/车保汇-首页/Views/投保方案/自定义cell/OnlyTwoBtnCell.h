//
//  OnlyTwoBtnCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlyTwoBtnCell : UITableViewCell

/**
 *  用于显示险种名称的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLabel;
/**
 *  是否选择某种险种的Button
 */
@property (weak, nonatomic) IBOutlet UIButton *isSelectedInsuranceBtn;

/**
 *  保价金额Button
 */
@property (weak, nonatomic) IBOutlet UIButton *selectMoneyBtn;

/**
 *  是否显示控件
 */
@property(nonatomic,assign) BOOL isShow;


@end
