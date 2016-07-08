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
typedef void(^passMoney)(NSString *money,NSString *danwei);

@interface SelectMoneyView : UIView

//声明block
@property(nonatomic,copy) passMoney passMoney;

//设置原始视图
-(void)setOriginalViewWithNumberArray:(NSArray *)array withUnit:(NSString *)unit;

@end
