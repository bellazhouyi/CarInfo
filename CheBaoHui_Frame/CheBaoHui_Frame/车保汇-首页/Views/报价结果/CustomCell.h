//
//  CustomCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

/**
 *  公司标志 图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *companyIconImg;
/**
 *  公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;

/**
 *  总价
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;



@end
