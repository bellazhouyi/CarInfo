//
//  PersonDetailCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDetailCell : UITableViewCell


/**
 *  正面照Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *zhengMianBtn;

/**
 *  反面照Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *fanMianBtn;


/**
 *  被保人姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


/**
 *  被保人电话
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;











@end
