//
//  ContactViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/2/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ContactViewCell.h"

@implementation ContactViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *  ID = @"ContactViewCell";
    
   ContactViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell = [[[NSBundle mainBundle]  loadNibNamed:@"ContactViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
    
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
