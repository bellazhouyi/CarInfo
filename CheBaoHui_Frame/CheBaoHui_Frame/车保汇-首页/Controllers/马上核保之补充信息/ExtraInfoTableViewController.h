//
//  ExtraInfoTableViewController.h
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraInfoTableViewController : UITableViewController
/**
 *  存储保险公司名称
 */
@property(nonatomic,strong) NSString *companyName;

/**
 *  存储报价总价
 */
@property(nonatomic,strong) NSString *totalPrice;


@end
