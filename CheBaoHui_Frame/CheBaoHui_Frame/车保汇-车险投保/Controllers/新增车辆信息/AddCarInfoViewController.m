//
//  AddCarInfoViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AddCarInfoViewController.h"
#import "AddCarSectionModel.h"

#import "AddCarInfoViewCell.h"
#import "AddCarInfoPhotoView.h"
#import "UIView+Extension.h"
#import "AddCarModel.h"
#import "AddCarSectionModel.h"
#import "IdentityCardViewCell.h"
#import "SubmitViewCell.h"
#import "DrivingLicenseCell.h"
#import "UIImage+Extension.h"
#import "UIBarButtonItem+Extension.h"



@interface AddCarInfoViewController ()<AddCarInfoViewCellDelegate,
    DrivingLicenseCellDelegate,IdentityCardCellViewCellDelegate,KevinBaseControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *carInfoTableView;


@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/



/**
 *  用来做弹出层的view
 */
@property (nonatomic , strong) UIView * windowView;


/**
 *  用来接收代理传回来的参数
 */

@property (nonatomic , assign) NSInteger  registerdateType;

@property (nonatomic , assign) NSInteger  compulsoryInsuranceType;

@property (nonatomic , assign) NSInteger  commercialInsuranceType;


/**
 *  用来接收代理传回来的参数
 */
@property (nonatomic , copy) NSString  * registerDateStr;

@property(nonatomic , copy) NSString * compulsoryInsuranceDateStr;

@property (nonatomic , copy) NSString * commercialInsuranceDateStr;

/**
 *  用来接收上传的时候回传的id和图片
 */
//身份证正面图片id
@property (nonatomic , copy) NSString *  idCardPositiveId;
//身份证反面图片id
@property (nonatomic ,copy) NSString * idCardReverseId;
//身份证正面图片
@property (nonatomic , copy) NSString * idCardPositiveImageUrl;
//身份证反面图片
@property (nonatomic , copy)  NSString * idCardReverseImageUrl;

//行驶证正面图片id
@property (nonatomic , copy) NSString * dlPositiveId;
//行驶证反面图片id
@property (nonatomic , copy) NSString * dlReverseId;

//身份证正面图片
@property (nonatomic , copy) NSString * dlPositiveImageUrl;
//身份证反面图片
@property (nonatomic , copy)  NSString * dlReverseImageUrl;


/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;




@end

@implementation AddCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carInfoTableView.bounces = NO;
    self.carInfoTableView.backgroundColor = ColorFromRGB(243, 244, 245);
    //[self.carInfoTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
  
    self.carInfoTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    //self.carInfoTableView.tableFooterView = submitView;
    
    self.navigationItem.leftBarButtonItem = self.leftItemBar;
    
    [self setupSections];
}


-(void) setupSections
{
    self.sectionArray = nil;
    AddCarModel * plateNumber = [[AddCarModel alloc] init];
    plateNumber.leftText = @"车辆车牌";
    plateNumber.rangeName = @"渝";
    plateNumber.downImage = @"home_area_down";
    plateNumber.textFiled =  [[UITextField alloc] init];
    plateNumber.accessoryType = AddCarAccessoryTypeHasRangeAndDownImage;
    plateNumber.placeholderText = @"仅支持私家车";
    
    AddCarModel * carframeNumber = [[AddCarModel alloc] init];
    carframeNumber.leftText = @"车架号码";
    carframeNumber.textFiled =  [[UITextField alloc] init];
    carframeNumber.placeholderText = @"请输入车架号码";
    
    AddCarModel * brandNumber = [[AddCarModel alloc] init];
    brandNumber.leftText = @"品牌型号";
    brandNumber.textFiled =  [[UITextField alloc] init];
    brandNumber.placeholderText = @"请输入品牌型号";
    
    AddCarModel * engineNumber = [[AddCarModel alloc] init];
    
    engineNumber.leftText = @"发动机号";
    engineNumber.textFiled =  [[UITextField alloc] init];
    engineNumber.placeholderText = @"请输入发动机号";
    
    AddCarModel * registerDate = [[AddCarModel alloc] init];
    registerDate.leftText = @"注册日期";
    registerDate.textFiled =  [[UITextField alloc] init];
    registerDate.accessoryType =  AddCarAccessoryTypeDisclosureIndicator;
    
    registerDate.placeholderText = @"请选择注册日期";
    
    registerDate.accessoryType = AddCarAccessoryTypeDisclosureIndicator;
    registerDate.dateType = DateTypeRegister; //注册时间
    
    AddCarModel *  compulsoryInsuranceDate = [[AddCarModel alloc] init];
    compulsoryInsuranceDate.leftText = [NSString  stringWithFormat:@"交 强  险"];
    compulsoryInsuranceDate.textFiled = [[UITextField alloc] init];
    compulsoryInsuranceDate.accessoryType =  AddCarAccessoryTypeDisclosureIndicator;
    
    compulsoryInsuranceDate.placeholderText = @"请选择交强险到期日期";
    compulsoryInsuranceDate.accessoryType = AddCarAccessoryTypeDisclosureIndicator;
    compulsoryInsuranceDate.dateType =  DateTypeCompulsoryInsurance; //交强险
    
    AddCarModel * commercialInsuranceDate = [[AddCarModel alloc] init];
    commercialInsuranceDate.leftText = [NSString  stringWithFormat:@"商 业  险"];
    commercialInsuranceDate.textFiled = [[UITextField alloc] init];
    commercialInsuranceDate.accessoryType =  AddCarAccessoryTypeDisclosureIndicator;
    
    commercialInsuranceDate.placeholderText = @"请选择商业险到期日期";
    
    commercialInsuranceDate.accessoryType = AddCarAccessoryTypeDisclosureIndicator;
    commercialInsuranceDate.dateType = DateTypeCommercialInsurance; //商业险
    AddCarSectionModel * addCarSection = [[AddCarSectionModel alloc] init];
    
    addCarSection.sectionHeaderHeight = SectionHeaderHeight;
    
    if(self.registerdateType == DateTypeRegister ){
        registerDate.placeholderText = self.registerDateStr;
        
    }
    if(self.compulsoryInsuranceType == DateTypeCompulsoryInsurance){
        compulsoryInsuranceDate.placeholderText = self.compulsoryInsuranceDateStr;
        commercialInsuranceDate.placeholderText = self.commercialInsuranceDateStr;
    }
    if(self.commercialInsuranceType == DateTypeCommercialInsurance){
        commercialInsuranceDate.placeholderText = self.commercialInsuranceDateStr;
    
    }
    
    addCarSection.itemArray = @[plateNumber,carframeNumber,brandNumber,engineNumber,registerDate,compulsoryInsuranceDate,commercialInsuranceDate];
    
    AddCarModel * owner = [[AddCarModel alloc] init];
    owner.leftText = @"车主姓名";
    owner.textFiled = [[UITextField alloc] init];
    owner.placeholderText = @"请输入车主姓名";
    
    AddCarModel * phoneNumber = [[AddCarModel alloc] init];
    phoneNumber.leftText = @"联系电话";
    phoneNumber.textFiled = [[UITextField alloc] init];
    phoneNumber.placeholderText = @"请输入联系电话";
    
    AddCarModel * idCard = [[AddCarModel alloc] init];
    idCard.leftText = @"身份证号";
    idCard.textFiled = [[UITextField alloc] init];
    idCard.placeholderText = @"请输入身份证号";
    
    AddCarSectionModel *   ownerInfo = [[AddCarSectionModel alloc] init];
    ownerInfo.itemArray = @[owner, phoneNumber,idCard];
    ownerInfo.sectionHeaderHeight = SectionHeaderHeight;
    
    AddCarModel *  addcar9 = [[AddCarModel  alloc] init];
    addcar9.leftText = @"车主身份证";
    addcar9.particularText  = @"请按照提示上传身份证";
    addcar9.accessoryType = AddCarAccessoryTypeButton;
    
    if(self.idCardPositiveImageUrl!=nil){
        addcar9.positiveImageUrl = self.idCardPositiveImageUrl;
        addcar9.positive = AddCarModelPositiveType;
    }else{
        addcar9.positiveImageUrl = @"car_identity_photo_positive";
    }
    
    if(self.idCardReverseImageUrl !=nil){
        addcar9.reverseImageUrl = self.idCardReverseImageUrl;
        addcar9.reverse = AddCarModelReverseType;
        
    }else{
        addcar9.reverseImageUrl = @"car_identity_photo_reverse";
    }
    addcar9.cardType = CardTypeIdCard;
    
    
    AddCarSectionModel * addCarSectionButton = [[AddCarSectionModel alloc] init];
    addCarSectionButton.itemArray = @[addcar9];
    addCarSectionButton.sectionHeaderHeight = SectionHeaderHeight;
    AddCarModel *  addcar10 = [[AddCarModel  alloc] init];
    addcar10.leftText = @"车辆行驶证";
    addcar10.accessoryType = AddCarAccessoryTypeButton;
    
    if(self.dlPositiveImageUrl!=nil){
        addcar10.positiveImageUrl = self.dlPositiveImageUrl;
        addcar10.positive = AddCarModelPositiveType;
        
    }else{
        addcar10.positiveImageUrl = @"car_identity_photo_positive";
    }
    if(self.dlReverseImageUrl !=nil){
        addcar10.reverseImageUrl = self.dlReverseImageUrl;
        addcar10.reverse = AddCarModelReverseType;
        
    }else{
        addcar10.reverseImageUrl =@"car_identity_photo_reverse";
    }
    addcar10.cardType = CardTypeDrivingLicense;
    
    AddCarSectionModel * addCarSectionButton1 = [[AddCarSectionModel alloc] init];
    addCarSectionButton1.sectionHeaderHeight = SectionHeaderHeight;
    addCarSectionButton1.itemArray = @[addcar10];
    
    AddCarModel * submit = [[AddCarModel alloc] init];
    submit.accessoryType = AddCarAccessoryTypeSubmitButton;
    AddCarSectionModel * addSubmitSectioin = [[AddCarSectionModel alloc] init];
    addSubmitSectioin.itemArray = @[submit];
    self.sectionArray  = @[addCarSection,ownerInfo,addCarSectionButton,addCarSectionButton1,addSubmitSectioin];

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     AddCarSectionModel * sectionModel =  self.sectionArray [section];
    return  sectionModel.itemArray.count;
}


-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取组
    AddCarSectionModel * sectionModel = self.sectionArray[indexPath.section];
    //得到组中的item
    AddCarModel *  addCarItem = sectionModel.itemArray[indexPath.row];
    if(addCarItem.accessoryType == AddCarAccessoryTypeButton){
        if(addCarItem.cardType == CardTypeIdCard){
            IdentityCardViewCell * identityCardViewCell = [IdentityCardViewCell  cellWithTableView:tableView];
            identityCardViewCell.delegate = self;
            identityCardViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            identityCardViewCell.addCarItem =  addCarItem;
            return identityCardViewCell;
        }else if(addCarItem.cardType == CardTypeDrivingLicense){
            DrivingLicenseCell *  drivingLicenseCell = [DrivingLicenseCell cellWithTableView:tableView];
            drivingLicenseCell.delegate = self;
            drivingLicenseCell.addCarItem = addCarItem;
            return  drivingLicenseCell;
        }
    }else if (addCarItem.accessoryType == AddCarAccessoryTypeSubmitButton){
        SubmitViewCell * submitCell = [SubmitViewCell cellWithTableView:tableView ];
        return  submitCell;
    }else{
        //id
        static  NSString *  ID = @"ID";
        AddCarInfoViewCell*  cell =  [tableView dequeueReusableCellWithIdentifier: ID];
        if(!cell){
            cell = [[AddCarInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
            cell.delegate = self;
        }
        //设置选中cell的时候选中为none
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.item =  addCarItem;
        return cell;
    }
    return  nil;
}


-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AddCarSectionModel * sectionModel = self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddCarSectionModel * sectionModel = self.sectionArray[indexPath.section];
    AddCarModel * addcar =  sectionModel.itemArray[indexPath.row];
    if (addcar.accessoryType ==AddCarAccessoryTypeButton) {
        return 150;
    }else if(addcar.accessoryType == AddCarAccessoryTypeSubmitButton){
        return  80;
    }
    return  44;
}

#pragma  mark  AddCarInfoViewCellDelegate
-(void)addCarInfoViewShowPickerDateWithTitle:(NSString *)title withTag:(NSInteger)tag
{
    
    if(tag == DateTypeCompulsoryInsurance){
        title = [NSString stringWithFormat:@"交强险/商业险"];
    }
    
    SelectDateView *selectDateView = (SelectDateView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectDateView" owner:nil options:nil] firstObject];
    
    //设置显示位置
    CGFloat height = selectDateView.bounds.size.height;
    CGRect frame ;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height - height;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = height;
    selectDateView.frame = frame;
    
    //设置初始值
    [selectDateView setOriginalViewWithDateString:title];
    
    [self.view addSubview:selectDateView];
    __weak __typeof(self) weakself = self;
    selectDateView.passDate = ^(NSString * selectedDate){
        if(tag == DateTypeRegister){
            weakself.registerdateType = tag;
            weakself.registerDateStr = selectedDate;
        }else if(tag == DateTypeCompulsoryInsurance){
            weakself.compulsoryInsuranceType = tag;
            weakself.compulsoryInsuranceDateStr = selectedDate;
            weakself.commercialInsuranceDateStr = selectedDate;
        }else{
            weakself.commercialInsuranceType = tag;
            weakself.commercialInsuranceDateStr = selectedDate;
        }
        [weakself setupSections];
        [weakself.carInfoTableView  reloadData ];
    };
}

#pragma  mark IdentityCardCellViewCellDelegate
-(void)identityCardViewCellWithTagType:(IdentityCardTagType)tagType
{
    KevinBaseController *kevinBase = (KevinBaseController *)self;
    kevinBase.imageFromType = ImageFromTypeAddCar;
    kevinBase.delegate = self;
    switch (tagType) {
        case IdentityCardTagTypePositive:{
             //正面
            kevinBase.prTtype =IdentityCardTagTypePositive;
        }break;
        case IdentityCardTagTypereverse :{
            //反面
            kevinBase.prTtype =IdentityCardTagTypereverse;
        }break;
        default:
            break;
    }
    //调用显示照片来源
    [kevinBase callCameraOrPhotoLibary];
    kevinBase.baseType =KevinBaseTypeIDCard;
}


#pragma  mark DrivingLicenseCellDelegate
-(void)drivingLicenseCellWithTagType:(DrivingLicenseTagType)tagType
{
    KevinBaseController *kevinBase = (KevinBaseController *)self;
    kevinBase.delegate = self;
    switch (tagType) {
        case DrivingLicenseTagTypePositive:{
            //正面
            kevinBase.prTtype =DrivingLicenseTagTypePositive;
        }break;
        case DrivingLicenseTagTypereverse :{
            //反面
            kevinBase.prTtype =DrivingLicenseTagTypereverse;
        }break;
        default:
            break;
    }
    //调用显示照片来源
    [kevinBase callCameraOrPhotoLibary];
    kevinBase.baseType =KevinBaseTypeDrivingLicense;
    
}


-(void) idCardCallback:(NSString *)url type:(PositiveWithReverseType)type photoId:(NSString *)photoId
{
    switch (type) {
        case PositiveType:{
            self.idCardPositiveId = photoId;
            self.idCardPositiveImageUrl = url;
        }break;
        case ReverseType :{
            self.idCardReverseId = photoId;
            self.idCardReverseImageUrl = url;
        }break;
    }
    [self setupSections];
    [self.carInfoTableView reloadData];
}

-(void) dlCallback:(NSString *)url type:(PositiveWithReverseType)type photoId:(NSString *)photoId
{
    switch (type) {
        case PositiveType:{
            self.dlPositiveId = photoId;
            self.dlPositiveImageUrl =  url;
        }break;
        case ReverseType :{
            self.dlReverseId = photoId;
            self.dlReverseImageUrl =  url;
        }break;
    }
    [self setupSections];
    [self.carInfoTableView reloadData];
    
}

-(void) back
{
    [self.navigationController  popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//左侧按钮
-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}




- (void)viewWillDisappear: (BOOL)animated
{
    [super  viewWillDisappear:animated];
    [self.navigationController  setNavigationBarHidden: NO animated:NO];

}

@end
