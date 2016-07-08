//
//  HeadPortraitTableViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/2/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "HeadPortraitTableViewCell.h"
#import "MineItemModel.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"

@interface HeadPortraitTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *headportaitView;

@end

@implementation HeadPortraitTableViewCell


-(void) setItem:(MineItemModel *)item
{
    _item = item;

    self.label.text = item.funcName;
    NSURL * url = [NSURL  URLWithString:item.headerImageUrl];
    
    //下载图片
    [[SDWebImageManager  sharedManager] downloadImageWithURL: url  options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        self.headportaitView.image =[image  transformtoSize:CGSizeMake(HEADPORTAIT_WIDTH, HEADPORTAIT_HEIGHT) image:image];
        self.headportaitView.centerY =  self.contentView.centerY;
        
        if(self.item.accessoryType == MineAccessoryTypeHeadPortrait){
            
            self.headportaitView.backgroundColor = [UIColor   grayColor];
            self.headportaitView.layer.masksToBounds = YES;
            self.headportaitView.layer.cornerRadius =self.headportaitView.frame.size.width  / 2;
            self.headportaitView.x = SCREEN_WIDTH - self.headportaitView.width - DetailViewToIndicatorGap - 2;
        }
    
    }];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
