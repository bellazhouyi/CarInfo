//
//  PersonCell.m
//  Template_Joker
//
//  Created by Bella on 16/1/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PersonCell.h"

@interface PersonCell ()

/**
 *  控件上显示的名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation PersonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setNameForViewWithSting:(NSString *)text{
    self.nameLabel.text = text;
}

@end
