//
//  HTTPManagerOfInsurance.m
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/15.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import "HTTPManagerOfInsurance.h"

@interface HTTPManagerOfInsurance ()


@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;


@end


static HTTPManagerOfInsurance * manager = nil;

@implementation HTTPManagerOfInsurance

#pragma mark -- 单例
+(HTTPManagerOfInsurance *)sharedHTTPManagerOfInsurance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTTPManagerOfInsurance alloc] init];
    });
    
    return manager;
}


#pragma mark -- 核保中 GET请求 接口
-(void)GetDoingInsureDatasWithbusinessUserId:(NSString *)businessUserId andStatus:(NSString *)status{
    NSString * urlStr ;
    
    if ([status isEqualToString:@"投保中"]) {
       urlStr = [NSString  stringWithFormat:@"%@/%@/GetDoingInsureDatas",BASE_URL,PRICE_PATH];
    }else if ([status isEqualToString:@"待投保"]){
        urlStr = [NSString  stringWithFormat:@"%@/%@/GetWaitInsureDatas",BASE_URL,PRICE_PATH];
    }else{
        urlStr = [NSString  stringWithFormat:@"%@/%@/GetHadInsureDatas",BASE_URL,PRICE_PATH];
    }
    NSLog(@"投保状态的URL:%@",urlStr);
    NSDictionary * parameters  = @{@"businessUserId":businessUserId};
    
    [self.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"核保中-接口-进度：%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfGetDoingInsureDatas(responseObject);
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfGetDoingInsureDatas(error);
        });
    }];
    
}


#pragma mark -- 车辆保单投保人等详情 接口

-(void)GetInsureDataWithcph_no:(NSString *)cph_no cjh_no:(NSString *)cjh_no{
    
    NSString * strUrl = [NSString   stringWithFormat:@"%@/%@/GetInsureData",BASE_URL,PRICE_PATH];
    
    NSDictionary * parameters = @{@"cph_no":cph_no , @"cjh_no":cjh_no};
    
   [self.sessionManager GET:strUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       dispatch_async(dispatch_get_main_queue(), ^{
           self.passResponseObjectOfGetInsureData(responseObject);
       });
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       dispatch_async(dispatch_get_main_queue(), ^{
           self.passErrorOfGetInsureData(error);
       });
       
   }];
}


#pragma mark -- 懒加载
-(AFHTTPSessionManager *)sessionManager{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return _sessionManager;
}

@end
