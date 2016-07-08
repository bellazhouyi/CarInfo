//
//  HTTPManagerOfMine.h
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/15.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -- 根据ID获取B端用户信息 接口的block定义
/**
 *  成功获得数据
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetBusinessUserById)(id responseObject);

/**
 *  失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetBusinessUserById)(NSError *error);

#pragma mark -- 修改密码 接口的block定义
/**
 *  修改密码 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfModifyPassword)(id responseObject);

/**
 *  修改密码  失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfModifyPassword)(NSError *error);


#pragma mark -- 佣金明细 接口的block定义
/**
 *  得到数据
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetCommissionByBusinessUserId)(id responseObject);

/**
 *  失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetCommissionByBusinessUserId)(NSError *error);

#pragma mark -- 我的佣金明细 的block定义
/**
 *  成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetCommissionAmount)(id responseObject);

/**
 *  失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetCommissionAmount)(NSError *error);

#pragma mark -- ModifyBusinessInfo 修改用户信息 接口
/**
 *  ModifyBusinessInfo 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfModifyBusinessInfo)(id responseObject);

/**
 *  ModifyBusinessInfo 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfModifyBusinessInfo)(NSError *error);

#pragma mark -- ChangeMobilePhone 接口-更换手机号码
/**
 *  ChangeMobilePhone 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfChangeMobilePhone)(id responseObject);

/**
 *  ChangeMobilePhone 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfChangeMobilePhone)(NSError *error);

#pragma mark -- GetSmsCode 获取手机验证码 接口的block定义
/**
 *  GetSmsCode 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetSmsCode)(id responseObject);

/**
 *  GetSmsCode 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetSmsCode)(NSError *error);

#pragma mark -- RegisterBusinessUser 注册账号 接口
/**
 *  RegisterBusinessUser 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfRegisterBusinessUser)(id responseObject);

/**
 *  RegisterBusinessUser 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfRegisterBusinessUser)(NSError *error);

#pragma mark -- LoginValidate 登录接口
/**
 *  LoginValidate 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfLoginValidate)(id responseObject);

/**
 *  LoginValidate 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfLoginValidate)(NSError *error);

#pragma mark -- ResetPassword 忘记密码 接口
/**
 *  ResetPassword 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfResetPassword)(id responseObject);

/**
 *  ResetPassword 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfResetPassword)(NSError *error);

#pragma mark -- RealNameAuth 实名认证 接口的block定义
/**
 *  RealNameAuth 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfRealNameAuth)(id responseObject);

/**
 *  RealNameAuth 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfRealNameAuth)(NSError *error);

#pragma mark -- GetArea 获取所有区域 接口的block定义
/**
 *  GetArea 成功
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passResponseObjectOfGetArea)(id responseObject);

/**
 *  GetArea 失败
 *
 *  @param error <#error description#>
 */
typedef void(^passErrorOfGetArea)(NSError *error);


@interface HTTPManagerOfMine : NSObject


#pragma mark -- 单例
/**
 *  单例
 *
 *  @return <#return value description#>
 */
+(HTTPManagerOfMine *)sharedHTTPManagerOfMine;



#pragma mark -- 属性
#pragma mark -- 根据ID获取B端用户信息
@property(nonatomic,copy) passResponseObjectOfGetBusinessUserById passResponseObjectOfGetBusinessUserById;

@property(nonatomic,copy) passErrorOfGetBusinessUserById passErrorOfGetBusinessUserById;

#pragma mark -- 修改密码 接口
@property(nonatomic,copy) passResponseObjectOfModifyPassword passResponseObjectOfModifyPassword;

@property(nonatomic,copy) passErrorOfModifyPassword passErrorOfModifyPassword;

#pragma mark -- 佣金明细 接口
@property(nonatomic,copy) passResponseObjectOfGetCommissionByBusinessUserId passResponseObjectOfGetCommissionByBusinessUserId;

@property(nonatomic,copy) passErrorOfGetCommissionByBusinessUserId passErrorOfGetCommissionByBusinessUserId;

#pragma mark -- 我的佣金 接口
@property(nonatomic,copy) passResponseObjectOfGetCommissionAmount passResponseObjectOfGetCommissionAmount;

@property(nonatomic,copy) passErrorOfGetCommissionAmount passErrorOfGetCommissionAmount;


#pragma mark -- ModifyBusinessInfo 修改用户信息 接口
@property(nonatomic,copy) passResponseObjectOfModifyBusinessInfo passResponseObjectOfModifyBusinessInfo;

@property(nonatomic,copy) passErrorOfModifyBusinessInfo passErrorOfModifyBusinessInfo;


#pragma mark -- ChangeMobilePhone 更换手机号码 接口
@property(nonatomic,copy) passResponseObjectOfChangeMobilePhone passResponseObjectOfChangeMobilePhone;

@property(nonatomic,copy) passErrorOfChangeMobilePhone passErrorOfChangeMobilePhone;


#pragma mark -- GetSmsCode 获取手机验证码 接口
@property(nonatomic,copy) passResponseObjectOfGetSmsCode passResponseObjectOfGetSmsCode;

@property(nonatomic,copy) passErrorOfGetSmsCode passErrorOfGetSmsCode;


#pragma mark -- RegisterBusinessUser 注册账号 接口
@property(nonatomic,copy) passResponseObjectOfRegisterBusinessUser passResponseObjectOfRegisterBusinessUser;

@property(nonatomic,copy) passErrorOfRegisterBusinessUser passErrorOfRegisterBusinessUser;



#pragma mark -- LoginValidate 登录接口
@property(nonatomic,copy) passResponseObjectOfLoginValidate passResponseObjectOfLoginValidate;

@property(nonatomic,copy) passErrorOfLoginValidate passErrorOfLoginValidate;


#pragma mark -- ResetPassword 忘记密码 接口
@property(nonatomic,copy) passResponseObjectOfResetPassword passResponseObjectOfResetPassword;

@property(nonatomic,copy) passErrorOfResetPassword passErrorOfResetPassword;


#pragma mark -- RealNameAuth 实名认证 接口
@property(nonatomic,copy) passResponseObjectOfRealNameAuth passResponseObjectOfRealNameAuth;

@property(nonatomic,copy) passErrorOfRealNameAuth passErrorOfRealNameAuth;


#pragma mark -- GetArea 获取所有区域 接口
@property(nonatomic,copy) passResponseObjectOfGetArea passResponseObjectOfGetArea;

@property(nonatomic,copy) passErrorOfGetArea passErrorOfGetArea;











#pragma mark -- 方法
#pragma mark -- GetBusinessUserById 根据ID获取B端用户信息 接口
-(void)GetBusinessUserByIdWithId:(NSString *)Id;


#pragma mark -- ModifyPassword 修改密码 接口
/**
 *  <#Description#>
 *
 *  @param Id          <#Id description#>
 *  @param passwordOld <#passwordOld description#>
 *  @param passwordNew <#passwordNew description#>
 */
-(void)ModifyPasswordWithId:(NSString *)Id passwordOld:(NSString *)passwordOld passwordNew:(NSString *)passwordNew;


#pragma mark -- GetCommissionByBusinessUserId 佣金明细 接口
/**
 *  佣金明细 接口
 *
 *  @param pageIndex      页码
 *  @param pageSize       每页大小
 *  @param businessUserId B端用户id（必填）
 *  @param status         状态,1--已核保(可以申请提现),2--已申请提现(正在审核),3--已提现(审核完成)（必填）
 */
-(void)GetCommissionByBusinessUserIdWithpageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize businessUserId:(NSString *)businessUserId status:(NSString *)status;


#pragma mark -- GetCommissionAmount 我的佣金 接口
/**
 *  我的佣金 接口
 *
 *  @param businessUserId B端用户Id（必填）
 *  @param status         1--已核保(可以申请提现),2--已申请提现(正在审核),3--已提现(审核完成)（必填）
 */
-(void)GetCommissionAmountWithbusinessUserId:(NSString *)businessUserId status:(NSString *)status;


#pragma mark -- ModifyBusinessInfo 修改用户信息 接口
/**
 *  ModifyBusinessInfo 接口
 *
 *  @param Id       Id(必填)
 *  @param nickName 昵称(可填)
 *  @param areaCode 区域code(可填)
 *  @param photo    头像文件Id(可填)
 */
-(void)ModifyBusinessInfoWithId:(NSString *)Id nickName:(NSString *)nickName areaCode:(NSString *)areaCode photo:(NSString *)photo;


#pragma mark -- ChangeMobilePhone 更换手机号码 接口
/**
 *  ChangeMobilePhone 接口
 *
 *  @param Id             用户Id（必填）
 *  @param smsCode        短信验证码（必填）
 *  @param mobilePhoneNew 新手机号码（必填）
 *  @param smsCodeNew     新手机好验证码(必填)
 */
-(void)ChangeMobilePhoneWithId:(NSString *)Id smsCode:(NSString *)smsCode mobilePhoneNew:(NSString *)mobilePhoneNew smsCodeNew:(NSString *)smsCodeNew;



#pragma mark -- GetSmsCode 获取手机验证码 接口
/**
 *  GetSmsCode 接口
 *
 *  @param mobilePhone 手机号(必填)
 *  @param isSystem    是否系统注册手机号(true—系统，false—任意)
 */
-(void)GetSmsCodeWithmobilePhone:(NSString *)mobilePhone isSystem:(NSString *)isSystem;


#pragma mark -- RegisterBusinessUser 注册帐号 接口
/**
 *  RegisterBusinessUser 注册账号 接口
 *
 *  @param mobilePhone 手机号(必填)
 *  @param password    密码（必填）
 *  @param smsCode     验证码（必填）
 */
-(void)RegisterBusinessUserWithmobilePhone:(NSString *)mobilePhone password:(NSString *)password smsCode:(NSString *)smsCode;


#pragma mark -- LoginValidate 登录 接口
/**
 *  LoginValidate 接口
 *
 *  @param mobilePhone 手机号(必填)
 *  @param password    密码(必填)
 */
-(void)LoginValidateWithmobilePhone:(NSString *)mobilePhone password:(NSString *)password;


#pragma mark -- ResetPassword 忘记密码 接口
/**
 *  ResetPassword忘记密码 接口
 *
 *  @param mobilePhone 手机号码（必填）
 *  @param smsCode     短信验证码（必填）
 *  @param passwordNew 新密码（必填）
 */
-(void)ResetPasswordWithmobilePhone:(NSString *)mobilePhone smsCode:(NSString *)smsCode passwordNew:(NSString *)passwordNew;


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
-(void)RealNameAuthWithId:(NSString *)Id name:(NSString *)name idCardNo:(NSString *)idCardNo qCertificateNo:(NSString *)qCertificateNo bankNo:(NSString *)bankNo idCardNoPhoto1:(NSString *)idCardNoPhoto1 idCardNoPhoto2:(NSString *)idCardNoPhoto2 qCertificatePhoto:(NSString *)qCertificatePhoto;


#pragma mark -- GetArea 获取所有区域(3级) 接口
-(void)GetArea;

@end
