//
//  ConfirmNoteTableViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  刷新tableView
 */
typedef void(^refreshTableView)();



@class PriceDetail;
@interface ConfirmNoteTableViewController : UITableViewController

/**
 *  存储保险公司名称
 */
@property(nonatomic,strong) NSString *companyName;
/**
 *  声明刷新tableView的block
 */
@property(nonatomic,strong) refreshTableView refreshTableViewBlock;



/**
 *  接收来自保单详情传过来的PriceDetail实例
 */
@property(nonatomic,strong) PriceDetail *priceDetail;


/**
 *  总价
 */
@property(nonatomic,assign) CGFloat totalPrice;

/**
 *  carInfo
 */
@property(nonatomic,strong) CarInfo *carInfo;


/**
 *  二维码地址
 */
@property(nonatomic,strong) NSString *erWeiMaAddress;


/**
 *  关于报价情况的数组
 */
@property(nonatomic,strong) NSArray *arrayAboutInsuranceInfo;


@end
