//
//  ConfirmNoteTableViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ConfirmNoteTableViewController.h"

#import "DateCell.h"
#import "PhoneCell.h"
#import "FrameCell.h"

#import "PersonCell.h"
#import "PersonDetailCell.h"

#import "DetailAboutBillTableViewController.h"
#import "CarInfoTableViewController.h"
#import "KevinBaseController.h"

#import "InsureHeadView.h"

#import "CarInfo.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import "AliPayManager.h"

#import "WeChatPayManager.h"

#import "RadioButton.h"

#import "CarOwnerModel.h"
#import "CreatePolicy.h"
#import "WarrantyModel.h"

#import "UIView+Extension.h"
#import "UIImage+Extension.h"

#import "GiFHUD.h"
#import "VerifyUitl.h"


#define selectedBtnOriginalTagValue 100
#define phoneAndNameTextFieldOriginalTagValue 101

#define pickDateBtnOriginalTagValue 103
#define zhengmianBtnOriginalTagValueFlag 104
#define fanmianBtnOriginalTagValueFlag 105


/**
 *  规定传送方式
 */
typedef NS_ENUM(NSInteger, DeliverType) {
    /**
     *  现领模式
     */
    DeliverWay_Self = 0,
    /**
     *  代领
     */
    DeliverWay_DaiLing,
    /**
     *  快递
     */
    DeliverWay_KuaiDi
};


@interface ConfirmNoteTableViewController ()<UITextFieldDelegate>


/**
 *  投保人即车主数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_CarOwner;

/**
 *  投保人即投诉人数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_Complainant;

/**
 *  交险日期数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_InsuranceDate;

/**
 *  存储关于投保人详情的实例
 */
@property(nonatomic,strong) CarOwnerModel *carOwner;
@property(nonatomic,strong) CarOwnerModel *complainant;

/**
 *  核保传值时要用的实例
 */
@property(nonatomic,strong) CreatePolicy *createPolicy;


/**
 *  投保人相关数据 分临时和实际
 */
@property(nonatomic,strong) NSMutableArray *tempMutableArray_AboutPerson;
@property(nonatomic,strong) NSMutableArray *factMutableArray_AboutPerson;


/**
 *  carInfo临时存储
 */
@property(nonatomic,strong) CarInfo *tempCarInfo;


/**
 *  totalPrice临时存储
 */
@property(nonatomic,assign) CGFloat tempTotalPrice;


/**
 *  priceDetail临时存储
 */
@property(nonatomic,strong) PriceDetail *tempPriceDetail;


/**
 *  关于投保方案的详细情况的暂存值
 */
@property(nonatomic,strong) NSArray *tempArrayAboutInsuranceInfo;

/**
 *  控制section的数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_Section;


/**
 *  核保成功后，生成的保单号
 */
@property(nonatomic,strong) NSString *cntr_id;


/**
 *  支付生成成功后，返回的预支付订单号
 */
@property(nonatomic,strong) NSString *prepayid;

/**
 *  支付生成成功后，返回的二维码URL
 */
@property(nonatomic,strong) NSString *erWeiMaURL;


@property (nonatomic , strong) KevinBaseController * kevinBaseController;

/**
 *  头view
 */
@property (nonatomic  , strong) InsureHeadView *  insureHeadView;


/**
 *  车主身份证号
 */
@property(nonatomic,strong) NSString *insured_idno;

/**
 *  投诉人身份证号
 */
@property(nonatomic,strong) NSString *holder_idno;

/**
 *  隐藏键盘管理者 实例
 */
@property(nonatomic,strong) IQKeyboardReturnKeyHandler *returnKeyHandler;


@property(nonatomic,strong) NSString *phone_Number;
@property(nonatomic,strong) NSString * cz_sf1_id;
@property(nonatomic,strong) NSString *cz_sf2_id;
@property(nonatomic,strong) NSString *xs1_id;
@property(nonatomic,strong) NSString *xs2_id;


/**
 *  加载中的 动画显示
 */
@property(nonatomic,strong) GSIndeterminateProgressView *progressView;

@end


/**
 *  cell重用标识符
 */
static NSString *cellIdentifier = @"cell";
static NSString *dateCellIdentifier = @"dateCell";
static NSString *phoneCellIdentifier = @"phoneCell";
static NSString *frameCellIdentifier = @"frameCell";

//投保人详情
static NSString *personFirstSectionCellIdentifier = @"personFirstSectionCell";
static NSString *personSecondSectionCellIdentifier = @"personSecondSectionCell";

static NSString *personFirstSectionDetailCellIdentifier = @"personFirstSectionDetailCellIdentifier";
static NSString *personSecondSectionDetailCellIdentifier = @"personSecondSectionDetailCellIdentifier";

/**
 *  存储身份证号
 */
NSString *sfzNumber;

@implementation ConfirmNoteTableViewController


#pragma mark -- 视图加载完后 所要进行的一些操作
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新tableView
    [self.tableView reloadData];
    
}




#pragma mark -- 设定初始值
-(void)setOriginalValueForView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.title = @"确认保单";
    
    //禁止回弹
    self.tableView.bounces = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 数据绑定
-(void)bindData{
    
    //先清除数据源,防止多次加载数据
    [self.mutableArray_Section removeAllObjects];
    [self.mutableArray_CarOwner removeAllObjects];
    [self.mutableArray_Complainant removeAllObjects];
    [self.mutableArray_InsuranceDate removeAllObjects];
    
    //初始化section数据源
    self.mutableArray_Section = [NSMutableArray arrayWithCapacity:10];
    
    
    //数据绑定
    [self.mutableArray_CarOwner addObject:@"被保人即车主"];
    if (YES == self.carOwner.isShowCarOwner) {
        
        [self.mutableArray_CarOwner addObject:_carOwner];
    }
    
    //添加被保人即车主section
    [self.mutableArray_Section addObject:_mutableArray_CarOwner];
    [self.mutableArray_Complainant addObject:@"被保人即投保人"];
    
    if (YES == self.complainant.isShowComplainant) {
        
        [self.mutableArray_Complainant addObject:_carOwner];
    }
    
    //添加被保人即投诉人section
    [self.mutableArray_Section addObject:_mutableArray_Complainant];
    
    [self.mutableArray_InsuranceDate addObject:@"交强险起保日期"];
    [self.mutableArray_InsuranceDate addObject:@"商业险起保日期"];
    
    //添加加险section
    [self.mutableArray_Section addObject:_mutableArray_InsuranceDate];
    
    
    [self.factMutableArray_AboutPerson addObject:@"投保人即车主"];
    [self.factMutableArray_AboutPerson addObject:@"投保人即投保人"];
    [self.factMutableArray_AboutPerson addObject:@""];
    
    [self.tempMutableArray_AboutPerson addObjectsFromArray:_factMutableArray_AboutPerson];
    
    //添加车辆信息section
    [self.mutableArray_Section addObject:@""];
    
}


#pragma mark -- 从plist文件中得到数据
-(NSArray *)dataFromPlistFile:(NSString *)filePath{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    return array;
}


#pragma mark -- 注册Cell
-(void)registerCell{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DateCell" bundle:nil] forCellReuseIdentifier:dateCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhoneCell" bundle:nil] forCellReuseIdentifier:phoneCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FrameCell" bundle:nil] forCellReuseIdentifier:frameCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:personFirstSectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:personSecondSectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonDetailCell" bundle:nil] forCellReuseIdentifier:personFirstSectionDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonDetailCell" bundle:nil] forCellReuseIdentifier:personSecondSectionDetailCellIdentifier];
}

#pragma mark -- Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutableArray_Section.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section ) {
        return self.mutableArray_CarOwner.count;
    }else if(1 == section){
        return self.mutableArray_Complainant.count;
    }else if (2 == section){
        return self.mutableArray_InsuranceDate.count;
    }
    else if ((self.mutableArray_Section.count - 1) == section ){
        return 2;
    }
    else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //被保人即车主
    
    if (0 == indexPath.section){
        if (0 == indexPath.row) {
            
            PersonCell *personCell = [tableView dequeueReusableCellWithIdentifier:personFirstSectionCellIdentifier forIndexPath:indexPath];
            
            [personCell setNameForViewWithSting:self.mutableArray_CarOwner[indexPath.row]];
            
            personCell.selectBtn.tag = indexPath.row + selectedBtnOriginalTagValue * indexPath.section;
            [personCell.selectBtn addTarget:self action:@selector(selectDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.carOwner.isShowCarOwner) {
                [personCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"check_box_checked.png"] forState:UIControlStateNormal];
            }else{
                [personCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"check_box_normal.png"] forState:UIControlStateNormal];
            }
            
            return personCell;
        }else{
            PersonDetailCell *personDetailCell = [tableView dequeueReusableCellWithIdentifier:personFirstSectionDetailCellIdentifier forIndexPath:indexPath];
            
            CarOwnerModel *carOwnerModel = [CarOwnerModel new];
            carOwnerModel.name = @"车主";
            
            [personDetailCell.zhengMianBtn addTarget:self action:@selector(callPhotoCarOwner:) forControlEvents:UIControlEventTouchUpInside];
            personDetailCell.zhengMianBtn.tag = zhengmianBtnOriginalTagValueFlag * indexPath.section + zhengmianBtnOriginalTagValueFlag;
            
            [personDetailCell.fanMianBtn addTarget:self action:@selector(callPhotoCarOwner:) forControlEvents:UIControlEventTouchUpInside];
            personDetailCell.fanMianBtn.tag = fanmianBtnOriginalTagValueFlag * indexPath.section + fanmianBtnOriginalTagValueFlag;
            
            personDetailCell.nameTextField.tag = phoneAndNameTextFieldOriginalTagValue * indexPath.section + indexPath.row;
            personDetailCell.phoneTextField.tag = phoneAndNameTextFieldOriginalTagValue * indexPath.section + indexPath.row;
            
            personDetailCell.phoneTextField.delegate = self;
            personDetailCell.nameTextField.delegate = self;
            
            personDetailCell.nameTextField.text = self.tempCarInfo.cz_name == nil ? @"" : _tempCarInfo.cz_name;
            personDetailCell.phoneTextField.text = self.tempCarInfo.Cz_phone == nil ? @"" : _tempCarInfo.Cz_phone;
            self.carOwner.name = personDetailCell.nameTextField.text;
            self.carOwner.phone = personDetailCell.phoneTextField.text;
            
            return personDetailCell;
        }
    }
    else if (1 == indexPath.section){
        if (0 == indexPath.row) {
            PersonCell *personCell = [tableView dequeueReusableCellWithIdentifier:personSecondSectionCellIdentifier forIndexPath:indexPath];
            
            [personCell setNameForViewWithSting:self.mutableArray_Complainant[indexPath.row]];
            personCell.selectBtn.tag = indexPath.row + selectedBtnOriginalTagValue * indexPath.section;
            
            [personCell.selectBtn addTarget:self action:@selector(selectDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.complainant.isShowComplainant) {
                [personCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"check_box_checked.png"] forState:UIControlStateNormal];
            }else{
                [personCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"check_box_normal.png"] forState:UIControlStateNormal];
            }
            
            return personCell;
        }else{
            PersonDetailCell *personDetailCell = [tableView dequeueReusableCellWithIdentifier:personSecondSectionDetailCellIdentifier forIndexPath:indexPath];
            [personDetailCell.zhengMianBtn addTarget:self action:@selector(callPhotoComplainant:) forControlEvents:UIControlEventTouchUpInside];
            personDetailCell.zhengMianBtn.tag = zhengmianBtnOriginalTagValueFlag * indexPath.section + zhengmianBtnOriginalTagValueFlag;
            
            [personDetailCell.fanMianBtn addTarget:self action:@selector(callPhotoComplainant:) forControlEvents:UIControlEventTouchUpInside];
            personDetailCell.fanMianBtn.tag = fanmianBtnOriginalTagValueFlag * indexPath.section + fanmianBtnOriginalTagValueFlag;
            
            personDetailCell.nameTextField.tag = phoneAndNameTextFieldOriginalTagValue * indexPath.section + indexPath.row;
            personDetailCell.phoneTextField.tag = phoneAndNameTextFieldOriginalTagValue * indexPath.section + indexPath.row;
            
            personDetailCell.phoneTextField.delegate = self;
            personDetailCell.nameTextField.delegate = self;
            personDetailCell.nameTextField.text = self.tempCarInfo.cz_name == nil ? @"" : _tempCarInfo.cz_name;
            personDetailCell.phoneTextField.text = self.tempCarInfo.Cz_phone == nil ? @"" : _tempCarInfo.Cz_phone;
            self.complainant.name = personDetailCell.nameTextField.text;
            self.complainant.phone = personDetailCell.phoneTextField.text;
            
            return personDetailCell;
        }
    }
    else if (2 == indexPath.section){
        //交强险/商业险
        DateCell *dateCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier forIndexPath:indexPath];
        dateCell.InsuranceNameLabel.text = self.mutableArray_InsuranceDate[indexPath.row];
        [dateCell.pickDateBtn setTitle:[_tempPriceDetail.insuranceBeginTime substringToIndex:10] forState:UIControlStateNormal];
        dateCell.pickDateBtn.tag = pickDateBtnOriginalTagValue * indexPath.section + indexPath.row;
        [dateCell.pickDateBtn addTarget:self action:@selector(pickDateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return dateCell;
    }
    //车辆信息
    else{
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"车辆信息";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            PhoneCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:phoneCellIdentifier forIndexPath:indexPath];
            phoneCell.nameLabel.text = self.tempCarInfo.cz_name;
            
            [phoneCell.callBtn addTarget:self action:@selector(callPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
            
            return phoneCell;
        }
    }
}

#pragma mark -- 选择日期
-(void)pickDateBtnAction:(UIButton *)sender{
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    SelectDateView *selectDateView = (SelectDateView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectDateView" owner:nil options:nil] firstObject];
    
    //设置显示位置
    CGFloat height = selectDateView.bounds.size.height + 100;
    CGRect frame ;
    frame.origin.x = 0;
    frame.origin.y = kUIScreenHeight - height;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = height;
    selectDateView.frame = frame;
    
    //设置初始值
    [selectDateView setOriginalViewWithDateString:sender.titleLabel.text];
    
    [self.view addSubview:selectDateView];
    
    //当前日期
    NSString *currentDate = sender.titleLabel.text;
    
    //sender所在的row值
    NSInteger row = sender.tag % pickDateBtnOriginalTagValue;
    
    //回调，得到选择日期
    selectDateView.passDate = ^(NSString *date){
        //判断，若是跟当前日期不一致，则换日期
        if (date != currentDate) {
            [sender setTitle:date forState:UIControlStateNormal];
            if (0 == row) {
                self.createPolicy.jqxbegintime = date;
                self.tempCarInfo.JQXTime = date;
            }else{
                self.createPolicy.syxbegintime = date;
                self.tempCarInfo.SYXTime = date;
            }
        }
    };
}

#pragma  mark  --被保人即车主 上传图片
//被保人即车主
-(void) callPhotoCarOwner:(UIButton * ) sender
{
    [self callCameraOrPhotoLiberyWithButton: sender type:CarOwnerType];
    
}

#pragma mark -- 被保人即投诉人    上传图片
-(void)callPhotoComplainant:(UIButton *)sender
{
    [self callCameraOrPhotoLiberyWithButton: sender type:ComplainantType];
}


#pragma mark -- 调起相册,上传图片
-(void) callCameraOrPhotoLiberyWithButton:(UIButton * ) sender   type:(CarOwnerWithComplainantType) type
{
    
    self.kevinBaseController.carOwnerWithComplainateType =  type;
    self.kevinBaseController.photoType = sender.tag;
    [self.view addSubview:self.kevinBaseController.view];
    [self.kevinBaseController callCameraOrPhotoLibary];
    
    __weak typeof(self.kevinBaseController) tempKevinBase = self.kevinBaseController;
    __weak typeof(self) temp = self;
    
    self.kevinBaseController.confirmListCallBlock = ^(NSString * url, CarOwnerWithComplainantType type, PhotoType  photoType, NSString * photoId){
        
        if(photoType % zhengmianBtnOriginalTagValueFlag == 0){ //正面
            //车主身份证正面照id
            if (type == CarOwnerType) {
                temp.carOwner.frontalViewId = photoId;
            }else{
                //投诉人...id
                temp.complainant.frontalViewId = photoId;
            }
            
            NSURL * nsUrl = [NSURL URLWithString: url];
            [[SDWebImageManager  sharedManager] downloadImageWithURL:nsUrl options:0 progress:nil completed:^(UIImage *image, NSError *error,  SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [sender setImage: [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
            }];
            
            
        }else{ //反面
            //车主身份证正面照id
            if (type == CarOwnerType) {
                temp.carOwner.negativeViewId = photoId;
            }else{
                //投诉人...id
                temp.complainant.negativeViewId = photoId;
            }
            
            NSURL * nsUrl = [NSURL URLWithString: url];
            [[SDWebImageManager  sharedManager] downloadImageWithURL:nsUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                [sender setImage: [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
            }];
            
        }
        [tempKevinBase.view removeFromSuperview];
        
    };
    [self.tableView  reloadData];
    self.kevinBaseController.removeKevinBaseView = ^(){
        [tempKevinBase.view  removeFromSuperview];
    };
    
    
}



#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self saveInfo:textField];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ---
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self saveInfo:textField];
    
    [textField resignFirstResponder];
    
}

#pragma mark --- 记录输入的车主电话号码
-(void)saveInfo:(UITextField *)textField{
    NSInteger section = textField.tag / phoneAndNameTextFieldOriginalTagValue;
    NSInteger row = textField.tag % phoneAndNameTextFieldOriginalTagValue;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    PersonDetailCell *detailCell = (PersonDetailCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //记录 电话
    if (textField == detailCell.phoneTextField) {
        
        NSString *phoneNumber = detailCell.phoneTextField.text;
        
        //电话号码只能11位
        if ([VerifyUitl isValidateMobile:detailCell.phoneTextField.text]) {
            [[JJBaseController new] showFailureHUD:@"请输入正确的电话号码" hideTime:0.2];
            return;
        }
        
        if (0 == section) {
            //记录被保人即车主 电话
            
            self.carOwner.phone = phoneNumber;
            self.tempCarInfo.Cz_phone = self.carOwner.phone;
        }else{
            //否则，记录的是被保人即投诉人 电话
            self.complainant.phone = phoneNumber;
        }
    }
    else{
        //否则，记录的是 姓名
        
        NSString *name = detailCell.nameTextField.text;
        
        NSString *regex = @"[\u4e00-\u9fa5]+";
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        //如果输入的文字不是汉字,则提醒
        if (![pred evaluateWithObject:name]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"只能输入中文" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                textField.clearsOnBeginEditing = YES;
                [textField becomeFirstResponder];
            }];
            [alertController addAction:confirm];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        if (0 == section) {
            //记录被保人即车主 姓名
            self.carOwner.name = name;
            self.tempCarInfo.cz_name = self.carOwner.name;
        }else{
            //被保人即投诉人 姓名
            
            self.complainant.name = name;
        }
    }
    
}

#pragma mark -- 打电话
-(void)callPhoneNumber:(UIButton *)sender{
    NSURL *phoneURL;
    if (self.tempCarInfo.Cz_phone.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请在车辆信息里补充车主电话" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //把光标移到填写之处
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:confirm];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        
        self.tempCarInfo.Cz_phone = [self.tempCarInfo.Cz_phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@",self.tempCarInfo.Cz_phone];
        //第一种拨打电话的方式
//        Tel(_tempCarInfo.Cz_phone);
        
        phoneURL = [NSURL URLWithString:phoneNumber];
        
        UIWebView *callWebView = [UIWebView new];
        
        [callWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        
        [self.view addSubview:callWebView];
    }
    
}

#pragma mark -- 显示投保人详细信息
-(void)selectDetail:(UIButton *)sender{
    NSInteger section = sender.tag / selectedBtnOriginalTagValue;
    
    //被保人即车主,取反表示显示输入框还是不显示。
    if (0 == section) {
        self.carOwner.isShowCarOwner = !self.carOwner.isShowCarOwner;
        
    }
    
    //被保人即投诉人
    if (1 == section) {
        self.complainant.isShowComplainant = !self.complainant.isShowComplainant;
    }
    
    //更新数据
    [self bindData];
    
    //刷新页面显示数据
    [self.tableView reloadData];
    
}



#pragma mark -- 续UITableViewDelegate/DataSource
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ((self.mutableArray_Section.count - 1) == section) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.1)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 10, view.bounds.size.width, view.bounds.size.height * 0.8);
        [button setTitle:@"确认投保" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"fm_mine_top_bg"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(confirmPayMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        
        return view;
    }else{
        return nil;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetailInfoPage:)];
        
        [self.insureHeadView addGestureRecognizer:tap];
        
        return self.insureHeadView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ((self.mutableArray_Section.count - 1) == section) {
        return self.view.bounds.size.height * 0.1;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return self.insureHeadView.height;
    }else{
        return 0;
    }
}


#pragma mark -- cell 跳转到 车辆信息界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (3 == indexPath.section) {
        if (0 == indexPath.row) {
            CarInfoTableViewController *carInfoTVC = [CarInfoTableViewController new];
            
            //把车辆信息传递到车辆信息界面
            carInfoTVC.carInfo = self.tempCarInfo;
            
            carInfoTVC.priceDetail = self.tempPriceDetail;
            carInfoTVC.isClickWithShowView  = YES;
            
            carInfoTVC.passValue = ^(NSString *sfz_Number,NSString *phone_Number,NSString * cz_sf1_id,NSString *cz_sf2_id,NSString *xs1_id,NSString *xs2_id){
                sfzNumber = sfz_Number;
                self.tempCarInfo.Idcard_No = sfz_Number;
                self.phone_Number = phone_Number;
                self.tempCarInfo.Cz_phone = _phone_Number;
                self.cz_sf1_id = cz_sf1_id;
                self.cz_sf2_id = cz_sf2_id;
                self.xs1_id = xs1_id;
                self.xs2_id = xs2_id;
            };
            
            
            pushToViewControllerAndTarget(self, CarInfoTableViewController, carInfoTVC);
        }
    }
}


#pragma mark -- headerView的手势响应事件-->跳转到保单详情
-(void)toDetailInfoPage:(UITapGestureRecognizer *)tapGesture{
    DetailAboutBillTableViewController *detailAboutBillTVC = [DetailAboutBillTableViewController new];
    
    //把投保方案情况数组传到保单详情界面
    detailAboutBillTVC.arrayAboutInsuranceInfo = self.tempArrayAboutInsuranceInfo;
    
    //保单号
    detailAboutBillTVC.cntr_id = self.tempCarInfo.cntr_id;
    
    //保险公司
    detailAboutBillTVC.companyName = self.companyName;
    
    //总保价
    detailAboutBillTVC.totalPrice = self.tempTotalPrice;
    
    //投保人
    detailAboutBillTVC.policyHolder = self.carOwner.name;
    
    //被保人
    detailAboutBillTVC.insuredPerson = self.complainant.name;
    
    pushToViewControllerAndTarget(self, DetailAboutBillTableViewController, detailAboutBillTVC);
}

#pragma mark -- 跳转到 确认投保---核保接口
-(void)confirmPayMoney:(UIButton *)sender{
    
    HTTPManager *manager = [HTTPManager sharedHTPPManager];
    
    //查询数据库,得到用户ID
    DBManager *dbManager = [DBManager sharedInstance];
    Individual *individual = [dbManager selectIndividual];
    
    //B端用户id(必填)
    NSString *businessUserId = individual.individualId;
    
    //车牌号(必填)
    NSString *cph_no = self.tempCarInfo.cph_no == nil ? @"" : self.tempCarInfo.cph_no;
    
    //车架号(必填)
    NSString *cjh_no = self.tempCarInfo.cjh_no == nil ? @"" : self.tempCarInfo.cjh_no;
    
    //保险公司代号(必填)
    NSString *company_code;
    if (self.tempPriceDetail.company_code == nil && self.tempPriceDetail.company_code.length == 0) {
        
        company_code = @"0000";
    }else{
        company_code = self.tempPriceDetail.company_code;
    }
    
#warning 这里的核保金额最后要改成总金额
    //总金额(必填)    self.tempTotalPrice
    NSString *amount = [NSString stringWithFormat:@"%.2f",self.tempTotalPrice];
    
    //返回比价的保险id(必填)
    NSString *policyPriceId = self.tempPriceDetail.policyId;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    //交强险开始时间(必填)
    NSString *jqxbegintime = _tempPriceDetail.insuranceBeginTime == nil ? dateStr : _tempPriceDetail.insuranceBeginTime;
    
    //商业险开始时间(必填)
    NSString *syxbegintime = _tempPriceDetail.insuranceBeginTime == nil ? dateStr : _tempPriceDetail.insuranceBeginTime;
    
    //判断被保人/投保人是否输入，没有的话，即为车主
    BOOL insurancediscz = NO;
    
    //被保人姓名
    NSString *insured_name = self.carOwner.name == nil ? @"" : self.carOwner.name;
    
    //被保人电话
    NSString *insured_phone = self.carOwner.phone ? @"" : self.carOwner.phone;
    
    __weak typeof(self) temp = self;
    //被保人身份证号码
    NSString *insured_idno = sfzNumber == nil ? @"" : sfzNumber;
    
    //被保人身份证正面文件Id'
    temp.carOwner.frontalViewId = _cz_sf1_id;
    NSString *insured_sf1_id = temp.carOwner.frontalViewId == nil ? @"" : temp.carOwner.frontalViewId;
    
    //被保人身份证背面文件Id
    temp.carOwner.negativeViewId = _cz_sf2_id;
    NSString *insured_sf2_id = temp.carOwner.negativeViewId == nil ? @"" :temp.carOwner.negativeViewId;
    
    //被保人即投诉人
    BOOL insuredisholder = NO;
    
    //投诉人名称
    NSString *holder_name = temp.complainant.name == nil ? @"" : temp.complainant.name;
    
    //投保人电话
    NSString *holder_phone = temp.complainant.phone == nil ? @"" : temp.complainant.phone;
    
    //投保人身份证号码
    NSString *holder_idno = @"";
    
    //投保人身份证正面id
    temp.complainant.frontalViewId = _cz_sf1_id;
    NSString *holder_sf1_id = temp.complainant.frontalViewId == nil ? @"" : temp.complainant.frontalViewId;
    
    //投保人身份证背面id
    temp.complainant.negativeViewId = _cz_sf2_id;
    NSString *holder_sf2_id = temp.complainant.negativeViewId == nil ? @"" : temp.complainant.negativeViewId;
    
#warning 这里的交强险时间和商业险结束时间 不一定
    //交强险结束日期
    NSString *jqxendtime = temp.tempCarInfo.JQXTime == nil ? @"" : temp.tempCarInfo.JQXTime;
    
    //商业险结束日期
    NSString *syxendtime = temp.tempCarInfo.SYXTime == nil ? @"" : temp.tempCarInfo.SYXTime;
    
    //品牌型号
    NSString *xh_code = temp.tempCarInfo.xh_code == nil ? @"" : temp.tempCarInfo.xh_code;
    
    //发动机号
    NSString *fdj_no = temp.tempCarInfo.fdj_no == nil ? @"" : temp.tempCarInfo.fdj_no;
    
    //购买时间
    NSString *buy_date = temp.tempCarInfo.buy_date == nil ? @"" : temp.tempCarInfo.buy_date;
    
    //车主姓名
    NSString *cz_name = temp.tempCarInfo.cz_name == nil ? @"" : temp.tempCarInfo.cz_name;
    
    
    //车主身份证号码
    NSString *Idcard_No = sfzNumber == nil ? @"" : sfzNumber;
    
    //车主身份证正面id
    NSString *Sf1_Id = temp.carOwner.frontalViewId == nil ? @"" : temp.carOwner.frontalViewId;
    
    //车主身份证背面id
    NSString *SF2_Id = temp.carOwner.negativeViewId == nil ? @"" : temp.carOwner.negativeViewId;
    
    //行驶证号码
    NSString *xsz_xs_code = @"";
    
    //行驶证正面id
    NSString *xs1_path = self.xs1_id == nil ? @"" : self.xs1_id;
    
    //背面id
    NSString *xs2_path = self.xs2_id == nil ? @"" : self.xs2_id;
    
    //配送方式(录入中文，现领，快递等)
    NSString *ps_way = @"";
    
    //收货人名称
    NSString *sdr_name = @"";
    
    //收货人电话
    NSString *sdr_mobile = @"";
    
    //收货人地址
    NSString *sdr_addr = @"";
    
    //核保接口
    [manager confirmInsuranceAccountWithbusinessUserId:businessUserId cph_no:cph_no cjh_no:cjh_no company_code:company_code amount:amount policyPriceId:policyPriceId insurediscz:insurancediscz insured_name:insured_name insured_phone:insured_phone insured_idno:insured_idno insured_sf1_id:insured_sf1_id insured_sf2_id:insured_sf2_id insuredisholder:insuredisholder holder_name:holder_name holder_phone:holder_phone holder_idno:holder_idno holder_sf1_id:holder_sf1_id holder_sf2_id:holder_sf2_id jqxbegintime:jqxbegintime jqxendtime:jqxendtime syxbegintime:syxbegintime syxendtime:syxendtime xh_code:xh_code fdj_no:fdj_no buy_date:buy_date cz_name:cz_name Idcard_No:Idcard_No Sf1_Id:Sf1_Id SF2_Id:SF2_Id xsz_xs_code:xsz_xs_code xs1_path:xs1_path xs2_path:xs2_path ps_way:ps_way sdr_name:sdr_name sdr_mobile:sdr_mobile sdr_addr:sdr_addr];
    
    GSIndeterminateProgressView *progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(sender.bounds.origin.x, sender.titleLabel.center.y + 18 ,
                                                                                                              sender.frame.size.width, 2)];
    self.progressView = progressView;
    progressView.progressTintColor = [UIColor grayColor];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    sender.userInteractionEnabled = NO;
    [sender setTitle:@"加载中" forState:UIControlStateNormal];
    [sender addSubview:progressView];
    
    [progressView startAnimating];
    
    manager.passCntr_id = ^(NSString *cntr_id){
        temp.cntr_id = cntr_id;
        
        //移除加载动画
        [progressView stopAnimating];
        
        [GiFHUD showWithMessage:@"投保成功,请在 车辆投保 查看核保进度!"];
        temp.view.alpha = 0.01;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [GiFHUD dismissBiggerFrame];
            
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"确认投保" forState:UIControlStateNormal];
            
            [temp.navigationController popToRootViewControllerAnimated:YES];
            temp.view.alpha = 1;
        });
    };
    
    
    manager.passNullMsg_CreatePolicy = ^(){
        [GiFHUD showWithMessage:@"不好意思,投保失败,稍后再试"];
        temp.view.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [GiFHUD dismissBiggerFrame];
            
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"确认投保" forState:UIControlStateNormal];
            
            temp.view.alpha = 1;
        });
    };
    
    
    manager.passErrorCreatePolicy = ^(){
        [GiFHUD showWithMessage:@"不好意思,网络繁忙,请稍后再试"];
        temp.view.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [GiFHUD dismissBiggerFrame];
            
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"确认投保" forState:UIControlStateNormal];
            
            temp.view.alpha = 1;
        });
    };
    
}


#pragma mark -- carInfo 的setter方法
-(void)setCarInfo:(CarInfo *)carInfo{
    self.tempCarInfo = carInfo;
    
}
-(void)setTotalPrice:(CGFloat)totalPrice{
    self.tempTotalPrice = totalPrice;
}

-(void)setPriceDetail:(PriceDetail *)priceDetail{
    self.tempPriceDetail = priceDetail;
}



-(void)setArrayAboutInsuranceInfo:(NSArray *)arrayAboutInsuranceInfo{
    self.tempArrayAboutInsuranceInfo = arrayAboutInsuranceInfo;
}

#pragma mark -- 懒加载
#pragma mark  --- 数组
-(NSMutableArray *)mutableArray_CarOwner{
    if (nil == _mutableArray_CarOwner) {
        _mutableArray_CarOwner = [NSMutableArray arrayWithCapacity:5];
    }
    return _mutableArray_CarOwner;
}

-(NSMutableArray *)mutableArray_Complainant{
    if (nil == _mutableArray_Complainant) {
        _mutableArray_Complainant = [NSMutableArray arrayWithCapacity:5];
    }
    return _mutableArray_Complainant;
}

-(NSMutableArray *)mutableArray_InsuranceDate{
    if (nil == _mutableArray_InsuranceDate) {
        _mutableArray_InsuranceDate = [NSMutableArray arrayWithCapacity:5];
    }
    return _mutableArray_InsuranceDate;
}

-(CarOwnerModel *)carOwner{
    if (nil == _carOwner) {
        _carOwner = [CarOwnerModel new];
        NSDictionary *dict = [[self dataFromPlistFile:[[NSBundle mainBundle] pathForResource:@"CarOwner" ofType:@"plist"]] objectAtIndex:0];
        [_carOwner setValuesForKeysWithDictionary:dict];
    }
    return _carOwner;
}

-(CarOwnerModel *)complainant{
    if (nil == _complainant) {
        _complainant = [CarOwnerModel new];
        NSDictionary *dict = [[self dataFromPlistFile:[[NSBundle mainBundle] pathForResource:@"CarOwner" ofType:@"plist"]] objectAtIndex:1];
        [_complainant setValuesForKeysWithDictionary:dict];
    }
    return _complainant;
}

#pragma mark  --- 投保人相关数组
-(NSMutableArray *)tempMutableArray_AboutPerson{
    if (nil == _tempMutableArray_AboutPerson) {
        _tempMutableArray_AboutPerson = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _tempMutableArray_AboutPerson;
}
#pragma mark  --- 实际投保人相关数据
-(NSMutableArray *)factMutableArray_AboutPerson{
    if (nil == _factMutableArray_AboutPerson) {
        _factMutableArray_AboutPerson = [NSMutableArray arrayWithCapacity:10];
    }
    return _factMutableArray_AboutPerson;
}

#pragma mark -- 懒加载
-(KevinBaseController *)kevinBaseController
{
    if(!_kevinBaseController){
        _kevinBaseController = [[KevinBaseController alloc] init];
        _kevinBaseController.delegate = self;
        _kevinBaseController.imageFromType = ImageFromTypeConfirmList;
    }
    return _kevinBaseController;
}


#pragma mark - 确认保单的头视图
-(InsureHeadView *)insureHeadView
{
    if(_insureHeadView==nil){
        InsureHeadView * insureHead = [[[NSBundle mainBundle] loadNibNamed:@"InsureHeadView" owner:nil options:nil] lastObject];
        self.insureHeadView = insureHead;
        
        
        WarrantyModel *  insureaceCompany   =[[WarrantyModel alloc] init];
        insureaceCompany.leftText  = @"保险公司";
        insureaceCompany.rightText = self.companyName;
        
        WarrantyModel *  insureaceMoney   =[[WarrantyModel alloc] init];
        insureaceMoney.leftText  = @"保险金额";
        insureaceMoney.rightText = [NSString stringWithFormat:@"%.2f",self.tempTotalPrice];
        
        NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithObjects:insureaceCompany,insureaceMoney ,nil];
        self.insureHeadView.data = mutableArray;
        
    }
    return  _insureHeadView;
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设定初始值
    [self setOriginalValueForView];
    
    //绑定数据
    [self bindData];
    
    //设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //注册cell
    [self registerCell];
    
    //cell自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

@end
