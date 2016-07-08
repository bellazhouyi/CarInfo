//
//  JJBaseController.h
//  Template_Joker
//
//  Created by pengshuai on 15/6/8.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"


@interface JJBaseController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,strong) UIScrollView *emptyDataScrollView;


#pragma mark -
#pragma mrak - 关闭系统键盘
/**
 *  关闭键盘
 */
- (IBAction)hideKeyBoard;

/**
 *  重新加载数据[重载该方法,实现重新加载数据]
 */
-(void)reloadData;

#pragma mark -
#pragma mark - 提示语
/**
 *  检查是否有数据
 *
 *  @param dataArray 数据Array
 */
-(void)checkData:(NSArray*)dataArray;
/**
 *  显示失败原因
 *
 *  @param messageType 类型
 *  @param message     错误描述
 */
-(void)showFailureMessage:(MessageStatus)messageStatus message:(NSString*)message;
#pragma mark -
#pragma mark - 空数据处理
/**
 *  空数据时数据提示
 *
 *  @return <#return value description#>
 */
-(UIColor*)backgroundColorForEmptyData;

/**
 *  显示没有数据-图标
 */
-(UIImage*)imageEmptyData;
/**
 *  显示没有数据-标题
 */
-(NSAttributedString*)titleEmptyData;

/**
 *  显示没有数据-描述
 */
-(NSAttributedString*)descriptionEmptyData;

#pragma mark -
#pragma mark - HUD
-(void)hideHUD;
-(void)showLoadingHUD:(NSString*)message;
//  message 内容  hideTime  隐藏时间
-(void)showSuccessHUD:(NSString*)message  hideTime:(CGFloat) hideTime;
-(void)showFailureHUD:(NSString*)message  hideTime:(CGFloat) hideTime;
-(void)showWarningHUD:(NSString*)message  hideTime:(CGFloat) hideTime;
-(void)showToastHUD:(NSString*)message    hideTime:(CGFloat) hideTime ;

@end





