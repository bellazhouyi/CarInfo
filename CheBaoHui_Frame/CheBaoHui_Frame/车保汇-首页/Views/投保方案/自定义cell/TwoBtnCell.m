//
//  TwoBtnCell.m
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "TwoBtnCell.h"

@implementation TwoBtnCell

- (void)awakeFromNib {
    // Initialization code
    self.isShow = NO;
    [self.insuranceNameLable sizeToFit];
    [self isShowWithValue:_isShow];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/**
 *  给cell上的控件设值
 *
 *  @param text 险种名称
 *  @param tag  对应cell上的是否选择险种的Button的tag值
 */
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
#pragma mark -- 是否显示的控件
-(void)isShowWithValue:(BOOL)isShow{
    //YES 显示
    if (YES == isShow) {
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_checked.png"] forState:UIControlStateNormal];
        self.isOrNotInsuranceLabel.hidden = NO;
        self.notDutyBtn.hidden = NO;
    }else{
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_normal.png"] forState:UIControlStateNormal];
        self.isOrNotInsuranceLabel.hidden = YES;
        self.notDutyBtn.hidden = YES;
    }
}



@end
