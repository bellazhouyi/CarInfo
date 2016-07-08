//
//  HomeViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "HomeViewController.h"

#import "AddInformationViewController.h"
#import "VehicleInformationViewController.h"

#import "HTTPManager.h"

#import "ShortNameForCity.h"
#import "SelectStateView.h"

#import "GSIndeterminateProgressView.h"

/**
 *  传递车牌号码和车架号码
 *
 *  @param licenseNumber 车牌号码
 *  @param frameNumber   车架号码
 */
typedef void(^passTextFieldValue)(NSString *licenseNumber,NSString *frameNumber,CarInfo *carInfo);

@interface HomeViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>

/**
 *  用于轮播图的scrollView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 *  scrollView的contentView
 */
@property (weak, nonatomic) IBOutlet UIView *contentViewForScroll;

/**
 *  用于显示contentView当前位置的pageControl
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/**
 *  定时器实例
 */
@property(nonatomic,strong) NSTimer *timer;

/**
 *  存储广告图片的数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_ImgName;


/**
 *  私家车的车牌号码的输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *licenseNumber;

/**
 *  车架号码的输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *frameNumber;

/**
 *  声明block属性
 */
@property(nonatomic,copy) passTextFieldValue passTextFieldValue;


/**
 *  区域选择Button
 */
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;


/**
 *  加载动画实例
 */
@property(nonatomic,strong) GSIndeterminateProgressView *progressView;

/**
 *  新车Button
 */
@property (weak, nonatomic) IBOutlet UIButton *xinCheButton;


/**
 *  立即比价Button
 */
@property (weak, nonatomic) IBOutlet UIButton *biJiaButton;


@property(nonatomic,strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@end

@implementation HomeViewController

#pragma mark - 视图加载完成后的系列操作
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self loadDataForContentImgOfScrollView];
    
    //设置轮播图
    [self setContentImgForContentViewWithImgNameArray:self.mutableArray_ImgName];
    
    //输入框跟随键盘自动上下浮
    [self startMove];
    
}

#pragma mark - 输入框跟随键盘自动上下浮
-(void)startMove{
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.delegate = self;
}

#pragma mark - 加载数据
-(void)loadDataForContentImgOfScrollView{
    
    [self.mutableArray_ImgName addObject:@"图层-67"];
    [self.mutableArray_ImgName addObject:@"图层-68"];
    [self.mutableArray_ImgName addObject:@"图层-69"];
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    //按回车可以改变
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    //得到输入框的内容
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //判断是否时我们想要限定的那个输入框
    if (self.frameNumber == textField)
    {
        //如果输入框内容大于17则弹出警告
        if ([toBeString length] > 17) {
            textField.text = [toBeString substringToIndex:17];
            
            return NO;
        }
    }
    
    if (self.licenseNumber == textField) {
        if ([toBeString length] > 6) {
            textField.text = [toBeString substringToIndex:6];
            
            return NO;
        }
    }
    
    
    
    return YES;
}



#pragma mark - 轮播图
-(void)setContentImgForContentViewWithImgNameArray:(NSArray *)imgNameArrar{
    
    for (int indexOfImgName = 0; indexOfImgName < imgNameArrar.count; indexOfImgName ++) {
        UIImage *img = [UIImage imageNamed:imgNameArrar[indexOfImgName]];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        
        imgView.frame = CGRectMake(self.view.bounds.size.width * indexOfImgName, 0, self.view.bounds.size.width, self.scrollView.bounds.size.height);
        
        [self.contentViewForScroll addSubview:imgView];
        
        imgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        
        [imgView addGestureRecognizer:tapGesture];
    }
    
    self.pageControl.numberOfPages = imgNameArrar.count;
    
    self.scrollView.delegate = self;
    
    //取消在scrollView在滑动过程中,图片的上下移动
    self.scrollView.bouncesZoom = YES;
    self.scrollView.alwaysBounceVertical = NO;
    
    //开启定时器
    [self starTimer];
    
}

#pragma mark -- UIScrollViewDelegate
#pragma mark -- 结束拖拽

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self starTimer];
}

#pragma mark -- 结束Scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    int currentPage = (offsetX + scrollWidth/2) / scrollWidth;
    
    self.pageControl.currentPage = currentPage;
    
}

#pragma mark -- 开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self closeTimer];
}

#pragma mark -- 切换到下一张图片
-(void)nextImg{
    
    int currentPage = (int)self.pageControl.currentPage;
    int count = (int)(self.mutableArray_ImgName.count - 1);
    if (count == currentPage) {
        currentPage = 0;
    }else{
        currentPage ++;
    }
    
    CGFloat offsetX = currentPage * self.scrollView.bounds.size.width;
    
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark -- 开启定时器
-(void)starTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
}


#pragma mark -- 关闭定时器
-(void)closeTimer{
    [self.timer invalidate];
}

#pragma mark -- tap轮播图中的图片点击事件
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"当前图片的索引值:  %ld",(long)self.pageControl.currentPage);
}


#pragma mark - 新车 跳转
/**
 *  新车，跳转添加信息
 *
 *  @param sender <#sender description#>
 */
- (IBAction)addCarAction:(UIButton *)sender {
    self.biJiaButton.userInteractionEnabled = NO;
    
    AddInformationViewController *addInformationVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"addInformationVCID"];
    
    //传值
    __weak typeof(addInformationVC) tempVC = addInformationVC;
    self.passTextFieldValue = ^(NSString *licenseNumber,NSString *frameNumber,CarInfo *carInfo){
        tempVC.view.backgroundColor = [UIColor whiteColor];
        tempVC.frameNumber = frameNumber;
        tempVC.licenseNumber = licenseNumber;
        tempVC.carInfo = carInfo;
    };
    
    touchNumberFlag ++;
    //点击一次,才能进入下一个页面
    if (touchNumberFlag == 1) {
        
        touchNumberFlag --;
        [self toViewController:addInformationVC withButton:sender];
    }
}



#pragma mark - 立即比价 事件消息
/**
 *  跳转到 补充车辆信息界面
 *
 *  @param sender <#sender description#>
 */
static int touchNumberFlag = 0;
- (IBAction)comparePrice:(UIButton *)sender {
    
    self.xinCheButton.userInteractionEnabled = NO;
    
    VehicleInformationViewController *vehicleInformationVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"vehivleInformationVCID"];
    
    //实现block
    __weak typeof(vehicleInformationVC) tempVC = vehicleInformationVC;
    self.passTextFieldValue = ^(NSString *licenseNumber,NSString *frameNumber,CarInfo *carInfo){
        tempVC.view.backgroundColor = [UIColor whiteColor];
        tempVC.licenseNumber = licenseNumber;
        tempVC.frameNumber = frameNumber;
        tempVC.carInfo = carInfo;
    };
    
    touchNumberFlag ++;
    if (touchNumberFlag == 1) {
        
        touchNumberFlag --;
        //调用跳转方法
        [self toViewController:vehicleInformationVC withButton:sender];
        
    }
}




#pragma mark - 跳转公用部分,调用接口，得到车辆信息并进行传递
-(void)toViewController:(UIViewController *)viewController withButton:(UIButton *)sender{
    
    //车牌号码
    NSString *licenseNumber = [NSString stringWithFormat:@"%@%@",self.areaBtn.titleLabel.text,[self.licenseNumber.text removeSpaceAndUpperStr]];
    //车架号码
    NSString *frameNumber = [self.frameNumber.text removeSpaceAndUpperStr];
    
    if ([frameNumber length] < 17 || self.licenseNumber.text.length < 6) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入合法的车牌号或车架号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.xinCheButton.userInteractionEnabled = YES;
            self.biJiaButton.userInteractionEnabled = YES;
        }];
        [alertController addAction:confirm];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
            //网络请求数据
            HTTPManager *manager = [HTTPManager sharedHTPPManager];
            
            GSIndeterminateProgressView *progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, sender.center.y + 18 ,
                                                                                                                      sender.frame.size.width, 2)];
            self.progressView = progressView;
            progressView.progressTintColor = [UIColor grayColor];
            progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
            sender.userInteractionEnabled = NO;
            [sender setTitle:@"加载中" forState:UIControlStateNormal];
            [self.view addSubview:progressView];
            
            [progressView startAnimating];
            
            //调用接口
            [manager GetCntr_CIInfoWithcph_no:licenseNumber cjh_no:frameNumber];
            
            
            __weak typeof(self) temp = self;
            manager.passCarInfoInstance = ^(CarInfo *carInfo){
                
                if (carInfo == nil) {
                    
                    temp.hidesBottomBarWhenPushed = YES;
                    [progressView stopAnimating];
                    pushToViewControllerAndTarget(temp, [viewController class], viewController);
                    
                }else{
                    
                    //调用block进行传值
                    temp.passTextFieldValue(licenseNumber,frameNumber,carInfo);
                    temp.hidesBottomBarWhenPushed = YES;
                    [progressView stopAnimating];
                    pushToViewControllerAndTarget(temp, [viewController class], viewController);
                }
                
                
                temp.hidesBottomBarWhenPushed = NO;
                [progressView removeFromSuperview];
                
                sender.userInteractionEnabled = YES;
                if (sender == self.biJiaButton) {
                    [sender setTitle:@"立即比价" forState:UIControlStateNormal];
                }else{
                    [sender setTitle:@"我是新车,还没有牌照?" forState:UIControlStateNormal];
                }
                
            };
            
            manager.passNullMsg_GetCntr_ClInfo = ^(){
                CarInfo *carInfo = [CarInfo new];
                carInfo.cph_no = licenseNumber;
                carInfo.cjh_no = frameNumber;
                temp.passTextFieldValue(licenseNumber,frameNumber,carInfo);
                temp.hidesBottomBarWhenPushed = YES;
                [progressView stopAnimating];
                pushToViewControllerAndTarget(temp, [viewController class], viewController);
                temp.hidesBottomBarWhenPushed = NO;
                [progressView removeFromSuperview];
                sender.userInteractionEnabled = YES;
                if (sender == self.biJiaButton) {
                    [sender setTitle:@"立即比价" forState:UIControlStateNormal];
                }else{
                    [sender setTitle:@"我是新车,还没有牌照?" forState:UIControlStateNormal];
                }
            };
        
        
        manager.passError = ^(){
            [GiFHUD showWithMessage:@"请求超时,请检查您的网络或者本机防火墙设置。"];
            self.view.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //移除动画
                [progressView stopAnimating];
                [GiFHUD dismissBiggerFrame];
                self.view.alpha = 1;
            });
        };
            
        }

}

#pragma mark - 选择车牌所在地区
- (IBAction)selectAreaForLicense:(UIButton *)sender {
    
    [self.frameNumber resignFirstResponder];
    [self.licenseNumber resignFirstResponder];
    
    HTTPManager *manager = [HTTPManager sharedHTPPManager];
    
    [manager getAllArea];
    
    NSMutableArray *cityNameArray = [NSMutableArray array];
    manager.passAllArea = ^(NSArray *array){
        for (ShortNameForCity *item in array) {
            [cityNameArray addObject:item.ShortName];
        }
        
        [self selectShortNameForCity:sender withArray:cityNameArray];
    };
    
}

#pragma mark -- 选择城市简称
-(void)selectShortNameForCity:(UIButton *)sender withArray:(NSArray *)array{
    
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    SelectStateView *selectStateView = (SelectStateView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectStateView" owner:nil options:nil] firstObject];
    //设置显示位置
    CGFloat height = selectStateView.bounds.size.height;
    CGRect frame ;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height - height;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = height;
    selectStateView.frame = frame;
    
    //设置初始值
    [selectStateView setOriginalViewWithArray:array];
    
    [self.view addSubview:selectStateView];
    
    
    selectStateView.passState = ^(NSString *state){
        if (![sender.titleLabel.text isEqualToString:state]) {
            [sender setTitle:state forState:UIControlStateNormal];
        }
        
        self.tabBarController.tabBar.hidden = NO;
    };
    
    selectStateView.passCancleSige = ^(){
        self.tabBarController.tabBar.hidden = NO;
    };
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
-(NSMutableArray *)mutableArray_ImgName{
    if (nil == _mutableArray_ImgName) {
        _mutableArray_ImgName = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_ImgName;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if (nil != self.progressView) {
        [self.progressView stopAnimating];
    }
    
    [self.xinCheButton setTitle:@"我是新车,还没有牌照?" forState:UIControlStateNormal];
    self.xinCheButton.userInteractionEnabled = YES;
    
    [self.biJiaButton setTitle:@"立即比价" forState:UIControlStateNormal];
    self.biJiaButton.userInteractionEnabled = YES;
}

#pragma mark - 销毁的时候
-(void)dealloc{
    self.returnKeyHandler.delegate = nil;
    self.timer = nil;
}


@end


