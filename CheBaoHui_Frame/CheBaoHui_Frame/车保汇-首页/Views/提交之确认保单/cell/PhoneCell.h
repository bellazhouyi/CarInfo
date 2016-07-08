//
//  phoneCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCell : UITableViewCell
/**
 *  fisrtLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

/**
 *  nameLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UIButton *callBtn;


@property(nonatomic,strong) NSString *phoneNumber;


@end
