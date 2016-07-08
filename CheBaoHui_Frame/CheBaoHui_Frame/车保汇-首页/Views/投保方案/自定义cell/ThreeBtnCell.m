//
//  ThreeBtnCell.m
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ThreeBtnCell.h"

@implementation ThreeBtnCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.insuranceNameLable sizeToFit];
   
    
    self.isShow = NO;
    [self isShowWithValue:_isShow];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -- 传值
-(void)passTextOfInsuranceName:(NSString *)text isSelectedInsuranceBtnWithTag:(NSInteger)tag{
    self.insuranceNameLable.text = text;
    self.isSelectedInsuranceBtn.tag = tag;
 
}

#pragma mark -- 不计免赔
-(void)notDutyAction:(BOOL)flag{
    if (YES == flag) {
        [self.notDutyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [self.notDutyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
}

#pragma mark -- 显示控件
-(void)isShowWithValue:(BOOL)isShow{
    if (YES == isShow) {
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_checked.png"] forState:UIControlStateNormal];
        self.selectMoneyBtn.hidden = NO;
        self.notDutyBtn.hidden = NO;
    }else{
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_normal.png"] forState:UIControlStateNormal];
        self.selectMoneyBtn.hidden = YES;
        self.notDutyBtn.hidden = YES;
    }
}



@end
