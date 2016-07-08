//
//  DrivingLicenseCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/30.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddCarModel;

typedef NS_ENUM(NSInteger, DrivingLicenseTagType) {
    DrivingLicenseTagTypePositive=1,
    DrivingLicenseTagTypereverse
};

@protocol   DrivingLicenseCellDelegate  <NSObject>
//通过代理
-(void)drivingLicenseCellWithTagType:(DrivingLicenseTagType) tagType;

@end

@interface DrivingLicenseCell : UITableViewCell

@property (nonatomic, strong) AddCarModel *addCarItem;

/** 提供一个类方法，可以快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic ,weak) id delegate;



@end
