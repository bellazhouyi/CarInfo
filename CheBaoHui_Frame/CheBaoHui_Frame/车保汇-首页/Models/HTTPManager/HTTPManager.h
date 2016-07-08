//
//  HTTPManager.h
//  Template_Joker
//
//  Created by Bella on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  表示返回的数据类型
 */
typedef NS_ENUM(NSUInteger,responseStyle) {
    /**
     *  <#Description#>
     */
    DATA,
    /**
     *  <#Description#>
     */
    JSON,
    /**
     *  <#Description#>
     */
    XML
};


typedef NS_ENUM(NSUInteger,bodyStyle) {
    stringStyle,
    JSONStyle
};


/**
 *  传递解析出来的数组
 *
 *  @param array 数组，包含的是PriceDetail实例
 */
typedef void(^passPriceDetailArray)(NSArray *array);


/**
 *  传递解析出来的CarInfo实例
 *
 *  @param carInfo <#carInfo description#>
 */
typedef void(^passCarInfoInstance)(CarInfo *carInfo);


/**
 *  用于传递核保成功后，返回的参数
 *
 *  @param cntr_id 保单号
 */
typedef void(^passCntr_id)(NSString *cntr_id);


/**
 *  用于传递支付生成二维码成功后，返回的参数
 *
 *  @param erWeiMaURL 二维码URL参数
 */
typedef void(^passErWeiMaURL)(NSString *erWeiMaURL);

/**
 *  传递解析出来的所有区域
 *
 *  @param allAreaDict <#allAreaDict description#>
 */
typedef void(^passAllArea)(NSArray *allAreaDict);


/**
 *  传递支付接口返回随机的预支付单号等信息
 *
 *  @param array 预支付订单信息数组
 */
typedef void(^passPrepayID)(NSDictionary *dict);


/**
 *  传递后台银联支付接口传回来的html数据,跳转网页支付
 *
 *  @param array <#array description#>
 */
typedef void(^passHtmlData)(NSString *url);


/**
 *  传递 本地支付 的一个支付状态
 *
 *  @param payStatus 支付状态信息
 */
typedef void(^passPayStatus)(NSString *payStatus);

/**
 *  传递接口返回的data是空
 */
typedef void(^passNullMsg_VehicleInfo)();

typedef void(^passNullMsg_CreateVehicle)();

typedef void(^passNullMsg_GetPolicyPrice)(NSString *msg);

typedef void(^passNullMsg_CreatePolicy)();

typedef void(^passNullMsg_PayPolicy)(id responseObject);

typedef void(^passNullMsg_GetPayStatus)();

typedef void(^passNullMsg_GetCntr_ClInfo)();

/**
 *  服务器失败
 */
typedef void(^passError)();

/**
 *  核保接口 服务器内部错误 500
 */
typedef void(^passErrorCreatePolicy)();


/**
 *  添加车辆信息  服务器内部错误
 */
typedef void(^passErrorCreateVehicleInfo)();


/**
 *  扫码支付接口 内部服务器错误
 */
typedef void(^passErrorPayPolicy)();

@class CarInfo;

@interface HTTPManager : NSObject



/**
 *  声明block
 */
@property(nonatomic,copy) passPriceDetailArray passValue;

@property(nonatomic,copy) passCarInfoInstance passCarInfoInstance;

@property(nonatomic,copy) passCntr_id passCntr_id;

@property(nonatomic,copy) passErWeiMaURL passErWeiMaURL;

@property(nonatomic,copy) passAllArea passAllArea;

@property(nonatomic,copy) passPrepayID passPrepayid;


@property(nonatomic
          ,copy) passPayStatus passPayStatus;

 
@property(nonatomic,copy) passHtmlData passYinLianData;

@property(nonatomic,copy) passNullMsg_VehicleInfo passNullMsg_VehicleInfo;

@property(nonatomic,copy) passNullMsg_CreateVehicle passNullMsg_CreateVehicle;

@property(nonatomic,copy) passNullMsg_CreatePolicy passNullMsg_CreatePolicy;

@property(nonatomic,copy) passNullMsg_GetPayStatus passNullMsg_GetPayStatus;

@property(nonatomic,copy) passNullMsg_GetPolicyPrice passNullMsg_GetPolicyPrice;

@property(nonatomic,copy) passNullMsg_PayPolicy passNullMsg_PayPolicy;

@property(nonatomic,copy) passNullMsg_GetCntr_ClInfo passNullMsg_GetCntr_ClInfo;


@property(nonatomic,copy) passError passError;

@property(nonatomic,copy) passErrorCreatePolicy passErrorCreatePolicy;


@property(nonatomic,copy) passErrorCreateVehicleInfo passErrorCreateVehicleInfo;


@property(nonatomic,copy) passErrorPayPolicy passErrorPayPolicy;

+(HTTPManager *)sharedHTPPManager;



/**
 *  获取所有区域
 */
-(void)getAllArea;

/**
 *  根据车牌、车架号，查询车辆信息(查不出来的，由自己填写)
 *
 *  @param cph_no 车牌号
 *  @param cjh_no 车架号
 */
-(void)GetCntr_CIInfoWithcph_no:(NSString *)cph_no
                         cjh_no:(NSString *)cjh_no;


/**
 *  添加车辆信息
 *
 *  @param cph_no       车牌号(必填)
 *  @param cz_name      车主名称(必填)
 *  @param buy_date     注册日期(必填)
 *  @param xh_code      品牌型号(必填)
 *  @param fdj_no       发动机号(必填)
 *  @param cjh_no       车架号(必填)
 *  @param TransferTime 过户日期(可填)
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)addCarInfoWithcph_no:(NSString *)cph_no
                               cz_name:(NSString *)cz_name
                              buy_date:(NSString *)buy_date
                               xh_code:(NSString *)xh_code
                                fdj_no:(NSString *)fdj_no
                               cjh_no:(NSString *)cjh_no
                          TransferTime:(NSString *)TransferTime;




/**
 *  比价接口
 *
 *  @param cntr_id    保险单Id(必填)
 *  @param cz_name    车主(可填)
 *  @param cph_no
 *  @param cjh_no
 *  @param buy_date
 *  @param PolicyList
 */
/**
 *  比价接口
 *
 *  @param cz_name     车主(可填)
 *  @param cph_no      车牌号(必填)
 *  @param cjh_no      车架号(必填)
 *  @param buy_date    购买日期（行驶证注册日期）(必填)
 *  @param clssx       车辆损失险(录入1或者其它字符串)
 *  @param dszzrx      第三者责任险 1/0
 *  @param dszzrxValue 第三者责任险值
 *  @param qcdqx       全车盗抢险 1/0
 *  @param sjzrx       司机责任险 1/0
 *  @param sjzrxValue  司机责任险值
 *  @param ckzrx       乘客责任险 1/0
 *  @param ckzrxValue  乘客责任险值
 *  @param blpsx       玻璃破碎险 1/0
 *  @param blpsxValue  玻璃破碎险 (0--进口，1--国产)
 *  @param zrssx       自燃损失险 1/0
 *  @param zrssxValue  自燃损失险值(金额单位元)
 */
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





/**
 *  核保 接口
 *
 *  @param businessUserId  B端用户Id(必填)
 *  @param cntr_id         保单Id(必填)
 *  @param company_code    保险公司代码(必填)
 *  @param amount          报费总金额(必填)
 *  @param policyPriceId   返回比价的保险Id(必填)
 *  @param insurediscz     被保人即车主(bool)
 *  @param insured_name    被保人姓名
 *  @param insured_phone   被保人电话
 *  @param insured_idno    被保人身份证号码
 *  @param insured_sf1_id  被保人身份证正面文件Id
 *  @param insured_sf2_id  被保人身份证被面文件Id
 *  @param insuredisholder 被保人即投保人(bool)
 *  @param holder_name     投保人名称
 *  @param holder_phone    投保人电话
 *  @param holder_idno     投保人身份证号码
 *  @param holder_sf1_id   投保人身份证正面Id
 *  @param holder_sf2_id   投保人身份证背面Id
 *  @param jqxbegintime    交强险开始日期(必填)
 *  @param jqxendtime      交强险结束日期
 *  @param syxbegintime    商业险开始日期(必填)
 *  @param syxendtime      商业险介绍日期
 *  @param cph_no          车牌号
 *  @param cjh_no          车架号
 *  @param xh_code         品牌型号
 *  @param fdj_no          发动机号
 *  @param buy_date        购买日期/注册日期
 *  @param cz_name         车主名称
 *  @param Idcard_No       车主身份证号码
 *  @param Sf1_Id          车主身份证正面Id
 *  @param SF2_Id          车主身份证背面Id
 *  @param xsz_xs_code     行驶证号码
 *  @param xs1_path        行驶证正面Id
 *  @param xs2_path        背面Id
 *  @param ps_way          配送方式(录入中文 现领，快递等)
 *  @param sdr_name        收货人名称
 *  @param sdr_mobile      收货人电话
 *  @param sdr_addr        收货人地址
 */
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
                                        sdr_addr:(NSString *)sdr_addr;





/**
 *  刷卡、微信、支付宝支付
 *
 *  @param ps_way      (配送方式)(now现领 ，behalf带领，send快递)
 *  @param sdr_name   (收货人)
 *  @param sdr_mobile (收货人手机号)
 *  @param sdr_addr   (收货人地址)
 *  @param cntr_id    (保单号)必填
 *  @param amount     (金额)必填
 *  @param paytype    (支付方式)必填(wechat,alipay,cash)
 *  @param cardno     (刷卡单号，支付方式为cash时必填)
 */
-(void)payInsurancePriceWithps_way:(NSString *)ps_way
                          sdr_name:(NSString *)sdr_name
                        sdr_mobile:(NSString *)sdr_mobile
                          sdr_addr:(NSString *)sdr_addr
                           cntr_id:(NSString *)cntr_id
                            amount:(CGFloat)amount
                           paytype:(NSString *)paytype
                            cardno:(NSString *)cardno
                       companycode:(NSString *)companycode;




/**
 *  查询本地支付状态
 *
 *  @param cntr_id 保单号
 *  @param payType 支付方式
 */
-(void)getPayStatusWithcntr_id:(NSString *)cntr_id payType:(NSString *)payType;






@end
