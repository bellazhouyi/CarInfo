//
//  JJInputView.m
//  MTest_Joker
//
//  Created by pengshuai on 15/7/23.
//  Copyright (c) 2015年 Joker. All rights reserved.
//


#define kAnimateDuration 0.25f

#import "JJInputView.h"

@interface JJInputView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (strong,nonatomic) CallbackResultBlock callbackResultBlock;

@end

@implementation JJInputView

#pragma mark -
#pragma mark - 初始化
/**
 *  创建InputView
 *
 *  @param title 标题
 *
 *  @return JJInputView
 */
-(instancetype)initWithTitle:(NSString*)title{

    return [self initWithTitle:title text:nil];
}

/**
 *  创建InputView
 *
 *  @param title 标题
 *  @param title 内容
 *
 *  @return JJInputView
 */
-(instancetype)initWithTitle:(NSString*)title text:(NSString*)text{

    self = [[[NSBundle mainBundle] loadNibNamed:@"JJInputView" owner:nil options:nil] lastObject];
    if (self == nil) {
        return nil;
    }
    
    [self initView:title text:text];
    return self;
}


-(instancetype)init{
    
    return [self initWithTitle:nil];
}

/**
 *  初始化view
 */
-(void)initView:(NSString*)title text:(NSString*)text{
    
    self.labelTitle.text = title;
    self.textView.text = text;
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [UIColor colorWithRed:200.0/255.0
                                                      green:200.0/255.0
                                                       blue:200.0/255.0
                                                      alpha:1.0f].CGColor;
    
    self.textView.layer.borderWidth = 0.5f;
    self.textView.inputAccessoryView = self.containerView;
    
    //设置背景模糊
    self.blurRadius = 30.0f;
    self.dynamic = NO;
    self.tintColor = [UIColor blackColor];
    
    //点击模糊区域关闭当前view
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleRecognizer];
    
    //滚动到底部
    [self.textView scrollRectToVisible:CGRectMake(0, self.textView.contentSize.height-15, self.textView.contentSize.width, 10) animated:YES];
}

#pragma mark -
#pragma mark - UITextViewDelegate
/**
 *  处理textview内容发生改变
 *  当textview为空时,确定按钮不可用
 *
 *  @param textView <#textView description#>
 */
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.buttonConfirm.enabled = YES;
    }else{
        self.buttonConfirm.enabled = NO;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.buttonConfirm.enabled = YES;
    }else{
        self.buttonConfirm.enabled = NO;
    }
}


#pragma mark -
#pragma mark - Action
/**
 *  移除
 */
- (void)dismiss{
    
    [self.textView resignFirstResponder];
    self.alpha = 1.0f;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

/**
 *  取消
 *
 *  @param sender <#sender description#>
 */
-(IBAction)onCancelAction:(id)sender{
    [self dismiss];
}

/**
 *  确定
 *
 *  @param sender <#sender description#>
 */
-(IBAction)onConfirmAction:(id)sender{
    self.callbackResultBlock(self.textView.text);
    [self dismiss];
}

/**
 *  显示输入框
 *
 *  @param block 回调Block
 */
-(void)showInputViewWithCallback:(CallbackResultBlock)block{
    for (UIView *subview in [[UIApplication sharedApplication].delegate window].subviews) {
        if ([subview isEqual:self]) {
            [self removeFromSuperview];
        }
    }
    self.callbackResultBlock = block;
    [self.textView becomeFirstResponder];
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.alpha = 0.0f;
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 1.0f;
    }];
}

@end

















