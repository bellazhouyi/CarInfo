//
//  BasicCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Button+Lable+Lable
 */
@interface BasicCell : UITableViewCell


/**
 *  交险的名称
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLable;

/**
 *  是否选择某个险种的Button
 */
@property (weak, nonatomic) IBOutlet UIButton *isSelectedInsuranceBtn;


@end


/**
 *  类目，用于绘制cell的分割线
 */
@interface UITableViewCell (SeperatorLine)


/**
 *  传递险种名称和tag值
 */
-(void)passTextOfInsuranceName:(NSString *)text isSelectedInsuranceBtnWithTag:(NSInteger)tag;



@end


@interface UITableViewCell (IsShowView)

-(void)isShowWithValue:(BOOL)isShow;

@end


