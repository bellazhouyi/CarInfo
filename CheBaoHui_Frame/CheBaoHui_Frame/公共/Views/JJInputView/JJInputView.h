//
//  JJInputView.h
//  MTest_Joker
//
//  Created by pengshuai on 15/7/23.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView.h>

/**
 *  JJInputView 回调Block
 *
 *  @param text textview内容
 */
typedef void (^CallbackResultBlock)(NSString *text);

/**
 *  内容输入view(背景模糊)
 */
@interface JJInputView : FXBlurView

/**
 *  创建InputView
 *
 *  @param title 标题
 *
 *  @return JJInputView
 */
-(instancetype)initWithTitle:(NSString*)title;

/**
 *  创建InputView
 *
 *  @param title 标题
 *  @param title 内容
 *
 *  @return JJInputView
 */
-(instancetype)initWithTitle:(NSString*)title text:(NSString*)text;

/**
 *  显示输入框
 *
 *  @param block 回调Block
 */
- (void)showInputViewWithCallback:(CallbackResultBlock)block;


@end
