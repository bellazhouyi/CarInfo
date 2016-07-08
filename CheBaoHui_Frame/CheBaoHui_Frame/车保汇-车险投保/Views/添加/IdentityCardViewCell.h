//
//  ButtonTableViewCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AddCarModel;

typedef NS_ENUM(NSInteger, IdentityCardTagType) {
    IdentityCardTagTypePositive=1,
    IdentityCardTagTypereverse
};

@protocol   IdentityCardCellViewCellDelegate  <NSObject>

//通过代理
-(void)identityCardViewCellWithTagType:(IdentityCardTagType) tagType;


@end


@interface IdentityCardViewCell : UITableViewCell


@property (nonatomic, strong) AddCarModel *addCarItem;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic , weak) id delegate;



@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel * particularLabel;

/**
 *  正面
 */
@property (weak, nonatomic) IBOutlet UIButton *positiveUIButton;
/**
 *  反面
 */

@property (weak, nonatomic) IBOutlet UIButton *reverseButton;


@end
