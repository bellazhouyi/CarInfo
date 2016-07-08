//
//  OnlyTwoBtnCell.m
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OnlyTwoBtnCell.h"

@implementation OnlyTwoBtnCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.insuranceNameLabel sizeToFit];
    
    self.isShow = NO;
    [self isShowWithValue:_isShow];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 传值
-(void)passTextOfInsuranceName:(NSString *)text isSelectedInsuranceBtnWithTag:(NSInteger)tag{
    self.insuranceNameLabel.text = text;
    self.isSelectedInsuranceBtn.tag = tag;

}

#pragma mark -- 显示控件
-(void)isShowWithValue:(BOOL)isShow{
    if (YES == isShow) {
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_checked.png"] forState:UIControlStateNormal];
        self.selectMoneyBtn.hidden = NO;
    }else{
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_normal.png"] forState:UIControlStateNormal];
        self.selectMoneyBtn.hidden = YES;
    }
}



@end
