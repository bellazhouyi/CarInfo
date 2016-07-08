//
//  DefaultLoadMoreView.h
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

@interface DefaultLoadMoreView : UIView<RefreshViewDelegate>

/** 重置LoadMoreView */
-(void)resetLayoutSubViews;
/** 开始加载 */
-(void)beginRefreshing;
/** 结束加载 */
-(void)endRefreshing;
/** 松开加载(距离状态范围外) */
-(void)canEngageRefresh;
/** 上拉加载(距离状态范围内) */
-(void)didDisengageRefresh;
@end
