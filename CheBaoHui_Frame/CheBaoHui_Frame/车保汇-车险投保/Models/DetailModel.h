//
//  DetailModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

/**
 *  详情
 */
#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

typedef NS_ENUM(NSInteger, DetailAccessoryType) {
    DetailAccessoryTypeNone,
    DetailAccessoryTypeOwnerNameAndImage, //有图片和字
    DetailAccessoryTypeDisclosureIndicator , //有箭头
    DetailAccessoryTypeTextBlackAndBlueColor,
    DetailAccessoryTypeTextGrayColor,
    DetailAccessoryTypeTextBlackWithImageAndDate,//   字体黑色,有的有图片,有的有时间
    DetailAccessoryTypeTextBlackWithInputText
    
};


typedef NS_ENUM(NSInteger, DeliverWithPayWayType) {
    DeliverWithPayWayTypeDeliver=1,//配送
    DeliverWithPayWayTypePayWay//支付方式
};




/**
 * 头部字
 */
@property (nonatomic , copy) NSString *   headerTitle;

/**
 更多信息-提示文字
 */
@property (nonatomic,copy) NSString *detailText;

/**
 *  姓名
 */
@property (nonatomic ,copy) NSString * ownerName;

/**
 *  更多
 */
@property (nonatomic , strong ) UIImage * detailImage;

/**
 *  拨打电话的图片
 */
@property (nonatomic , strong)  NSString * imageStr;

/**
 *  用来装radio的view
 */
@property (nonatomic , strong) UIView *   radioView;

/**
 *  右侧文字
 */
@property (nonatomic , copy) NSString * rightText;

@property (nonatomic ,  assign)  DetailAccessoryType  accessoryType;

/**
 *保单配送和支付方式type
 */
@property (nonatomic , assign) DeliverWithPayWayType   deliverWithPayWayType;

/**
 *  显示到左侧的内容
 */
@property (copy, nonatomic) NSString * leftLabel;
/**
 *  显示text输入框中的提示
 */
@property (copy , nonatomic ) NSString  * placeholder;

/**
 *  输入内容
 */
@property(copy,nonatomic) NSString * inputText;

@property(strong,nonatomic)UITextField * inputTextFiled;

@property (nonatomic , copy) NSString *  url1;

@property (nonatomic , copy) NSString * url2;

@end
