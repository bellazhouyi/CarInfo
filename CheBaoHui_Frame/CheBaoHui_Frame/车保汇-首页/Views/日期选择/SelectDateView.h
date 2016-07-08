//
//  SelectDateView.h
//  Template_Joker
//
//  Created by Bella on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  传递选中的日期
 *
 *  @param dateStr <#dateStr description#>
 */
typedef void(^passDate)(NSString *dateStr);

@interface SelectDateView : UIView

//声明block
@property(nonatomic,copy) passDate passDate;

//设置原始视图
-(void)setOriginalViewWithDateString:(NSString *)dateStr;

@end
