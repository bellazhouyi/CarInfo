//
//  AddCarModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddCarModel : NSObject


typedef NS_ENUM(NSInteger, AddCarAccessoryType) {
    AddCarAccessoryTypeNone,
    AddCarAccessoryTypeDisclosureIndicator,
    AddCarAccessoryTypeHasRangeAndDownImage,  //有区域名和downimage图片
    AddCarAccessoryTypeButton,
    AddCarAccessoryTypeSubmitButton,  //提交按钮
    AddCarAccessoryTypeSelectDate 
};


typedef NS_ENUM(NSInteger, DateType) {
    DateTypeRegister =1, // 注册时间
    DateTypeCompulsoryInsurance, //交强险
    DateTypeCommercialInsurance
};

typedef NS_ENUM(NSInteger, CardType) {
    CardTypeIdCard =1,
    CardTypeDrivingLicense
};

/**
 *  车辆添加的时候用来证明 反面或者是正面
 */
typedef NS_ENUM(NSInteger , AddCarModelPositiveWithReverseType ) {
   AddCarModelPositiveType=1, //正面
    AddCarModelReverseType//反面
};





/**
 * 头部字
 */
@property (nonatomic , copy) NSString * leftText;

@property (nonatomic, copy) NSString * particularText;

/**
 *  输入框
 */
@property (nonatomic , strong) UITextField * textFiled;

/**
 *  区域名
 */
@property (nonatomic , copy) NSString * rangeName;

/**
 *  图片
 */
@property (nonatomic , copy) NSString * downImage;


/**
 *  图片正面
 */
@property (copy, nonatomic) NSString *positiveImageUrl;
/**
 *   图片反面
 */

@property (copy, nonatomic)  NSString *reverseImageUrl;
/**
 *  按钮个数
 */
@property (nonatomic , assign) NSInteger   buttonCount;

@property (nonatomic , copy) NSString * placeholderText;

@property (nonatomic , assign) AddCarAccessoryType  accessoryType;

/**
 *  正面type
 */
@property (nonatomic , assign) NSInteger  positive;
@property (nonatomic , assign) NSInteger  reverse;


/**
 *  注册时间 到期时间 等等
 */
@property (nonatomic , assign) DateType dateType;

// 判断是身份证还是行驶证
@property (nonatomic , assign)CardType cardType;
@end
