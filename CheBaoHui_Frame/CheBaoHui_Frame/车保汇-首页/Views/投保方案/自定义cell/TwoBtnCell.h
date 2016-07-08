//
//  TwoBtnCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Button+Lable+Lable+Button
 */
@interface TwoBtnCell : UITableViewCell

/**
 *  用于显示险种名称的Lable
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLable;
/**
 *  是否选择某种险种的Button
 */
@property (weak, nonatomic) IBOutlet UIButton *isSelectedInsuranceBtn;

/**
 *  是否投保的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *isOrNotInsuranceLabel;

/**
 *  不计免赔的Button
 */
@property (weak, nonatomic) IBOutlet UIButton *notDutyBtn;

/**
 *  是否显示某控件标志
 */
@property(nonatomic,assign) BOOL isShow;



-(void)notDutyAction:(BOOL)flag;

@end
