//
//  HTTPManager.m
//  Template_Joker
//
//  Created by Bella on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "HTTPManager.h"

#import "CarInfo.h"
#import "PriceDetail.h"
#import "ShortNameForCity.h"

@interface HTTPManager ()

@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;;

@end

@implementation HTTPManager



+(HTTPManager *)sharedHTPPManager{
    static HTTPManager *manager ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HTTPManager new];
        
        
    });
    return manager;
}


#pragma mark -- 获取车牌开头，简称
-(void)getAllArea{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/GetShortDatas",BASE_URL,RELATIVE_PATH];
    
    [self.sessionManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:30];
        for (NSDictionary *dict in responseObject[@"data"]) {
            ShortNameForCity *item = [ShortNameForCity new];
            [item setValuesForKeysWithDictionary:dict];
            [mutableArray addObject:item];
        }
        self.passAllArea(mutableArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
}



#pragma mark -- 根据车牌号、车架号，查询车辆信息
-(void)GetCntr_CIInfoWithcph_no:(NSString *)cph_no cjh_no:(NSString *)cjh_no{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/GetCntr_ClInfo",BASE_URL,PRICE_PATH]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    NSDictionary *parametersDictionay = @{
                                          @"cph_no":cph_no,
                                          @"cjh_no":cjh_no
                                          };
    
    [self.sessionManager GET:urlStr parameters:parametersDictionay progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *data = responseObject[@"data"];
        NSLog(@"根据车架号查询的车辆信息>>>>>>>><<<<<<:%@",data);
        CarInfo *carInfo = [CarInfo new];
        
        if (![data isEqual:[NSNull null]]) {
            [carInfo setValuesForKeysWithDictionary:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                //有车辆信息
                self.passCarInfoInstance(carInfo);
                return ;
            });
        }else{
            NSLog(@"查不到车辆信息%@",responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //车辆信息为空
                self.passNullMsg_GetCntr_ClInfo();
                return ;
            });
        }
        //        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer ];
        //        if ([responseObject isKindOfClass:[NSArray class]]) {
        //            isClass = YES;
        //        } else{
        //            isClass = NO;
        //        }
        //        [responseObject writeToFile:PathNameAboutGetCntr_ClInfo atomically:YES];
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%d,%s,%@",__LINE__,__func__,error);
        self.passError();
    }];
    
    
    
}


#pragma mark -- 添加车辆信息
-(NSDictionary *)addCarInfoWithcph_no:(NSString *)cph_no
                              cz_name:(NSString *)cz_name
                             buy_date:(NSString *)buy_date
                              xh_code:(NSString *)xh_code
                               fdj_no:(NSString *)fdj_no
                               cjh_no:(NSString *)cjh_no
                         TransferTime:(NSString *)TransferTime
{
    NSDictionary *dictionary ;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/CreateVehicleInfo",BASE_URL,PRICE_PATH]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    
    NSDictionary *parametersDictionary = @{
                                           @"cph_no":cph_no,
                                           @"cz_name":cz_name,
                                           @"buy_date":buy_date,
                                           @"xh_code":xh_code,
                                           @"fdj_no":fdj_no,
                                           @"cjh_no":cjh_no,
                                           @"TransferTime":TransferTime
                                           };
    
    [self.sessionManager POST:urlStr parameters:parametersDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@">>>>添加车辆信息 进度:%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![[NSNull null] isEqual:responseObject[@"data"]]) {
            NSDictionary *dict = responseObject[@"data"];
            NSLog(@"添加车辆信息接口返回的数据<<<<>>>>:%@",dict);
            CarInfo *carInfo = [CarInfo new];
            [carInfo setValuesForKeysWithDictionary:dict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.passCarInfoInstance(carInfo);
                
            });
        }else{
            NSLog(@"没有数据,responseObject:%@",responseObject);
            self.passNullMsg_CreateVehicle();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        self.passErrorCreateVehicleInfo();
    }];
    
    
    return dictionary;
    
}


#pragma mark -- 比价
-(void)ImmediatelyOfferPriceWithcz_name:(NSString *)cz_name
                                 cph_no:(NSString *)cph_no
                                 cjh_no:(NSString *)cjh_no
                               buy_date:(NSString *)buy_date
                                  clssx:(NSString *)clssx
                                 dszzrx:(NSString *)dszzrx
                            dszzrxValue:(NSString *)dszzrxValue
                                  qcdqx:(NSString *)qcdqx
                                  sjzrx:(NSString *)sjzrx
                             sjzrxValue:(NSString *)sjzrxValue
                                  ckzrx:(NSString *)ckzrx
                             ckzrxValue:(NSString *)ckzrxValue
                                  blpsx:(NSString *)blpsx
                             blpsxValue:(NSString *)blpsxValue
                                  zrssx:(NSString *)zrssx
                             zrssxValue:(NSString *)zrssxValue;
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/GetPolicyPrice",BASE_URL,PRICE_PATH]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    
    //去掉空格
    cph_no = [cph_no removeSpace];
    cjh_no = [cjh_no removeSpace];
    
    NSDictionary *parametersDictionary = @{
                                           @"cz_name":cz_name,
                                           @"cph_no":cph_no,
                                           @"cjh_no":cjh_no,
                                           @"buy_date":buy_date,
                                           @"clssx":clssx,
                                           @"dszzrx":dszzrx,
                                           @"dszzrxValue":dszzrxValue,
                                           @"qcdqx":qcdqx,
                                           @"sjzrx":sjzrx,
                                           @"sjzrxValue":sjzrxValue,
                                           @"ckzrx":ckzrx,
                                           @"ckzrxValue":ckzrxValue,
                                           @"blpsx":blpsx,
                                           @"blpsxValue":blpsxValue,
                                           @"zrssx":zrssx,
                                           @"zrssxValue":zrssxValue
                                           };
    
    
    NSLog(@"%d,%s >>>>>%@",__LINE__,__func__,parametersDictionary);
    
    [self.sessionManager POST:urlStr parameters:parametersDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@">>>>比价 进度:%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //判断
        if (![[NSNull null] isEqual:responseObject[@"data"]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.passValue(responseObject[@"data"]);
                
            });
        }else{
            NSLog(@">>>>没有报价结果,responseObject:%@",responseObject);
            self.passNullMsg_GetPolicyPrice(responseObject[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  失败%@",error);
        self.passError();
        
    }];
}

#pragma mark -- 核保
-(void)confirmInsuranceAccountWithbusinessUserId:(NSString *)businessUserId
                                          cph_no:(NSString *)cph_no
                                          cjh_no:(NSString *)cjh_no
                                    company_code:(NSString *)company_code
                                          amount:(NSString *)amount
                                   policyPriceId:(NSString *)policyPriceId
                                     insurediscz:(BOOL)insurediscz
                                    insured_name:(NSString *)insured_name
                                   insured_phone:(NSString *)insured_phone
                                    insured_idno:(NSString *)insured_idno
                                  insured_sf1_id:(NSString *)insured_sf1_id
                                  insured_sf2_id:(NSString *)insured_sf2_id
                                 insuredisholder:(BOOL)insuredisholder
                                     holder_name:(NSString *)holder_name
                                    holder_phone:(NSString *)holder_phone
                                     holder_idno:(NSString *)holder_idno
                                   holder_sf1_id:(NSString *)holder_sf1_id
                                   holder_sf2_id:(NSString *)holder_sf2_id
                                    jqxbegintime:(NSString *)jqxbegintime
                                      jqxendtime:(NSString *)jqxendtime
                                    syxbegintime:(NSString *)syxbegintime
                                      syxendtime:(NSString *)syxendtime
                                         xh_code:(NSString *)xh_code
                                          fdj_no:(NSString *)fdj_no
                                        buy_date:(NSString *)buy_date
                                         cz_name:(NSString *)cz_name
                                       Idcard_No:(NSString *)Idcard_No
                                          Sf1_Id:(NSString *)Sf1_Id
                                          SF2_Id:(NSString *)SF2_Id
                                     xsz_xs_code:(NSString *)xsz_xs_code
                                        xs1_path:(NSString *)xs1_path
                                        xs2_path:(NSString *)xs2_path
                                          ps_way:(NSString *)ps_way
                                        sdr_name:(NSString *)sdr_name
                                      sdr_mobile:(NSString *)sdr_mobile
                                        sdr_addr:(NSString *)sdr_addr
{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/CreatePolicy",BASE_URL,PRICE_PATH]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
   
    
    NSDictionary *parametersDictionary = @{
                                           @"businessUserId":businessUserId,
                                           @"cph_no":cph_no,
                                           @"cjh_no":cjh_no,
                                           @"company_code":company_code,
                                           @"amount":amount,
                                           @"policyPriceId":policyPriceId,
                                           @"policyPriceId":policyPriceId,
                                           @"insurediscz":[NSString stringWithFormat:@"%d",insurediscz],
                                           @"insured_name":insured_name,
                                           @"insured_phone":insured_phone,
                                           @"insured_idno":insured_idno,
                                           @"insured_sf1_id":insured_sf1_id,
                                           @"insured_sf2_id":insured_sf2_id,
                                           @"insuredisholder":[NSString stringWithFormat:@"%d",insuredisholder],
                                           @"holder_name":holder_name,
                                           @"holder_phone":holder_phone,
                                           @"holder_idno":holder_idno,
                                           @"holder_sf1_id":holder_sf1_id,
                                           @"holder_sf2_id":holder_sf2_id,
                                           @"jqxbegintime":jqxbegintime,
                                           @"jqxendtime":jqxendtime,
                                           @"syxbegintime":syxbegintime,
                                           @"syxendtime":syxendtime,
                                           @"xh_code":xh_code,
                                           @"fdj_no":fdj_no,
                                           @"buy_date":buy_date,
                                           @"cz_name":cz_name,
                                           @"Idcard_No":Idcard_No,
                                           @"Sf1_Id":Sf1_Id,
                                           @"SF2_Id":SF2_Id,
                                           @"xsz_xs_code":xsz_xs_code,
                                           @"xs1_path":xs1_path,
                                           @"xs2_path":xs2_path,
                                           @"ps_way":ps_way,
                                           @"sdr_name":sdr_name,
                                           @"sdr_mobile":sdr_mobile,
                                           @"sdr_addr":sdr_addr
                                           };
    
    NSLog(@"核保参数:%@",parametersDictionary);
    [self.sessionManager POST:urlStr parameters:parametersDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@">>>>核保 进度:%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![[NSNull null] isEqual:responseObject[@"data"]]) {
            
            self.passCntr_id(responseObject[@"data"]);
        }else{
            NSLog(@"核保没有返回数据");
            self.passNullMsg_CreatePolicy();
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        self.passErrorCreatePolicy();
    }];
    
}


#pragma mark -- 支付接口,支付宝、微信的扫码支付
-(void)payInsurancePriceWithps_way:(NSString *)ps_way
                          sdr_name:(NSString *)sdr_name
                        sdr_mobile:(NSString *)sdr_mobile
                          sdr_addr:(NSString *)sdr_addr
                           cntr_id:(NSString *)cntr_id
                            amount:(CGFloat )amount
                           paytype:(NSString *)paytype
                            cardno:(NSString *)cardno
                       companycode:(NSString *)companycode{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/PayPolicy",BASE_URL,PRICE_PATH]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
#warning 银联支付的时候，这里的companycode 目前只支持 人保RBCX，太平TPCX
    NSDictionary *parameters = @{
                                 @"ps_way":ps_way,
                                 @"sdr_name":sdr_name == nil ? @"" : sdr_name,
                                 @"sdr_mobile":sdr_mobile == nil ? @"" : sdr_mobile,
                                 @"sdr_addr":sdr_addr == nil ? @"" : sdr_addr,
                                 @"cntr_id":cntr_id,
                                 @"amount":[NSString stringWithFormat:@"%.2f",amount],
                                 @"paytype":paytype,
                                 @"cardno":cardno,
                                 @"companycode":@"RBCX"
                                 };
    
    NSLog(@"行:%d,方法名:%s,参数:%@",__LINE__,__func__,parameters);
    
   
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"扫码支付 进程%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@">>>>>>responseObject:%@",responseObject);
        
        NSArray *array = responseObject[@"data"];
        
        if ([cash isEqualToString:paytype]) {
            
            self.passNullMsg_PayPolicy(responseObject);
            
            return ;
        }
        
        if (![[NSNull null] isEqual:array]) {
            
            if ([wechat isEqualToString:paytype]) {
                self.passErWeiMaURL([[array firstObject] objectForKey:@"url"]);
                //开放平台商户--统一下单返回的数据
                self.passPrepayid([array lastObject]);
            }else if ([yinLian isEqualToString:paytype]){
                
                //银联支付 返回HTML跳转到 网页支付
                self.passYinLianData([[array firstObject] objectForKey:@"url"]);
            }
            else{
                self.passErWeiMaURL([[array firstObject] objectForKey:@"url"]);
            }
            
        }else{
            NSLog(@"扫码支付没得返回结果,%@",responseObject);
            self.passNullMsg_PayPolicy(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"支付接口失败%@",error);
        self.passErrorPayPolicy();
    }];
}


#pragma mark -- 查询支付状态
-(void)getPayStatusWithcntr_id:(NSString *)cntr_id payType:(NSString *)payType{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/GetPayStatus",BASE_URL,PRICE_PATH]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    
    NSDictionary *dict = @{
                           @"paytype":payType,
                           @"cntr_id":cntr_id
                           };
    
    [self.sessionManager GET:urlStr parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"支付进程%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"支付成功%@",responseObject);
        if (![[NSNull null] isEqual:responseObject]) {
            
            self.passPayStatus([NSString stringWithFormat:@"%@",responseObject]);
        }else{
            NSLog(@"支付状态为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"支付失败%@",error);
    }];
    
    
}


-(AFHTTPSessionManager *)sessionManager{
    if (nil == _sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    
    return _sessionManager;
}



@end
