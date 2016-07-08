//
//  DetailsViewController.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "JJBaseController.h"


/**
 *  本地支付后,需要用这两个参数查询支付状态
 *
 *  @param cntr_id 保单号
 *  @param payType 支付方式
 */
typedef void(^passPayStatusAfterPay)(NSString *cntr_id,NSString *payType);


@class  DetailSectionModel,InsureFooterView,PolicyListsModel;

@interface DetailsViewController : JJBaseController

/**
 *  header 的data
 */
@property (nonatomic , strong) NSArray * data;

@property (nonatomic , copy)  NSString * buttonTitle;

@property (nonatomic , assign ) BOOL  showHead;

@property (nonatomic , assign) BOOL  showFooter;

@property (nonatomic , strong) NSDictionary * cntr_ClInfoParameters;

@property (nonatomic , strong) PolicyListsModel * policyListModel;


#pragma mark -- 待审核,审核中,审核失败,接口
/**
 *  <#Description#>
 *
 *  @param policy   <#policy description#>
 *  @param contents <#contents description#>
 */
-(void) detailsViewWithpolicy:(PolicyListsModel *)policy contents:(NSDictionary * )contents andStatus:(NSString *)status;


/**
*   待投保和已投保
 *  @param parameters 参数
 *  @param strUrl     url
 *  @param session    afn
 */
-(void) detailsViewInsuredWithStayInsureParameters:(NSDictionary * ) parameters strUrl:(NSString * ) strUrl session:(AFHTTPSessionManager * ) session contents:(NSDictionary * )  contents;



#pragma mark -- 支付状态
@property(nonatomic,copy) passPayStatusAfterPay passPayStatusAfterPay;


@end
