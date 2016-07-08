//
//  CreatePolicy.h
//  Template_Joker
//
//  Created by Bella on 16/2/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatePolicy : NSObject


/**
 *  B端用户Id(必填)
 */
@property(nonatomic,strong) NSString *businessUserId;

/**
 *  车牌号(必填)
 */
@property(nonatomic,strong) NSString *cph_no;


/**
 *  车架号(必填)
 */
@property(nonatomic,strong) NSString *cjh_no;

/**
 *  保险公司代码(必填)
 */
@property(nonatomic,strong) NSString *company_code;


/**
 *  保费总金额(必填)
 */
@property(nonatomic,strong) NSString *amount;


/**
 *  返回比价的保险Id(必填)
 */
@property(nonatomic,strong) NSString *policyPriceId;


/**
 *  被保人即车主(bool)
 */
@property(nonatomic,assign) BOOL insurediscz;

/**
 *  被保人姓名
 */
@property(nonatomic,strong) NSString *insured_name;


/**
 *  被保人电话
 */
@property(nonatomic,strong) NSString *insured_phone;


/**
 *  被保人身份证号码
 */
@property(nonatomic,strong) NSString *insured_idno;


/**
 *  被保人身份证正面文件Id
 */
@property(nonatomic,strong) NSString *insured_sf1_id;

/**
 *  被保人身份证被面文件Id
 */
@property(nonatomic,strong) NSString *insured_sf2_id;

/**
 *  被保人即投保人(bool)
 */
@property(nonatomic,assign) BOOL insuredisholder;

/**
 *  投保人名称
 */
@property(nonatomic,strong) NSString *holder_name;

/**
 *  投保人电话
 */
@property(nonatomic,strong) NSString *holder_phone;

/**
 *  投保人身份证号码
 */
@property(nonatomic,strong) NSString *holder_idno;

/**
 *  投保人身份证正面Id
 */
@property(nonatomic,strong) NSString *holder_sf1_id;

/**
 *  投保人身份证背面Id
 */
@property(nonatomic,strong) NSString *holder_sf2_id;

/**
 *  交强险开始日期(必填)
 */
@property(nonatomic,strong) NSString *jqxbegintime;


/**
 *  交强险结束日期
 */
@property(nonatomic,strong) NSString *jqxendtime;

/**
 *  商业险开始日期(必填)
 */
@property(nonatomic,strong) NSString *syxbegintime;

/**
 *  商业险结束日期
 */
@property(nonatomic,strong) NSString *syxendtime;


/**
 *  品牌型号
 */
@property(nonatomic,strong) NSString *xh_code;

/**
 *  发动机号
 */
@property(nonatomic,strong) NSString *fdj_no;

/**
 *  购买日期/注册日期
 */
@property(nonatomic,strong) NSString *buy_date;

/**
 *  车主名称
 */
@property(nonatomic,strong) NSString *cz_name;

/**
 *  车主身份证号码
 */
@property(nonatomic,strong) NSString *Idcard_No;

/**
 * 车主身份证正面id
 */
@property(nonatomic,strong) NSString *Sf1_Id;

/**
 * 车主身份证背面id
 */
@property(nonatomic,strong) NSString *SF2_Id;

/**
 * 行驶证号码
 */
@property(nonatomic,strong) NSString *xsz_xs_code;

/**
 *  行驶证正面id
 */
@property(nonatomic,strong) NSString *xs1_path;

/**
 *  行驶证背面id
 */
@property(nonatomic,strong) NSString *xs2_path;

/**
 *  配送方式(录入中文,现领，还是快递等)
 */
@property(nonatomic,strong) NSString *ps_way;

/**
 *  收货人名称
 */
@property(nonatomic,strong) NSString *sdr_name;

/**
 *  收货人电话
 */
@property(nonatomic,strong) NSString *sdr_mobile;

/**
 *  收货人地址
 */
@property(nonatomic,strong) NSString *sdr_addr;


@end
