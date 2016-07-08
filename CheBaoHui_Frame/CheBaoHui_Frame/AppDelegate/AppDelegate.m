//
//  AppDelegate.m
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/14.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Configuration.h"
#import "HomeViewController.h"
#import "MineTableViewController.h"
#import "CarInsuranceViewController.h"
#import "CustomUINavigationViewController.h"
#import "DBManager.h"

#import <UMengAnalytics/MobClick.h>


#import "WXApi.h"

#import <AlipaySDK/AlipaySDK.h>

#import "RegisterViewController.h"
#import "Individual.h"

#import "GuideViewController.h"



@interface AppDelegate ()<RegisterViewControllerDelegate,NSURLConnectionDataDelegate>


@property (nonatomic, strong) CustomUINavigationViewController *  customUINavigation;

@property(nonatomic,strong) IQKeyboardManager *keyboardManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //给LaunchImage制作动画效果
    [self gainLaunchImage];
    
    //检测更新
//    [self updateAppVersion];
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    NSLog(@"BundleIdentifier:%@",[NSBundle mainBundle].bundleIdentifier);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //default is NO
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [self startGuideView];
    }
    else{
        [self startHomePage];
    }
    
    
    [self.window makeKeyAndVisible];
    
    
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#endif
    
    // 集成Mob以及关联IQKeyboardManager
    [self connectionWithMob];
    
    
    return YES;
}


#pragma mark - 获取LaunchImage
-(void)gainLaunchImage{
    CGSize viewSize = self.window.bounds.size;
    
    NSString *viewOrientation = @"Portrait";
    
    NSString *launchImageStr = nil;
    
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageStr = dict[@"UILaunchImageName"];
        }
    }
    
//    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchimage]];
    
//    launchView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    [self.window addSubview:launchView];
//    
//    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        launchView.alpha = 0.0f;
//        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
//    } completion:^(BOOL finished) {
//        [launchView removeFromSuperview];
//    }];
    
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"launchimage"].CGImage;
    maskLayer.frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
    self.window.layer.mask = maskLayer;
    
    
    
}

#pragma mark - 集成Mob以及关联IQKeyboardManager
-(void)connectionWithMob{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //集成友盟
    [MobClick startWithAppkey:@"56d401dd67e58e774100226d" reportPolicy:BATCH channelId:@"HuaRui_CheBaoHui"];
    
    [MobClick setLogEnabled:YES];
    
    
    //IQKeyboardManager'
    self.keyboardManager = [IQKeyboardManager sharedManager];
    //控制整个功能是否启用
    _keyboardManager.enable = YES;
    //控制点击背景是否收起键盘
    _keyboardManager.shouldResignOnTouchOutside = YES;
    //控制键盘上的工具条文字颜色是否用户自定义
    _keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    //控制是否显示键盘上的工具条
    _keyboardManager.enableAutoToolbar = NO;
}


#pragma mark - 版本更新提示
-(void)updateAppVersion{
//    // 1. 获取当前的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
//    
//    // 2.获取上一次的版本号
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@""];
    NSString *UrlStr = @"http://itunes.apple.com/lookup?id=1080527856";
    NSURL *url = [NSURL URLWithString:UrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSLog(@"当前版本:%@",currentVersion);

}

#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSLog(@"%@",jsonObject);
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    
    NSLog(@"%@",version);
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    if (![version isEqualToString:currentVersion]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本,是否更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:confirmAction];
        [alertController addAction:cancleAction];
    }
}


#pragma mark -- 进入引导页
-(void)startGuideView{
    GuideViewController *guideVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"guideVCID"];
    
    self.window.rootViewController = guideVC;
    
}


#pragma mark -- 进入首页
-(void)startHomePage{
    HomeViewController *homeVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"homeVCID"];
    UINavigationController *homeNC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"fm_mine_top_bg"] forBarMetrics:UIBarMetricsDefault];
    
    homeNC.title = @"车宝汇";
    
    //修改导航栏上的颜色之类的
    [homeNC changeColorWithNavigationControllerInstance:homeNC];
    
    homeNC.tabBarItem.image = [UIImage imageNamed:@"首页"];
    
    CarInsuranceViewController *carInsuranceVC = [[UIStoryboard storyboardWithName:@"CarInsurance" bundle:nil]instantiateViewControllerWithIdentifier:@"CarInsuranceVCID"];
    carInsuranceVC.title = @"车险投保";
    carInsuranceVC.tabBarItem.image = [UIImage imageNamed:@"车险投保"];
    
    MineTableViewController *mineTVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil]instantiateViewControllerWithIdentifier:@"MineTVCID"];
    mineTVC.title = @"我的";
    mineTVC.tabBarItem.image = [UIImage imageNamed:@"我的"];
    UITabBarController *tabBC = [[UITabBarController alloc]init];
    tabBC.viewControllers = @[homeNC,carInsuranceVC,  mineTVC];
    
    
    CustomUINavigationViewController * mainNaviController = [[CustomUINavigationViewController alloc]  initWithRootViewController: tabBC];
    
    self.customUINavigation = mainNaviController;
    
    [mainNaviController  setNavigationBarHidden:YES animated:NO] ; 
    
    DBManager *dbManager = [DBManager sharedInstance];
    /**
     *  创建数据库
     */
    Individual *  indivudual = [dbManager selectIndividual];
    if(indivudual==nil){
        RegisterViewController * registerView = [[RegisterViewController alloc] init];
        registerView.delegate = self;
        UINavigationController * loginNavigation = [[UINavigationController alloc] initWithRootViewController: registerView];
        [loginNavigation setNavigationBarHidden:YES animated:NO];
        self.window.rootViewController = loginNavigation;
        
        [dbManager  deleteImageData];
        
        
    }else{
        self.window.rootViewController = mainNaviController ;
        
    }
    
    //向微信注册wx502dd5b3e3c86e69
    [WXApi registerApp:@"wx502dd5b3e3c86e69" withDescription:@"车宝汇 1.0"];
}

-(void)passIsLogin:(BOOL)isLogin
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = self.customUINavigation;
    
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- 支付宝支付后的回调
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.com.huirui.chebaohui.core" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IndividualInfo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IndividualInfo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end


#pragma mark -- 实现类目ChangeColor
@implementation UINavigationController (ChangeColor)

#pragma mark --- 实现修改bar颜色
-(void)changeColorWithNavigationControllerInstance:(UINavigationController *)instance{
    //修改导航栏标题颜色
    [instance.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //修改导航栏item的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //将bar文字设置为不显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMax) forBarMetrics:UIBarMetricsDefault];
}

@end

