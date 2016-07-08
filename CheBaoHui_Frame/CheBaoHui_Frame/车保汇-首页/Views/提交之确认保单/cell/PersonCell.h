//
//  PersonCell.h
//  Template_Joker
//
//  Created by Bella on 16/1/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell

/**
 *  显示输入详细信息
 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@end

@interface UITableViewCell (SetNameForView)


-(void)setNameForViewWithSting:(NSString *)text;

@end