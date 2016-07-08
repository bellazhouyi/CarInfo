//
//  AddCarInfoViewCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AddCarModel;

@protocol AddCarInfoViewCellDelegate  <NSObject>

/**
 *  通过通知进行显示时间选择弃
 */
-(void) addCarInfoViewShowPickerDateWithTitle:(NSString * ) title  withTag:(NSInteger ) tag;

@end


@interface AddCarInfoViewCell : UITableViewCell


@property (nonatomic , strong) AddCarModel * item ;  //ITEM data

@property (nonatomic , weak) id   delegate;

@end
