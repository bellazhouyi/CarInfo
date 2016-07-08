//
//  PriceDetail.h
//  Template_Joker
//
//  Created by Bella on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceDetail : NSObject


@property(nonatomic,strong) NSString *blpsx; //玻璃破碎险
@property(nonatomic,strong) NSString *ccs;  //车船税
@property(nonatomic,strong) NSString *ckzrx; //乘客责任险
@property(nonatomic,strong) NSString *ckzrx_b; //不计免赔的,乘客责任险
@property(nonatomic,strong) NSString *clssx; //车辆损失险
@property(nonatomic,strong) NSString *clssx_b; //不计免赔的,车辆损失险
@property(nonatomic,strong) NSString *cntr_id;
@property(nonatomic,strong) NSString *company_code;
@property(nonatomic,strong) NSString *company_name;
@property(nonatomic,strong) NSString *cshhx; //车身划痕险
@property(nonatomic,strong) NSString *dszzrx; //第三者责任险
@property(nonatomic,strong) NSString *dszzrx_b; //不计免赔的,第三者责任险
@property(nonatomic,strong) NSString *insuranceBeginTime;
@property(nonatomic,strong) NSString *insuranceEndTime;
@property(nonatomic,strong) NSString *jqx; //交强险
@property(nonatomic,strong) NSString *policyId;
@property(nonatomic,strong) NSString *qcdqx; //全车盗抢险
@property(nonatomic,strong) NSString *qcdqx_b; //不计免赔的,全车盗抢险
@property(nonatomic,strong) NSString *sjzrx; //司机责任险
@property(nonatomic,strong) NSString *sjzrx_b; //不计免赔的，司机责任险
@property(nonatomic,strong) NSString *ssx; //涉水险
@property(nonatomic,strong) NSString *zdzxc; //指定专修厂险
@property(nonatomic,strong) NSString *zrssx; //自燃损失险
@property(nonatomic,strong) NSString *zrssx_b; //不计免赔的,自燃损失险


@property(nonatomic,strong) NSString *cjh_no;
@property(nonatomic,strong) NSString *cph_no;


//总价,表示疑惑
@property(nonatomic,strong) NSString *amount;

@property(nonatomic,strong) NSString *amount1;

@end
