//
//  ContactViewCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ContactModel;

@interface ContactViewCell : UITableViewCell

@property (nonatomic , strong) ContactModel *  contact;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
