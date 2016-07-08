
//
//  JKViewController.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/22.
//  Copyright © 2016年 Joker. All rights reserved.
//


/*
   上传图片来自哪里
 */
typedef NS_ENUM(NSInteger  , ImageFromType) {
    ImageFromTypeAuthentication=1, //认证
    ImageFromTypePortrait, //上传头像
    ImageFromTypeConfirmList, // 确认保单
    ImageFromTypeAddCar,  //来自车辆信息添加
    ImageFromTypeCarInfo //来自车辆详情上传图片
};

// 证件类型,1-头像，2-身份证，3-资格证，4-行驶证，5-车辆信息，6-其他
typedef  NS_ENUM(NSInteger ,  KevinBaseType )
{
    KevinBaseTypePortrait=1, //头像
    KevinBaseTypeIDCard,//身份证
    KevinBaseTypeCredentials, //资格证
    KevinBaseTypeDrivingLicense, //行驶证
    KevinBaseTypeCarsInfo,  //车辆信息
    KevinBaseTypeOther //其他
};


/**
 *  认证上传时候区分  身份证 正面 反面 和资格证内页
 */
typedef NS_ENUM( NSInteger ,  PhotoType) {
    PhotoTypeIDCardFront =1, //正面
    PhotoTypeIDCardVerso,  //反面
    PhotoTypeCredentials// 资格证内页
};

/**
 *  车辆添加的时候用来证明 反面或者是正面
 */
typedef NS_ENUM(NSInteger , PositiveWithReverseType ) {
    PositiveType=1, //正面
    ReverseType//反面
};


//确认保单时候  区分  是被保人即车主 还是 投保人即被保人
typedef NS_ENUM(NSInteger , CarOwnerWithComplainantType){
    CarOwnerType,  //被保人即车主
    ComplainantType// 投保人即投保人
};


/* 
 确认保单时候  区分  是被保人即车主 还是 投保人即被保人
 url:图片的url
 type: 是车主还是被保人
 photoType:证件反面和正面
 photoId: 相册的id
 */
typedef void(^ConfirmListCallBlock)(NSString * url, CarOwnerWithComplainantType type, PhotoType  photoType, NSString * photoId);

/*
  上传认证
 */
typedef void(^AuthenticationCallBlock)(NSString * url, KevinBaseType type, PhotoType  photoType, NSString * photoId);

typedef void(^AddCarInfoCallBlock)(NSString * url, PositiveWithReverseType type,KevinBaseType baseType,  NSString *  photoId);

typedef void(^RemoveKevinBaseView)();

@protocol  KevinBaseControllerDelegate  <NSObject>


@optional
-(void)  callback:(UIImage  *) image  type:(PhotoType) photoType  baseType:(KevinBaseType ) baseType  photoId :(NSString * ) photoId;
/**
 *
 *身份证上传代理
 *  @param type
 */
-(void) idCardCallback:(NSString * ) url  type:(PositiveWithReverseType)  type     photoId:(NSString * )photoId;

/**
 * 行驶证上传代理
 */
-(void) dlCallback:(NSString * )url  type:(PositiveWithReverseType)  type  photoId:(NSString * )photoId;

@end


@interface KevinBaseController : JJBaseController

/**
 *  证件类型,1-头像，2-身份证，3-资格证，4-行驶证，5-车辆信息，6-其他
 */
@property(nonatomic , assign) KevinBaseType  baseType;


@property (nonatomic , assign)PhotoType  photoType;

/**
 *车辆添加的时候用来证明 反面或者是正面
 */
@property (nonatomic ,assign ) PositiveWithReverseType prTtype;

/*
  确认保单时候  区分  是被保人即车主 还是 投保人即被保人
 */
@property (nonatomic , assign) CarOwnerWithComplainantType carOwnerWithComplainateType;

//确认图片来自那个地方
@property (nonatomic , assign) ImageFromType  imageFromType;

//确认保单的block
@property (nonatomic , copy) ConfirmListCallBlock  confirmListCallBlock;

//认证的block
@property (nonatomic , copy) AuthenticationCallBlock authenticationCallBlock;

@property (nonatomic ,copy) AddCarInfoCallBlock addCarInfoCallBlock;

//用来删除视图的block
@property (nonatomic , copy)RemoveKevinBaseView removeKevinBaseView;

#pragma mark -- 调用系统相册
-(void)callCameraOrPhotoLibary;


@property (nonatomic , weak) id   delegate;


@end
