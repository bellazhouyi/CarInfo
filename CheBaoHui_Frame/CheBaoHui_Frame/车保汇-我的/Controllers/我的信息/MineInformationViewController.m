//
//  MineInformationViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineInformationViewController.h"
#import "MineItemModel.h"
#import "MineSectionModel.h"
#import "MineViewCell.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"
#import "PhotoViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "PublicInputInformationViewController.h"
#import "AuthenticationViewController.h"
#import "DBManager.h"
#import "Individual.h"
#import "ResultModel.h"
#import "DataModel.h"
#import "MJExtension.h"
#import "AuthenticationingViewController.h"
#import "KevinBaseController.h"
#import "ReplacePhoneViewController.h"
#import "DBManager.h"
#import "Individual.h"
#import "HeadPortraitTableViewCell.h"
#import "ShortNameForCity.h"
#import "ShowCityTableViewController.h"

@interface  MineInformationViewController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,PublicInputInformationViewDelegate,KevinBaseControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *informationTableView;

@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/



@property (nonatomic ,copy ) NSString * nickName;

/**
 *  相册view
 */
@property (nonatomic , strong)  PhotoViewController *photoView;

/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;

/**
 *  右侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * rightItemBar;


/**
 *  审核中 和审核成功
 */
@property (nonatomic , strong)AuthenticationingViewController * authenticationingViewController;

/**
 *  待审核和审核失败
 */
@property(nonatomic , strong) AuthenticationViewController *  authenticationViewController;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;

@property (nonatomic ,strong) DataModel *  data;

@end

#pragma mark - 重用标识符
static NSString *MineViewCellIdentifier = @"MineViewCell";
static NSString *HeadPortraitTableViewCellIdentifier = @"HeadPortraitTableViewCell";

@implementation MineInformationViewController

#pragma mark - viewDidLoad
-(void)  viewDidLoad{
    [super  viewDidLoad];
    
    self.informationTableView.backgroundColor = ColorFromRGB(243, 244, 245);
    
    //这是表格不能拖动
    self.informationTableView.scrollEnabled = NO;
    [self.informationTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.informationTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [self loadData];
    
    //注册cell
    [self.informationTableView registerClass:[MineViewCell class] forCellReuseIdentifier:MineViewCellIdentifier];
    [self.informationTableView registerNib:[UINib nibWithNibName:@"HeadPortraitTableViewCell" bundle:nil] forCellReuseIdentifier:HeadPortraitTableViewCellIdentifier];
    
    
    //cell自适应
    self.informationTableView.rowHeight = UITableViewAutomaticDimension;
    self.informationTableView.estimatedRowHeight = 44.0;
    
}

#pragma mark - 加载数据
-(void)loadData{
    //读取数据库
    DBManager * dbManager  = [DBManager  sharedInstance];
    Individual * individual =  [dbManager selectIndividual];
    
    // 调用 GetBusinessUserById接口
    [self.HTTPManagerInstance GetBusinessUserByIdWithId:individual.individualId];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        DataModel *  data = [result data];
        
        //setter方法
        temp.data = data;
        
        //刷新页面数据
        [temp.informationTableView reloadData];
        
        [temp.navigationController  setNavigationBarHidden:NO animated:NO];
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetBusinessUserById = ^(NSError *error){
        NSLog(@"失败");
        [super showToastHUD:FailureAboutRequestData hideTime:ToastHideTime];
    };
}

#pragma mark - data的setter方法
-(void)setData:(DataModel *)data
{
    _data = data;
    
    //初始化数据
    [self  setupSections];
    
}



#pragma mark - 初始化数据
-(void) setupSections
{
    //头像
    MineItemModel *  headPortrait = [[MineItemModel alloc] init];
    headPortrait.funcName = @"头像";
    headPortrait.accessoryType = MineAccessoryTypeHeadPortrait;
    
    if(self.data.PhotoUrl==nil){
        //设置默认图
        UIImage * image =  [UIImage  resizableImageWithName:@"test_user" andW:HEADPORTAIT_WIDTH andH:HEADPORTAIT_HEIGHT];
        
        headPortrait.detailImage = image;
    }else{
        //否则,上传的图片
        headPortrait.headerImageUrl = self.data.PhotoUrl;
    }
    
    KevinBaseController *kevinBase = (KevinBaseController *)self;
    //头像
    kevinBase.imageFromType = ImageFromTypePortrait;
    __weak typeof(kevinBase) tempKevinBase = kevinBase;
    __weak typeof(self) temp = self;
    headPortrait.executeCode= ^{
        [tempKevinBase callCameraOrPhotoLibary];
        tempKevinBase.delegate = temp;
        tempKevinBase.baseType = KevinBaseTypePortrait;
        
    };
    
    //昵称
    MineItemModel *  nickname = [[MineItemModel alloc] init];
    nickname.funcName = @"昵称";
    
    if(self.nickName ==nil){
        nickname.detailText  =  self.data.NickName;
    }else{
        nickname.detailText  =  self.nickName;
    }
    
    nickname.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    nickname.executeCode = ^{
        PublicInputInformationViewController *  publicInputInformationView = [[PublicInputInformationViewController alloc] init];
        //昵称
        publicInputInformationView.publicInputInformationType = PublicInputInformationTypeNickName;
        if(temp.nickName == nil){
            publicInputInformationView.text = temp.data.NickName;
        }else{
            publicInputInformationView.text = temp.nickName;
        }
        publicInputInformationView.delegate = temp;
        publicInputInformationView.title = @"昵称";
        
        publicInputInformationView.navigationItem.leftBarButtonItem = temp.leftItemBar;
        [temp.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(temp, PublicInputInformationViewController,publicInputInformationView);
    };
    
    //所在城市
    MineItemModel *  localityCity = [[MineItemModel alloc] init];
    localityCity.funcName = @"所在城市";
    
    if(self.data.AreaName==nil){
        localityCity.detailText = @"重庆市";
    }else{
        localityCity.detailText =  self.data.AreaName;
    }
    localityCity.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    DBManager * dbManager = [DBManager sharedInstance];
    
    Individual * individual =  [dbManager  selectIndividual];
    
    //回调,点击地址,执行的代码
    localityCity.executeCode = ^{
        
        ShowCityTableViewController *showCityTVC = [ShowCityTableViewController new];
        
        //回调 赋值 刷新 显示所在城市
        showCityTVC.passCityName = ^(NSString *cityName,NSString *cityCode){
            temp.data.AreaName = cityName;
            
            //修改城市代号
            [temp.HTTPManagerInstance ModifyBusinessInfoWithId:individual.individualId nickName:@"" areaCode:cityCode photo:@""];
            
            _HTTPManagerInstance.passResponseObjectOfModifyBusinessInfo = ^(id responseData){
                
            };
            
            _HTTPManagerInstance.passErrorOfModifyBusinessInfo = ^(NSError *error){
                
            };
            
            //初始化数据
            [temp setupSections];
            
            //刷新
            [temp.informationTableView reloadData];
        };
        
        pushToViewControllerAndTarget(temp, ShowCityTableViewController, showCityTVC);
        
    };
    
    //电话
    MineItemModel  *  phoneNumber = [[MineItemModel alloc] init];
    phoneNumber.funcName = @"电话";
    phoneNumber.detailText =self.data.MobilePhone;
    phoneNumber.accessoryType = MineAccessoryTypeDisclosureIndicator;
    phoneNumber.executeCode = ^{
        ReplacePhoneViewController *   replacePhoneView  = [[ReplacePhoneViewController alloc] init];
        replacePhoneView.title = @"手机号码";
        
        replacePhoneView.phone = temp.data.MobilePhone;
        
        replacePhoneView.phoneId = temp.data.Id;
        
        replacePhoneView.navigationItem.leftBarButtonItem = temp.leftItemBar;
        [temp.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(temp, ReplacePhoneViewController, replacePhoneView);
    };
    
    
    //第一组
    MineSectionModel * section1 = [[MineSectionModel alloc] init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[headPortrait, nickname , localityCity , phoneNumber];
    
    //实名认证
    MineItemModel  *  authentication = [[MineItemModel alloc] init];
    authentication.funcName  = @"实名认证";
    authentication.detailText =  self.data.StatusName;
    
    authentication.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    if([self.data.Status  isEqualToString:@"0"]){
        authentication.detailText = @"未审核";
    }else if([self.data.Status isEqualToString:@"1"]) {
        authentication.detailText = @"认证中";
    }else if ([self.data.Status  isEqualToString:@"2"]){
        authentication.detailText = @"认证成功";
    }else if ([self.data.Status  isEqualToString:@"3"]){
        authentication.detailText = @"认证失败";
    }
    
    
    //跳转到 实名认证 页面
    authentication.executeCode = ^{
        
        // 调用 GetBusinessUserById接口
        [temp.HTTPManagerInstance GetBusinessUserByIdWithId:individual.individualId];
        
        //成功 获得数据
        _HTTPManagerInstance.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
            
            //字典 转 模型
            ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
            
            DataModel *  data = [result data];
            
            temp.authenticationViewController.data = data;
            
            if([ temp.data.Status isEqualToString:@"0"]  || [temp.data.Status isEqualToString:@"3"]  ){  //待审核
                if([temp.data.Status isEqualToString:@"0"]){
                    temp.authenticationViewController.title = @"实名认证";
                }else{
                    temp.authenticationViewController.title = @"认证失败";
                }
                pushToViewControllerAndTarget(temp, AuthenticationViewController, temp.authenticationViewController);
            }
            
            if([ temp.data.Status  isEqualToString:@"1"] || [temp.data.Status  isEqualToString:@"2" ]){//审核中
                
                if([temp.data.Status isEqualToString:@"1"]){
                    temp.authenticationingViewController.title = @"认证中";
                }else{
                    temp.authenticationingViewController.title = @"认证成功";
                }
                
                temp.authenticationingViewController.navigationItem.leftBarButtonItem = temp.leftItemBar;
                pushToViewControllerAndTarget(temp, AuthenticationingViewController, temp.authenticationingViewController);
            }
            
        };
        
        //失败
        _HTTPManagerInstance.passErrorOfGetBusinessUserById = ^(NSError *error){
            [super showToastHUD:FailureAboutRequestData hideTime:ToastHideTime];
        };
        
        [temp.navigationController  setNavigationBarHidden:NO];
        
    };
    
    //第二组
    MineSectionModel * section2 = [[MineSectionModel alloc] init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[authentication];
    
    //sectionArray 初始化
    self.sectionArray = @[section1, section2];
}


#pragma  mark - UITableView  代理
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.sectionArray.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MineSectionModel  * sectionModel =   self.sectionArray[section];
    return   sectionModel.itemArray.count;
}

-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取组
    MineSectionModel *  sectionModel = self.sectionArray[indexPath.section];
    MineItemModel * mineItem =   sectionModel.itemArray[indexPath.row];
    //头像row
    if(mineItem.accessoryType == MineAccessoryTypeHeadPortrait){
        
        HeadPortraitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HeadPortraitTableViewCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.item =  mineItem;
        return cell;
    }else{
        MineViewCell * cell =    [tableView  dequeueReusableCellWithIdentifier:MineViewCellIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.item = mineItem;
        return cell;
    }
    return nil;
    
    
    
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //获取组
//    MineSectionModel *  sectionModel = self.sectionArray[indexPath.section];
//    MineItemModel * mine =   sectionModel.itemArray[indexPath.row];
//    if(mine.accessoryType == MineAccessoryTypeHeadPortrait){
//        HeadPortraitTableViewCell * cell = [HeadPortraitTableViewCell cellWithTableView:tableView forIndexPath:indexPath];
//        return cell.height;
//    }else{
//        return 44;
//    }
//}

-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MineSectionModel  * sectionModel =   self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}

#pragma mark -- 点击cell 跳转
-(void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    MineSectionModel * sectionModel =  self.sectionArray[indexPath.section];
    MineItemModel * item=   sectionModel.itemArray[indexPath.row];
    
    //回调 跳转
    if(item.executeCode){
        item.executeCode();
    }
}


#pragma mark - UITableView处理section的不悬浮，禁止section停留的方法，主要是这段代码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    MineSectionModel * sectionModel = [self.sectionArray  firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;
    if(scrollView.contentOffset .y <= sectionHeaderHeight  && scrollView.contentOffset.y >=0){
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if(scrollView.contentOffset.y>=sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - PublicInputInformationViewDelegate
#pragma mark -- 昵称 协议方法
-(void)callBackText:(NSString *)text type:(PublicInputInformationType)type
{
    //昵称
    if(type == PublicInputInformationTypeNickName){
        
        DBManager * dbManager = [DBManager sharedInstance];
        
        Individual * individual =  [dbManager  selectIndividual];
        
        NSString *nickName = text;
        
        //调用ModifyBusinessInfo接口--修改昵称
        [self.HTTPManagerInstance ModifyBusinessInfoWithId:individual.individualId nickName:nickName areaCode:@"" photo:@""];
        
        __weak typeof(self) temp = self;
        //成功获得数据
        _HTTPManagerInstance.passResponseObjectOfModifyBusinessInfo = ^(id responseObject){
            ResultModel * result = [ResultModel  mj_objectWithKeyValues:responseObject];
            /**
             *  修改成功
             */
            if([result.code  isEqualToString:@"0"]){
                //修改数据
                [dbManager updateNickName:text phoneNumber: individual.phoneNumber];
                //把修改的数据设置给nickName
                temp.nickName = text;
                
                //重新初始化数据
                [temp setupSections];
                
                //刷新数据
                [temp.informationTableView reloadData];
                
                [temp.navigationController  popViewControllerAnimated:YES];
            }
        };
        
        //失败
        _HTTPManagerInstance.passErrorOfModifyBusinessInfo = ^(NSError *error){
            [super showToastHUD:FailureAboutRequestData hideTime:ToastHideTime];
        };
    }
}

#pragma mark - KevinBaseControllerDelegate
#pragma mark -- 头像  协议方法
-(void)callback:(UIImage *)image type:(PhotoType)type  baseType:(KevinBaseType)baseType photoId:(NSString *)photoId
{
    
    DBManager * dbManager = [DBManager sharedInstance];
    Individual * individual =  [dbManager selectIndividual];
    
    //调用 ModifyBusinessInfo接口--修改头像
    [self.HTTPManagerInstance ModifyBusinessInfoWithId:individual.individualId nickName:@"" areaCode:@"" photo:photoId];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfModifyBusinessInfo = ^(id responseObject){
        [temp  modificationHeaderImage: individual.individualId];
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfModifyBusinessInfo = ^(NSError *error){
        [super showToastHUD:FailureAboutRequestData hideTime:ToastHideTime];
    };
    
}
#pragma mark --- 修改头像
-(void) modificationHeaderImage :(NSString * ) individualId
{
    
    //调用 GetBusinessUserById 接口
    [self.HTTPManagerInstance GetBusinessUserByIdWithId:individualId];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        DataModel *  data = [result data];
        
        temp.data  = data;
        
        //重新初始化数据
        [temp setupSections];
        
        //刷新数据
        [temp.informationTableView reloadData];
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetBusinessUserById = ^(NSError *error){
        [super showToastHUD:FailureAboutRequestData hideTime:ToastHideTime];
    };
    
    
}


#pragma  mark - 懒加载

-(AuthenticationingViewController *)authenticationingViewController
{
    
    if(!_authenticationingViewController){
        AuthenticationingViewController * authenticationingView = [[AuthenticationingViewController alloc] init];
        
        _authenticationingViewController = authenticationingView;
        
    }
    return _authenticationingViewController;
}


-(PhotoViewController *)photoView
{
    if(!_photoView){
        PhotoViewController * photoView = [[PhotoViewController alloc] init];
        photoView.title = @"选择图片";
        self.photoView = photoView;
    }
    return  _photoView;
}



-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}


-(UIBarButtonItem *)rightItemBar
{
    if(!_rightItemBar){
        UIBarButtonItem * rightItemBar = [[UIBarButtonItem alloc] init];
        rightItemBar.tintColor = [UIColor  whiteColor];
        rightItemBar.title = @"确定";
        self.rightItemBar = rightItemBar;
    }
    return  _rightItemBar;
}

-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}

-(void) back
{
    [self.navigationController  popViewControllerAnimated:YES];
}


#pragma mark - 内存警告
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.HTTPManagerInstance = nil;
}

#pragma mark - dealloc
-(void)dealloc{
    self.HTTPManagerInstance = nil;
}



@end

