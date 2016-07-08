//
//  AuthenticationViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "MineSectionModel.h"
#import "MineItemModel.h"
#import "MineViewCell.h"
#import "UIView+Extension.h"
#import "PhotoViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "PublicInputInformationViewController.h"
#import "AuthenticationViewController.h"
#import "AgreeView.h"
#import "DBManager.h"
#import "Individual.h"
#import "UIImage+Extension.h"
#import "PhotoViewController.h"
#import "DBManager.h"
#import "ImageDataModel.h"
#import "ImageData.h"
#import "ResultModel.h"
#import "MJExtension.h"
#import "DataModel.h"


@interface AuthenticationViewController ()<PublicInputInformationViewDelegate,KevinBaseControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *authenticationTableView;


@property (nonatomic , strong) AgreeView * agreeView;

/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;

/**
 *  右侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * rightItemBar;

/**
 *  真实姓名
 */
@property (nonatomic ,copy)NSString * truthName;

/**
 *  身份证
 */
@property (nonatomic , copy) NSString * idCard;
/**
 *  银行卡号
 */
@property (nonatomic , copy) NSString * bankCard;

/**
 *资格证号码
 */
@property (nonatomic , copy) NSString * competencyNumber;

//身份证正面图片
@property (nonatomic , strong) UIImage * frontImage;
//身份证反面图片
@property (nonatomic , strong) UIImage * versoImage;
//资格证内页
@property (nonatomic , strong) UIImage * credentialsImage;
//身份证个正面图片id
@property(nonatomic , copy) NSString  * frontImageId;
//身份证反面图片id
@property (nonatomic , copy) NSString * versoImageId;
// 资格证内页id
@property (nonatomic , copy) NSString * credentialsImageId;
/**< section模型数组*/
@property (nonatomic , strong) NSArray * sectionArray;

@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;

@end

@implementation AuthenticationViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

}


-(void) setData:(DataModel *)data
{
     _data = data;
    self.navigationItem.leftBarButtonItem = self.leftItemBar;
    [self setupSections];
    [self.authenticationTableView  reloadData];
}

/**
 *  初始化数据
 */
-(void) setupSections
{
    MineItemModel * authenticName = [[MineItemModel alloc] init];
    authenticName.funcName = @"真实姓名";
    authenticName.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    
    [self setMineItem : authenticName  inputText:self.truthName dataText:self.data.Name isBank:NO];
    authenticName.executeCode = ^{
        PublicInputInformationViewController *publicInputInformationView = [[PublicInputInformationViewController alloc] init];
        publicInputInformationView.delegate = self;
        publicInputInformationView.title = @"真实姓名";
        /**
         *  比较 然后判断,设置内容
         */
        
        [self publicInputInformationView:publicInputInformationView  inputText:self.truthName  dataText:self.data.Name];
        
        publicInputInformationView.navigationItem.leftBarButtonItem = self.leftItemBar;
        //真实姓名状态
        publicInputInformationView.publicInputInformationType = PublicInputInformationTypeTruthName;
    
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(self, PublicInputInformationViewController, publicInputInformationView);
    };
    
    MineItemModel * identityCardNumber =[[MineItemModel alloc] init];
    identityCardNumber.funcName = @"身份证号码";

    [self setMineItem : identityCardNumber  inputText:self.idCard dataText:self.data.IdCardNo isBank:NO];
    
    identityCardNumber.executeCode = ^{
        PublicInputInformationViewController *publicInputInformationView = [[PublicInputInformationViewController alloc] init];
        publicInputInformationView.delegate = self;
        /**
         *  比较 然后判断,设置内容
        */
        [self publicInputInformationView:publicInputInformationView  inputText:self.idCard  dataText:self.data.IdCardNo];
        
        publicInputInformationView.title = @"身份证号码";
        publicInputInformationView.navigationItem.leftBarButtonItem = self.leftItemBar;
        //身份证号码状态
        publicInputInformationView.publicInputInformationType = PublicInputInformationTypeIDCard;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(self, PublicInputInformationViewController, publicInputInformationView);
    };
    
    identityCardNumber.accessoryType = MineAccessoryTypeDisclosureIndicator;
    MineItemModel  *  competencyNumber = [[MineItemModel alloc] init];
    competencyNumber.funcName = @"资格证号码";
    
    competencyNumber.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    [self setMineItem : competencyNumber  inputText:self.competencyNumber dataText:self.data.QCertificateNo isBank:NO];
    
    
    competencyNumber.executeCode = ^{
        PublicInputInformationViewController *publicInputInformationView = [[PublicInputInformationViewController alloc] init];
        
        publicInputInformationView.delegate = self;
        /**
         *  比较 然后判断,设置内容
         */
        [self publicInputInformationView:publicInputInformationView  inputText:self.competencyNumber  dataText:self.data.QCertificateNo];
        
        publicInputInformationView.title = @"资格证号码";
        publicInputInformationView.navigationItem.leftBarButtonItem = self.leftItemBar;
        //资格号码状态
        publicInputInformationView.publicInputInformationType = PublicInputInformationTypeCompetencyCode;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(self, PublicInputInformationViewController, publicInputInformationView);
    };
    
    
    MineItemModel * bankCard = [[MineItemModel alloc] init];
    bankCard.funcName = @"银行卡";
    
    bankCard.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    [self setMineItem : bankCard  inputText:self.bankCard dataText:self.data.BankNo isBank:YES];
    
    bankCard.executeCode = ^{
        PublicInputInformationViewController *  publicInputInformationView = [[PublicInputInformationViewController alloc] init];
        publicInputInformationView.publicInputInformationType = PublicInputInformationTypeBankCard;
        publicInputInformationView.delegate = self;
        /**
         *  比较 然后判断,设置内容
         */
        [self publicInputInformationView:publicInputInformationView  inputText:self.bankCard  dataText:self.data.BankNo];
        publicInputInformationView.navigationItem.leftBarButtonItem = self.leftItemBar;
        publicInputInformationView.title = @"农业银行卡卡号";
        [self.navigationController  setNavigationBarHidden:NO];
        pushToViewControllerAndTarget(self, PublicInputInformationViewController, publicInputInformationView);
    };
    
    MineSectionModel * section1 = [[MineSectionModel alloc] init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[authenticName , identityCardNumber , competencyNumber,bankCard];
    //身份证正面
    MineItemModel *identityCardFront = [[MineItemModel alloc] init];
    identityCardFront.funcName = @"身份证正面";
    identityCardFront.accessoryType = MineAccessoryTypeDisclosureIndicator;
    

        if(self.frontImage!=nil && self.frontImageId!=nil){
            identityCardFront.detailImage =  self.frontImage;
        }else{
            identityCardFront.detailText = @"未上传";
        }

    
    KevinBaseController *kevinBase = (KevinBaseController *)self;
    kevinBase.delegate = self;
    kevinBase.imageFromType = ImageFromTypeAuthentication;  //认证
    identityCardFront.executeCode = ^{
        kevinBase.photoType = PhotoTypeIDCardFront;
        //调用显示照片来源
        [kevinBase callCameraOrPhotoLibary];
    };
    
    MineSectionModel * section2 = [[MineSectionModel alloc] init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[identityCardFront];

    //身份证反面
    MineItemModel *identityCardVerso = [[MineItemModel alloc] init];
    identityCardVerso.funcName = @"身份证反面";
    
    identityCardVerso.detailText = @"未上传";
    identityCardVerso.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
 
        if(self.versoImage!=nil && self.versoImageId!=nil ){
            identityCardVerso.detailImage = self.versoImage;
        }else{
            identityCardFront.detailText = @"未上传";
        }
    
    
    identityCardVerso.executeCode  = ^{
        kevinBase.photoType = PhotoTypeIDCardVerso;
        [kevinBase callCameraOrPhotoLibary];
    };
    
    MineSectionModel * section3 = [[MineSectionModel alloc] init];
    section3.sectionHeaderHeight = 18;
    section3.itemArray = @[identityCardVerso];
    //资格证
    MineItemModel * competencyPage = [[MineItemModel alloc] init];
    competencyPage.funcName = @"资格证内页";
    
    competencyPage.detailText = @"未上传";

        if(self.credentialsImage!=nil && self.credentialsImageId !=nil){
            competencyPage.detailImage = self.credentialsImage;
        }else{
            identityCardFront.detailText = @"未上传";
        }
    
    
    competencyPage.accessoryType = MineAccessoryTypeDisclosureIndicator;

    competencyPage.executeCode = ^{
        
        kevinBase.photoType = PhotoTypeCredentials;
        [kevinBase callCameraOrPhotoLibary];
    };
    MineSectionModel * section4 = [[MineSectionModel alloc] init];
    section4.sectionHeaderHeight = 18;
    section4.itemArray = @[competencyPage];
    self.sectionArray  = @[section1 , section2,section3, section4];
}

#pragma  mark   比较
/**
 *
 //如果 truthName nil 或者 self.data.Name 为nil  就不显示
 //如果truthName nil  或者 self.data.Name   有值  就显示 self.data.Name
 //如果 填写返回 发现truthName 有值  或者self.data.Name 没值 就显示 truthName
 //如果 填写返回发现 truthName 有值 或者 self.data.Name 有值 就显示 truthName
 
 *
 *  @param mineItem   需要把text设置到模型
 *  @param inputText  输入回显的text
 *  @param dataText  从服务端获取的text
 */

-(void)   setMineItem :(MineItemModel *) mineItem   inputText :(NSString * )  inputText   dataText :(NSString*) dataText  isBank:(BOOL )  isBank
{
    if(inputText ==nil && dataText!=nil){
        //就显示 self.data.Name
        mineItem.detailText = dataText;
    } else if(inputText!=nil && dataText==nil){
        //就显示 truthName
        mineItem.detailText =inputText;
    } else if(inputText!=nil &&  dataText!=nil){
        mineItem.detailText = inputText;
    }else{
        if(isBank){
            mineItem.detailText = @"只支持农业银行";
        }
    }
}


/**
 *  比较之后设置内容
 */
-(void)  publicInputInformationView :(PublicInputInformationViewController * ) publicInputInformationView inputText :(NSString *) inputText  dataText:(NSString *) dataText
{
    if(inputText!=nil){
        publicInputInformationView.text = inputText;
    }else{
        publicInputInformationView.text = dataText;
    }
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MineSectionModel * sectionModel =  self.sectionArray [section];
    return  sectionModel.itemArray.count;
}

-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //id
    static  NSString * ID = @"ID";
    // 获取组
    MineSectionModel * sectionModel = self.sectionArray[indexPath.section];
    //得到组中的item
    MineItemModel *  itemModel = sectionModel.itemArray[indexPath.row];
    MineViewCell *  cell =  [tableView dequeueReusableCellWithIdentifier: ID];
    if(!cell){
        cell = [[MineViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
    }
    //设置选中cell的时候选中为none
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = itemModel;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MineSectionModel * sectionModel = self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES ];
    MineSectionModel * sectionModel =  self.sectionArray[indexPath.section];
    MineItemModel * item=   sectionModel.itemArray[indexPath.row];
    if(item.executeCode){
        item.executeCode();
    }
}

#pragma mark --  uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
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


#pragma  mark  PublicInputInformationViewController
-(void)callBackText:(NSString *)text type:(PublicInputInformationType)type
{
    if(type == PublicInputInformationTypeTruthName ){
        self.truthName = text;
        
    }else if(type ==PublicInputInformationTypeIDCard ){
        self.idCard = text;
        
    }else if(type == PublicInputInformationTypeCompetencyCode){
        self.competencyNumber = text;
        
    }else if(type == PublicInputInformationTypeBankCard){
        self.bankCard = text;
    }    
    [self setupSections];
    [self.authenticationTableView reloadData];
    [self.navigationController  popViewControllerAnimated:YES];
}


#pragma  mark   点击相册选择图片返回的图片代理
-(void)callback:(UIImage *)image  type:(PhotoType)type  baseType:(KevinBaseType)baseType photoId:(NSString *)photoId
{
    if(type == PhotoTypeIDCardFront){
      
        self.frontImage = image;
        self.frontImageId = photoId;
        
    }else if(type ==PhotoTypeIDCardVerso){
        
        self.versoImage = image;
        self.versoImageId = photoId;
        
    }else if(type == PhotoTypeCredentials){
        
        self.credentialsImage = image;
        self.credentialsImageId = photoId;
    }
    /**
     *  重新调用方法 然后reloaddata
     */
    [self setupSections];
    [self.authenticationTableView reloadData];
    
}



#pragma  mark  AgreeView 中的Target
/**
 *  服务条款target
 */
-(void)serveArticleaddTarget
{
    
}


#pragma mark -- 我已阅读并申请同意,实名认证
-(void) agreeArticleaddTarget
{
    //判断姓名是否填写
    if(!self.truthName && self.data.Name.length ==0){
        [super showToastHUD:@"请填写姓名" hideTime:2.0f];
        return;
    }
    //判断身份证是否填写
    
    if(!self.idCard && self.data.IdCardNo.length ==0){
        [super showToastHUD:@"请填写身份证" hideTime:2.0f];
        return;
    }
    //判断资格证号是否填写
    if(!self.competencyNumber && self.data.QCertificateNo.length==0){
        [super showToastHUD:@"请填写资格号" hideTime:2.0f];
        return;
    }
    //判断银行卡号是否填写
    if(!self.bankCard && self.data.BankNo.length==0){
        [super showToastHUD:@"请填写银行卡号" hideTime:2.0f];
        return;
    }
    DBManager * dbManager = [DBManager sharedInstance];
    Individual  * individual =  [dbManager selectIndividual];
    
        if(!self.frontImageId){
            [super showToastHUD:@"请上传身份证正面" hideTime:2.0f];
            return;
        }else if(!self.versoImageId ){
            [super showToastHUD:@"请上传身份反面" hideTime:2.0f];
            return;
        }else if(!self.credentialsImageId   ){
            [super showToastHUD:@"请上传资格证内页" hideTime:2.0f];
            return;
        }
    

    NSString *Id = individual.individualId;
    NSString *name = [self  inputText: self.truthName  dataText:self.data.Name];
    NSString *idCardNo = [self inputText:self.idCard dataText:self.data.IdCardNo];
    NSString *qCertificateNo = [self inputText: self.competencyNumber dataText:self.data.QCertificateNo];
    NSString *bankNo = [self inputText: self.bankCard dataText:self.data.BankNo];
    NSString *idCardNoPhoto1 = self.frontImageId;
    NSString *idCardNoPhoto2 = self.versoImageId;
    NSString *qCertificatePhoto = self.credentialsImageId;
    
    //调用 实名认证的接口
    [self.HTTPManagerInstance RealNameAuthWithId:Id name:name idCardNo:idCardNo qCertificateNo:qCertificateNo bankNo:bankNo idCardNoPhoto1:idCardNoPhoto1 idCardNoPhoto2:idCardNoPhoto2 qCertificatePhoto:qCertificatePhoto];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfRealNameAuth = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        if([result.code isEqualToString:@"0"]){
            [super showSuccessHUD:@"提交审核成功" hideTime:2.0];
            //删除数据
            [dbManager deleteImageData];
            ////跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [temp.navigationController  popViewControllerAnimated:YES];
            });
        }else {
            
        }
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfRealNameAuth = ^(NSError *error){
        
    };
    
}


-(NSString * ) inputText:(NSString * ) inputText   dataText:(NSString * ) dataText
{
    NSString * tempText;
    if(dataText!=nil && inputText!=nil){
         tempText=  inputText;
    }else if(inputText==nil && dataText!=nil){
        tempText= dataText ;
    }else if(inputText!=nil && dataText ==nil){
        tempText=  inputText;
    }
    return  tempText;
}



/**
 *  同意
 */
-(AgreeView *)  agreeView
{
    if(!_agreeView){
        AgreeView * agreeView =   [[[NSBundle  mainBundle] loadNibNamed:@"AgreeView" owner:nil options:nil] lastObject];
        self.agreeView = agreeView;
    }
    
    return  _agreeView;
}

/**
 *  右侧按钮
 */
-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}


/**
 *   左侧item按钮
 */
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

#pragma mark - back
-(void) back
{
    /**
     *  返回的时候对清空
     */
    self.truthName = nil;
    self.bankCard =nil;
    self.idCard =nil;
    self.competencyNumber = nil;
    self.frontImageId = nil;
    self.frontImage = nil;
    self.versoImageId = nil;
    self.versoImage = nil;
    self.credentialsImage = nil;
    self.credentialsImageId = nil;
    [self.navigationController  popViewControllerAnimated:YES];
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.authenticationTableView.scrollEnabled = NO;
    self.authenticationTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.authenticationTableView setTableFooterView: self.agreeView] ;
    [self.agreeView serveArticleaddTarget: self action:@selector(serveArticleaddTarget)];
    [self.agreeView  agreeArticleaddTarget:self action:@selector(agreeArticleaddTarget)];
    self.view.backgroundColor =ColorFromRGB(243, 244, 245);
    self.authenticationTableView.backgroundColor = ColorFromRGB(243, 244, 245);
}

@end
