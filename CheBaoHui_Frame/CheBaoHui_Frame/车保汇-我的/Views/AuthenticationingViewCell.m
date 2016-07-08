//
//  AuthenticationingViewTableViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AuthenticationingViewCell.h"
#import "UILabel+Extension.h"
#import "UIView+Extension.h"
#import "AuthenticationingModel.h"
#import "UIImage+Extension.h"


@interface AuthenticationingViewCell()

/**
 *  名字
 */
@property (nonatomic , strong) UILabel * funcNameLabel;


@property (nonatomic , strong)  UILabel * detailLabel;


@property (nonatomic , strong) UIImageView * detailImageView;

@end
@implementation AuthenticationingViewCell



- (void)awakeFromNib {

}

-(void) setItem:(AuthenticationingModel *)item
{
    _item = item;
    //名字
    if(self.item.funcName){
        [self setupFuncLabel];
    }
    if(self.item.detailText){
        [self   setupDetailText];
    }
    if(self.item.detailImageUrl){
        [self  setupDetailImage];
    }
}

-(void) setupDetailImage
{
    NSURL  * url = [NSURL  URLWithString: self.item.detailImageUrl];
    //下载图片
    [[SDWebImageManager  sharedManager] downloadImageWithURL:url   options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        UIImage * imageNew= [image  transformtoSize: CGSizeMake(60, 40) image: image];
        self.detailImageView   = [[UIImageView alloc] initWithImage:imageNew]  ;
        self.detailImageView.x =  SCREEN_WIDTH - self.detailImageView.width -DetailViewToIndicatorGap -2;
        self.detailImageView.centerY =  self.contentView.centerY;
        [self.contentView  addSubview: self.detailImageView];
    }];
}


-(void) setupDetailText
{
    self.detailLabel  = [[UILabel alloc] init];
    self.detailLabel.text =self.item.detailText;
    self.detailLabel.size  = [self.funcNameLabel sizeForTitle: self.item.detailText withFont: self.funcNameLabel.font];
    self.detailLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    self.detailLabel.size = [self.detailLabel sizeForTitle: self.item.detailText withFont:self.detailLabel.font];
    self.detailLabel.centerY = self.contentView.centerY;
    self.detailLabel.x =  SCREEN_WIDTH - self.detailLabel.width -DetailViewToIndicatorGap -2;
    [self.contentView  addSubview: self.detailLabel];
}


-(void) setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc] init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor =[UIColor  blackColor]; //ColorFromRGBA(51, 51, 51, 1);
    self.funcNameLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    self.funcNameLabel.size  = [self.funcNameLabel sizeForTitle: self.item.funcName withFont: self.funcNameLabel.font];
    self.funcNameLabel.centerY = self.contentView.height / 2;
    self.funcNameLabel.x  = FuncImgToLeftGap;
    [self.contentView addSubview: self.funcNameLabel];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
