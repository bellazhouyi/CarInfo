//
//  GuideViewController.m
//  Template_Joker
//
//  Created by Bella on 16/2/22.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "GuideViewController.h"

#import "AppDelegate.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIView *scrollContentVIew;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property (weak, nonatomic) IBOutlet UIButton *toHomeBtn;


//@property(nonatomic,strong) NSTimer *timer;


@property(nonatomic,strong) NSMutableArray *mutableArray_ImgName;


@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mutableArray_ImgName addObject:@"引导页1"];
    [self.mutableArray_ImgName addObject:@"引导页2"];
    [self.mutableArray_ImgName addObject:@"引导页3"];
    
    self.toHomeBtn.hidden = YES;
    
    //设置轮播图
    [self setContentImgForContentViewWithImgNameArray:self.mutableArray_ImgName];
}




#pragma mark -- 轮播图
-(void)setContentImgForContentViewWithImgNameArray:(NSArray *)imgNameArrar{
    
    for (int indexOfImgName = 0; indexOfImgName < imgNameArrar.count; indexOfImgName ++) {
        UIImage *img = [UIImage imageNamed:imgNameArrar[indexOfImgName]];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        
        imgView.frame = CGRectMake(self.view.bounds.size.width * indexOfImgName, 0, self.view.bounds.size.width, self.scrollView.bounds.size.height);
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.clipsToBounds = YES;
        
        [self.scrollContentVIew addSubview:imgView];
        
        imgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        
        [imgView addGestureRecognizer:tapGesture];
        
        
    }
    
    self.pageControl.numberOfPages = imgNameArrar.count;
    
    
    self.scrollView.delegate = self;
    
    //取消在scrollView在滑动过程中,图片的上下移动
    self.scrollView.bouncesZoom = YES;
    
    //开启定时器
//    [self starTimer];
    
}

#pragma mark -- UIScrollViewDelegate
#pragma mark --- 结束拖拽

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self starTimer];
}

#pragma mark --- 结束Scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    int currentPage = (offsetX + scrollWidth/2) / scrollWidth;
    
    self.pageControl.currentPage = currentPage;
    
    int count = (int)(self.mutableArray_ImgName.count - 1);
    
    if (currentPage == count) {
        self.toHomeBtn.hidden = NO;
        [self.toHomeBtn addTarget:self action:@selector(startHomePage) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark --- 开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self closeTimer];
}

#pragma mark -- 切换到下一张图片
-(void)nextImg{
    
    int currentPage = (int)self.pageControl.currentPage;
    int count = (int)(self.mutableArray_ImgName.count - 1);
    if (count == currentPage) {
        
        //进入到首页
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        //关闭计时器
//        [self closeTimer];
        
        [APPDELEGATE startHomePage];
        
       
    }else{
//        currentPage ++;
    }
    
//    CGFloat offsetX = currentPage * self.scrollView.bounds.size.width;
//    
//    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - 进入车宝汇
-(void)startHomePage{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    
    //进入到车宝汇
    [APPDELEGATE startHomePage];
}


#pragma mark -- 开启定时器
-(void)starTimer{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
}


#pragma mark -- 关闭定时器
-(void)closeTimer{
//    [self.timer invalidate];
}

#pragma mark -- tap轮播图中的图片
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"当前图片的索引值:  %ld",(long)self.pageControl.currentPage);
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 懒加载
-(NSMutableArray *)mutableArray_ImgName{
    if (nil == _mutableArray_ImgName) {
        _mutableArray_ImgName = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_ImgName;
}


@end
