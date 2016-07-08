//
//  ButtonTableViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DrivingLicenseCell.h"
#import "AddCarModel.h"




@interface DrivingLicenseCell()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel * particularLabel;

/**
 *  正面
 */
@property (weak, nonatomic) IBOutlet UIButton *positiveUIButton;
/**
 *  反面
 */

@property (weak, nonatomic) IBOutlet UIButton *reverseButton;

@end

@implementation DrivingLicenseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"DrivingLicenseCell";
    
    DrivingLicenseCell * cell = [tableView  dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        NSLog(@"1111");
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DrivingLicenseCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


-(void)setAddCarItem:(AddCarModel *)addCarItem
{
    _addCarItem = addCarItem;
    
    self.leftLabel.text = addCarItem.leftText;
    
    self.particularLabel.text = addCarItem.particularText;
    if([addCarItem.positiveImageUrl  containsString:@"http"] ){
        NSURL * positiveUrl = [NSURL  URLWithString:addCarItem.positiveImageUrl];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:positiveUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [self.positiveUIButton setImage:  image forState:UIControlStateNormal];
        }];
        
    }else{
        [self.positiveUIButton setImage: [UIImage  imageNamed:addCarItem.positiveImageUrl]  forState:UIControlStateNormal];
    }
    if([addCarItem.reverseImageUrl containsString:@"http"]){
        NSURL * reverseUrl = [NSURL  URLWithString:addCarItem.reverseImageUrl ];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:reverseUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [self.reverseButton  setImage: image forState:UIControlStateNormal];
        }];
        
    }else{
        [self.reverseButton  setImage: [UIImage imageNamed:addCarItem.reverseImageUrl] forState:UIControlStateNormal];
    }
    [self.positiveUIButton.layer setMasksToBounds:YES];
    [self.positiveUIButton.layer  setCornerRadius:5.0f];
    [self.reverseButton.layer setMasksToBounds:YES];
    [self.reverseButton.layer  setCornerRadius:5.0f];
    
    
    
}

/**
 *正面
 */
- (IBAction)idCardPositiveClick:(UIButton *)sender {
    sender.tag = DrivingLicenseTagTypePositive;
    if([self.delegate respondsToSelector:@selector(drivingLicenseCellWithTagType:)]){
        [self.delegate  drivingLicenseCellWithTagType:DrivingLicenseTagTypePositive];
    }

}

/**
 * 反面
 */
- (IBAction)idCardReverseClick:(UIButton * )sender {
    sender.tag = DrivingLicenseTagTypereverse;
    if([self.delegate respondsToSelector:@selector(drivingLicenseCellWithTagType:)]){
        [self.delegate  drivingLicenseCellWithTagType:DrivingLicenseTagTypereverse];
    }

    
}





@end
