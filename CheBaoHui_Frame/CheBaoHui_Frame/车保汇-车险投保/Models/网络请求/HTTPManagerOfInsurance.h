//
//  HTTPManagerOfInsurance.h
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/15.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -- 核保中接口 的block定义
/**
 *  核保中 接口，成功返回值
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetDoingInsureDatas)(id responseObject);

/**
 *  核保中接口，失败返回值
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetDoingInsureDatas)(NSError *error);


#pragma mark -- 车辆保单投保人等详情 接口 的block定义

/**
 *  车辆保单投保人等详情 接口,成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetInsureData)(id responseObject);

/**
 *  车辆保单投保人等详情 接口,失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetInsureData)(NSError * error);


@interface HTTPManagerOfInsurance : NSObject


#pragma mark -- 属性
#pragma mark -- 核保中的block
@property(nonatomic,copy) passResponseObjectOfGetDoingInsureDatas passResponseObjectOfGetDoingInsureDatas;

@property(nonatomic,copy) passErrorOfGetDoingInsureDatas passErrorOfGetDoingInsureDatas;

#pragma mark -- 车辆保单投保人等详情 接口 的block
@property(nonatomic,copy) passResponseObjectOfGetInsureData passResponseObjectOfGetInsureData;

@property(nonatomic,copy) passErrorOfGetInsureData passErrorOfGetInsureData;



#pragma mark -- 方法
#pragma mark -- 单例
+(HTTPManagerOfInsurance *)sharedHTTPManagerOfInsurance;


#pragma mark -- 核保中 接口
/**
 *  核保中 接口
 *
 *  @param businessUserId <#businessUserId description#>
 */
-(void)GetDoingInsureDatasWithbusinessUserId:(NSString *)businessUserId andStatus:(NSString *)status;


#pragma mark -- 车辆保单投保人等详情 接口
/**
 *  车辆保单投保人等详情 接口
 *
 *  @param cph_no    车牌号
 *  @param cjh_no 车架号
 */
-(void)GetInsureDataWithcph_no:(NSString *)cph_no cjh_no:(NSString *)cjh_no;



@end
