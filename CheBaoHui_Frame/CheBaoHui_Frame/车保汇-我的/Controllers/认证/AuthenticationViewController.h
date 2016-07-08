//
//  AuthenticationViewController.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KevinBaseController.h"
@class  DataModel;

/**
 *  实名认证view
 */
@interface AuthenticationViewController : KevinBaseController

/**
 *  接收data
 */
@property (nonatomic ,strong) DataModel *  data;


@end
