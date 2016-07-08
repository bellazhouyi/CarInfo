//
//  InsureDataModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InsureHolderWithInsuredModel;

/**
 *保单
 */
@interface InsureDataModel : NSObject


@property (nonatomic , copy) NSString * cntr_id;

@property (nonatomic , copy) NSString * subcomp_code;

@property (nonatomic , copy) NSString * cd_date;

@property (nonatomic , copy) NSString * sx_date;

@property (nonatomic , copy) NSString * zz_date;

@property (nonatomic , copy) NSString * jqxs;

@property (nonatomic , copy) NSString * syxs;

@property (nonatomic , copy) NSString * status;

@property (nonatomic , copy) NSString * Createtime;

@property (nonatomic , copy) NSString * qt;

@property (nonatomic , copy) NSString * zf_name;

@property (nonatomic , copy) NSString * opr_no;

@property (nonatomic , copy) NSString * opr_name;

@property (nonatomic ,copy) NSString * sdr_name;

@property (nonatomic , copy) NSString * sdr_mobile;

@property (nonatomic , copy) NSString * sdr_addr;

@property (nonatomic , copy) NSString * ps_way;

@property (nonatomic , copy) NSString * ps_way_name;

@property (nonatomic , copy)  NSString * StatusName;

@property (nonatomic , copy) NSString * PS_Comp;

@property (nonatomic , copy) NSString * Express_No;

@property (nonatomic , copy) NSString * Jqxyyj_imgUrl;

@property (nonatomic , copy) NSString * Syxyyj_imgUrl;

@property(nonatomic,strong) NSString *pre_premium;

@property (nonatomic , strong) InsureHolderWithInsuredModel * Cntr_Holder;

@property (nonatomic , strong) InsureHolderWithInsuredModel * Cntr_Insured;





@end
