//
//  SubmitViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SubmitViewCell.h"

@interface SubmitViewCell()
@property (weak, nonatomic) IBOutlet UIButton *paymentButton;


@end

@implementation SubmitViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+(instancetype) cellWithTableView:(UITableView * )tableView
{
    static NSString * ID = @"SubmitViewCell";
    
   SubmitViewCell * cell =  [tableView dequeueReusableCellWithIdentifier: ID];
    if(cell ==nil){
        cell = [[[NSBundle  mainBundle] loadNibNamed:@"SubmitViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}






@end
