//
//  JJBaseController.m
//  Template_Joker
//
//  Created by pengshuai on 15/6/8.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "JJBaseController.h"
#import "HttpClient.h"

@interface JJBaseController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSString *messageTitle;
@property (nonatomic,assign) MessageStatus messageStatus;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation JJBaseController
-(void)dealloc{
    
    self.refreshControl.delegate = nil;
    self.emptyDataScrollView.delegate = nil;
    self.refreshControl = nil;
    self.emptyDataScrollView = nil;
    D_NSLog(@"【dealloc:%@】",self.class);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    D_NSLog(@"【viewWillAppear:%@】",self.class);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setEmptyDataScrollView:(UIScrollView *)emptyDataScrollView{
    _emptyDataScrollView = emptyDataScrollView;
    _emptyDataScrollView.emptyDataSetDelegate = self;
    _emptyDataScrollView.emptyDataSetSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageStatus = Message_Stauts_Normal;
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
}

-(void)reloadData{
    self.messageTitle = nil;
    self.messageStatus = Message_Stauts_Normal;
    [self.emptyDataScrollView reloadEmptyDataSet];
}

#pragma mark -
#pragma mrak - 关闭键盘
- (IBAction)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - DZNEmptyDataSetDelegate Methods
//标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self titleEmptyData];
}
//描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [self descriptionEmptyData];
    
}
//图标
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self imageEmptyData];
}
//背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}
//是否显示空数据
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
//是否允许点击
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    if (self.messageStatus == Message_Stauts_Normal) {
        return NO;
    }
    return YES;
}
//是否允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

//点击事件
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self reloadData];
}

#pragma mark -
#pragma mark - 提示语
/**
 *  检查是否有数据
 *
 *  @param dataArray 数据Array
 */
-(void)checkData:(NSArray*)dataArray{
    if (dataArray.count == 0) {
        self.messageStatus = Message_Stauts_No_Data;
        [self.emptyDataScrollView reloadEmptyDataSet];
    }
}

/**
 *  显示失败原因
 *
 *  @param messageType 类型
 *  @param message     错误描述
 */
-(void)showFailureMessage:(MessageStatus)messageStatus message:(NSString*)message{
    
    self.messageStatus = messageStatus;
    if (messageStatus == Message_Stauts_Failure) {
        self.messageTitle = message;
    }
    
    [self.emptyDataScrollView reloadEmptyDataSet];
    if (Message_Stauts_Failure == messageStatus
        || Message_Stauts_No_Network == messageStatus
        || Message_Stauts_Error == messageStatus) {
        
        [self showFailureHUD:[self titleMessage] hideTime:2.0f];

    }

}


#pragma mark -
#pragma mark - 空数据处理
/**
 *  空数据时数据提示
 *
 *  @return <#return value description#>
 */
-(UIColor*)backgroundColorForEmptyData{
    return [UIColor clearColor];
}
/**
 *  显示没有数据-图标
 */
-(UIImage*)imageEmptyData{

    UIImage *image = nil;
    if (self.messageStatus == Message_Stauts_No_Data) {
        return [UIImage imageNamed:@"icon_coffee_error"];
    }else if (self.messageStatus == Message_Stauts_No_Network){
        return [UIImage imageNamed:@"icon_network"];
    }else if (self.messageStatus == Message_Stauts_Error){
        return [UIImage imageNamed:@"icon_coffee_error"];
    }else if(self.messageStatus == Message_Stauts_Failure){
        return [UIImage imageNamed:@"icon_coffee_error"];
    }
    
    return image;

}
-(NSString*)titleMessage{
    NSString *text = nil;
    if (self.messageStatus == Message_Stauts_No_Data) {
        text = @"暂无数据";
    }else if (self.messageStatus == Message_Stauts_No_Network){
        text = @"网络不可用";
    }else if (self.messageStatus == Message_Stauts_Error){
        text = @"服务器繁忙,请稍后再试!";
    }else if(self.messageStatus == Message_Stauts_Failure){
        text = self.messageTitle;
    }
    return text;
}

/**
 *  显示没有数据-标题
 */
-(NSAttributedString*)titleEmptyData{

    NSString *text = [self titleMessage];
    if (text == nil) {
        return nil;
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
}

/**
 *  显示没有数据-描述
 */
-(NSAttributedString*)descriptionEmptyData{

    return nil;
    
}

#pragma mark -
#pragma mark - HUD
-(void)hideHUD{
    [self.hud hide:YES];
}

-(void)showLoadingHUD:(NSString*)message {

    self.hud.minSize = CGSizeMake(120, 120);
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = message;
    [self.hud show:YES];
    
}
-(void)showSuccessHUD:(NSString*)message   hideTime:(CGFloat) hideTime {

    UIImage *image = [UIImage imageNamed:@"succeed"];
    
    self.hud.customView = [[UIImageView alloc] initWithImage:image];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = message;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay: hideTime];

}

-(void)showFailureHUD:(NSString*)message  hideTime:(CGFloat) hideTime{

    UIImage *image = [UIImage imageNamed:@"error"];
    
    self.hud.customView = [[UIImageView alloc] initWithImage:image];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.minSize = CGSizeMake(120, 120);
    self.hud.labelText = message;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:hideTime];
    
}

-(void)showWarningHUD:(NSString*)message   hideTime:(CGFloat) hideTime{
    
    UIImage *image = [UIImage imageNamed:@"warning"];
    self.hud.customView = [[UIImageView alloc] initWithImage:image];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.minSize = CGSizeMake(120, 120);
    self.hud.labelText = message;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:hideTime];
}

-(void)showToastHUD:(NSString*)message    hideTime:(CGFloat) hideTime{
    
    [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.yOffset = [UIScreen mainScreen].bounds.size.height/2.0-40.0f;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:hideTime];
}



@end















