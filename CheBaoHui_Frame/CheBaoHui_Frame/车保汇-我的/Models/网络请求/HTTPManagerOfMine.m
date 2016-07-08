//
//  HTTPManagerOfMine.m
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/15.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import "HTTPManagerOfMine.h"

@interface HTTPManagerOfMine ()

@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;


@end

static HTTPManagerOfMine *HTTPManagerOfMineInstance = nil;

@implementation HTTPManagerOfMine



#pragma mark -- 单例
/**
 *  单例
 *
 *  @return <#return value description#>
 */
+(HTTPManagerOfMine *)sharedHTTPManagerOfMine{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPManagerOfMineInstance = [[HTTPManagerOfMine alloc] init];
        
    });
    
    return HTTPManagerOfMineInstance;
}

#pragma mark -- 根据ID获取B端用户信息
-(void)GetBusinessUserByIdWithId:(NSString *)Id{
    
    NSString * urlStr = [NSString  stringWithFormat:@"%@/%@/GetBusinessUserById",BASE_URL,RELATIVE_PATH];
    
    NSDictionary * parameters =@{@"Id":Id};
    
    
    [self.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfGetBusinessUserById(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfGetBusinessUserById(error);
        });
    }];
}


#pragma mark -- 修改密码 接口
-(void)ModifyPasswordWithId:(NSString *)Id passwordOld:(NSString *)passwordOld passwordNew:(NSString *)passwordNew{
    
    NSString * urlStr = [ NSString  stringWithFormat:@"%@%@/ModifyPassword",BASE_URL,RELATIVE_PATH];
    
    NSDictionary *  parameters = @{@"Id":Id,@"passwordOld":passwordOld,@"passwordNew":passwordNew};
    
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfModifyPassword(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfModifyPassword(error);
        });
    }];
    
}


#pragma mark -- 佣金明细 接口
-(void)GetCommissionByBusinessUserIdWithpageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize businessUserId:(NSString *)businessUserId status:(NSString *)status{
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@/GetCommissionByBusinessUserId",BASE_URL,RELATIVE_PATH];
    
    NSDictionary * parameters = @{@"pageIndex":pageIndex,@"pageSize":pageSize,@"businessUserId":businessUserId,@"status":status};
    
    [self.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfGetCommissionByBusinessUserId(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfGetCommissionByBusinessUserId(error);
        });
    }];
}

#pragma mark -- 我的佣金 接口
-(void)GetCommissionAmountWithbusinessUserId:(NSString *)businessUserId status:(NSString *)status{
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@/GetCommissionAmount",BASE_URL,RELATIVE_PATH];
    
    NSDictionary * parameters = @{@"businessUserId":businessUserId,@"status":status};
    
    [self.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfGetCommissionAmount(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfGetCommissionAmount(error);
        });
    }];
}


#pragma mark -- ModifyBusinessInfo 修改用户信息 接口
-(void)ModifyBusinessInfoWithId:(NSString *)Id nickName:(NSString *)nickName areaCode:(NSString *)areaCode photo:(NSString *)photo{
    NSString * urlStr = [ NSString  stringWithFormat:@"%@%@/ModifyBusinessInfo",BASE_URL,RELATIVE_PATH];
    NSDictionary * parameters  = @{
                                   @"Id":Id,
                                   @"nickName":nickName,
                                   @"areaCode":areaCode,
                                   @"photo":photo
                                   };
    
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfModifyBusinessInfo(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfModifyBusinessInfo(error);
        });
    }];
    
       
}


#pragma mark -- ChangeMobilePhone 更换手机号码 接口
-(void)ChangeMobilePhoneWithId:(NSString *)Id smsCode:(NSString *)smsCode mobilePhoneNew:(NSString *)mobilePhoneNew smsCodeNew:(NSString *)smsCodeNew{
    NSString * urlStr = [NSString  stringWithFormat:@"%@/%@/ChangeMobilePhone",BASE_URL,RELATIVE_PATH ];
    
    NSDictionary * parameters = @{@"Id":Id,@"smsCode":smsCode,@"mobilePhoneNew":mobilePhoneNew,@"smsCodeNew":smsCodeNew};
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfChangeMobilePhone(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfChangeMobilePhone(error);
        });
    }];
   
}


#pragma mark -- GetSmsCode 获取手机验证码 接口
-(void)GetSmsCodeWithmobilePhone:(NSString *)mobilePhone isSystem:(NSString *)isSystem{
    //获得电话 调用短信接口 发送   得到验证码
    NSString  * urlStr = [NSString stringWithFormat:@"%@%@/GetSmsCode",BASE_URL ,RELATIVE_PATH];
    /**
     *  参数
     */
    NSDictionary * parameters = @{@"mobilePhone":mobilePhone , @"isSystem":isSystem};
    
    [self.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfGetSmsCode(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfGetSmsCode(error);
        });
    }];
}

#pragma mark -- RegisterBusinessUser 注册帐号 接口
-(void)RegisterBusinessUserWithmobilePhone:(NSString *)mobilePhone password:(NSString *)password smsCode:(NSString *)smsCode{
    /**
     *  url地址
     */
    NSString  * urlStr = [NSString stringWithFormat:@"%@%@/RegisterBusinessUser",BASE_URL,RELATIVE_PATH];
    /**
     *  参数
     */
    NSDictionary * parameters = @{@"mobilePhone":mobilePhone,@"password":password,@"smsCode":smsCode};
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfRegisterBusinessUser(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"注册接口:>>>>>>%@",error);
            self.passErrorOfRegisterBusinessUser(error);
        });
    }];
    
    
    
}

#pragma mark -- LoginValidate 登录 接口
-(void)LoginValidateWithmobilePhone:(NSString *)mobilePhone password:(NSString *)password{
    //接口地址
    NSString  * urlStr = [NSString stringWithFormat:@"%@%@/LoginValidate",BASE_URL,RELATIVE_PATH];
    //传递参数
    NSDictionary * parameters =@{@"mobilePhone":mobilePhone,@"password": password};
    
    [self.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfLoginValidate(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfLoginValidate(error);
        });
    }];
}


#pragma mark -- ResetPassword 忘记密码 接口
-(void)ResetPasswordWithmobilePhone:(NSString *)mobilePhone smsCode:(NSString *)smsCode passwordNew:(NSString *)passwordNew{
    /**
     *  url地址
     */
    NSString  * urlStr = [NSString stringWithFormat:@"%@%@/ResetPassword",BASE_URL,RELATIVE_PATH];
    /**
     *  参数
     */
    NSDictionary * parameters = @{@"mobilePhone":mobilePhone,@"smsCode":smsCode,@"passwordnew":passwordNew};
    
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfResetPassword(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfResetPassword(error);
        });
    }];
    
    
}


#pragma mark -- RealNameAuth 实名认证 接口
/**
 *  RealNameAuth 实名认证
 *
 *  @param Id                Id（必填）
 *  @param name              姓名（必填）
 *  @param idCardNo          身份证号（必填）
 *  @param qCertificateNo    资格证号（必填）
 *  @param bankNo            银行卡号（必填）
 *  @param idCardNoPhoto1    身份证正面文件Id（必填）
 *  @param idCardNoPhoto2    身份证背面文件Id（必填）
 *  @param qCertificatePhoto 资格证内页文件Id（必填）
 */
-(void)RealNameAuthWithId:(NSString *)Id name:(NSString *)name idCardNo:(NSString *)idCardNo qCertificateNo:(NSString *)qCertificateNo bankNo:(NSString *)bankNo idCardNoPhoto1:(NSString *)idCardNoPhoto1 idCardNoPhoto2:(NSString *)idCardNoPhoto2 qCertificatePhoto:(NSString *)qCertificatePhoto{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/RealNameAuth",BASE_URL,RELATIVE_PATH]];
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    
    NSDictionary *parameters = @{
                                     @"Id": Id,
                                     @"name": name,
                                     @"idCardNo": idCardNo,
                                     @"qCertificateNo": qCertificateNo,
                                     @"bankNo": bankNo,
                                     @"idCardNoPhoto1":idCardNoPhoto1,
                                     @"idCardNoPhoto2": idCardNoPhoto2,
                                     @"qCertificatePhoto": qCertificatePhoto
                                     };
    
    
    [self.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfRealNameAuth(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfRealNameAuth(error);
        });
    }];
    
}


#pragma mark -- GetArea 获取所有区域(3级) 接口
-(void)GetArea{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/GetArea",BASE_URL,RELATIVE_PATH];
    
    [self.sessionManager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passResponseObjectOfGetArea(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passErrorOfGetArea(error);
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
