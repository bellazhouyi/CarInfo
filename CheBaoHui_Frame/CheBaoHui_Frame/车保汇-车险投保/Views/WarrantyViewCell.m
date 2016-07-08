//
//  WarrantyViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WarrantyViewCell.h"
#import "WarrantyModel.h"
#import "UIView+Extension.h"
#import "UILabel+Extension.h"


#define  GlobalFontSize  14

@interface WarrantyViewCell()


@property (nonatomic , strong)  UILabel * leftLabel;

@property (nonatomic , strong) UILabel * rightLabel;



@end


@implementation WarrantyViewCell


-(void)setWarranty:(WarrantyModel *)warranty
{
    _warranty = warranty;
    self.contentView.backgroundColor = ColorFromRGB(247, 243, 234);
    [self  updateUI];
    
}

-(void) updateUI
{
    [self.contentView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.contentView.height = 30;
    
    /**
     *  左侧文字
     */
    if(self.warranty.leftText){
        [self setupLeftText];
    }
    /**
     *  右侧文字
     */
    if(self.warranty.rightText){
        [self  setupRightText];
    }
}



/**
 *  设置左侧
 */
-(void)  setupLeftText
{
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.text = self.warranty.leftText;
    self.leftLabel.x = FuncImgToLeftGap;
    self.leftLabel.textColor =ColorFromRGB(152, 152,152);
    self.leftLabel.centerY = self.contentView.centerY * 0.5;
    self.leftLabel.size  = [self.leftLabel sizeForTitle: self.warranty.leftText withFont: self.leftLabel.font];
    self.leftLabel.font = [UIFont  systemFontOfSize:GlobalFontSize];
    [self.contentView addSubview:self.leftLabel];
}


/**
 *  设置右侧字体
 */
-(void) setupRightText
{
    self.rightLabel   = [[UILabel alloc] init];
    self.rightLabel.text = self.warranty.rightText;
    self.rightLabel.centerY = self.contentView.centerY * 0.5;
    if(self.warranty.warantyType == WarantyTypeStatus){
        self.rightLabel.textColor =[UIColor  blackColor];
    }else{
        self.rightLabel.textColor = ColorFromRGB(59, 158, 220);
    }
    self.rightLabel.font = [UIFont  systemFontOfSize:GlobalFontSize];
    
    self.rightLabel.size  = [ self.rightLabel sizeForTitle: self.warranty.rightText withFont: self.rightLabel.font];
    //self.rightLabel.centerY = self.contentView.centerY;
    self.rightLabel.x = SCREEN_WIDTH - self.rightLabel.width- 30;
    [self.contentView addSubview: self.rightLabel];
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
