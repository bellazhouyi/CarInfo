//
//  DateCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCell : UITableViewCell
/**
 *  险种名称
 */
@property (weak, nonatomic) IBOutlet UILabel *InsuranceNameLabel;


/**
*  选择日期
*/
@property (weak, nonatomic) IBOutlet UIButton *pickDateBtn;


@end
