//
//  MineItemModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MineAccessoryType) {
    MineAccessoryTypeNone,                   // don't show any accessory view
    MineAccessoryTypeDisclosureIndicator,    // the same with system DisclosureIndicator
    MineAccessoryTypeSwitch,                 //  swithch
    MineAccessoryTypeHeadPortrait,  //头像
    MineAccessoryTypeCenter  //需要做居中
};


typedef void(^executedCode)();


@interface MineItemModel : NSObject

/**
 *  名字
 */
@property (nonatomic ,copy) NSString * funcName;

/**
 *  图片
 */
@property (nonatomic , strong)  UIImage *  img;

/**
 *  更多
 */
@property (nonatomic , strong ) UIImage * detailImage;

//图片的url
@property (nonatomic, copy) NSString *  detailImageUrl;

/**
 *
 */
@property (nonatomic , copy) NSString *  synopsisName;


/**
更多信息-提示文字
 */
@property (nonatomic,copy) NSString *detailText;

@property (nonatomic,copy) NSString * hasColordetailText;

@property (nonatomic ,  assign)  MineAccessoryType  accessoryType;

@property (nonatomic , copy) NSString *  headerImageUrl;

//  点击item要执行的代码
@property (nonatomic , copy)  void (^executeCode) ();

/**<  XBSettingAccessoryTypeSwitch下开关变化 */
@property (nonatomic , copy) void (^switchValueChanged)(BOOL isOn);

@end
