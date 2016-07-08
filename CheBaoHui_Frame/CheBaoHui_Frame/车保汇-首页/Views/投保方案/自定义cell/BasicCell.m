//
//  BasicCell.m
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BasicCell.h"

@implementation BasicCell

- (void)awakeFromNib {
    // Initialization code
    [self.insuranceNameLable sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 显示控件
-(void)isShowWithValue:(BOOL)isShow{
    if (YES == isShow) {
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_checked.png"] forState:UIControlStateNormal];
    }else{
        [self.isSelectedInsuranceBtn setBackgroundImage:[UIImage imageNamed:@"check_box_normal.png"] forState:UIControlStateNormal];
    }
}

@end

/**
 *  实现类目，绘制分割线
 */
@implementation UITableViewCell (SeperatorLine)

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width - 1, 1));
}


-(void)passTextOfInsuranceName:(NSString *)text isSelectedInsuranceBtnWithTag:(NSInteger)tag{
    
}

@end
