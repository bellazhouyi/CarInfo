//
//  TwoLabelCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLabelCell : UITableViewCell

/**
 *  险种名称
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceNameLabel;


/**
 *  险种价格
 */
@property (weak, nonatomic) IBOutlet UILabel *insurancePriceLabel;


/**
 *  险种报价结果
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceValueLabel;


@end
