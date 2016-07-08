//
//  CarInfoTableViewController.h
//  Template_Joker
//
//  Created by Bella on 16/2/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarInfo,PolicyListsModel,InsureDataModel;

/**
 *  接收来自车辆信息界面传回来的相关数据
 *
 *  @param sfz_Number   车主身份证号码
 *  @param phone_Number 车主电话号码
 *  @param cz_sf1_id    车主 身份证正面照id
 *  @param cz_sf2_id    车主 身份证反面照id
 *  @param xs1_id       车辆行驶证 正面照id
 *  @param xs2_id       车辆行驶证 反面照id
 */
typedef void(^passValueFromCarInfoTVC)(NSString *sfz_Number,NSString *phone_Number,NSString * cz_sf1_id,NSString *cz_sf2_id,NSString *xs1_id,NSString *xs2_id);



@interface CarInfoTableViewController : UITableViewController


/**
 *  接收确认保单界面传来的车辆信息
 */
@property(nonatomic,strong) CarInfo *carInfo;


/**
 *  接收确认保单界面传来的比价结果信息
 */
@property(nonatomic,strong) PriceDetail *priceDetail;

/*
 车辆详细点击
 */
@property (nonatomic ,strong) PolicyListsModel *  policyListsModel;
@property(nonatomic,strong) InsureDataModel *insureDataModel;
@property(nonatomic,strong) NSDictionary *contents;

/**
 是否有点击事件和是否有提交按钮  YES 是有点击事件和有提交按钮
 */
@property (nonatomic , assign) BOOL isClickWithShowView;


@property(nonatomic,strong) passValueFromCarInfoTVC passValue;

@end
