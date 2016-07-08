//
//  CarInfoTableViewController.m
//  Template_Joker
//
//  Created by Bella on 16/2/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CarInfoTableViewController.h"

#import "CarList.h"
#import "CarInfoBasicCell.h"
#import "CarInfo.h"
#import "UIBarButtonItem+Extension.h"
#import "IdCardWithDrvingLicenseCell.h"
#import "UIView+Extension.h"
#import "InsureFooterView.h"
#import "KevinBaseController.h"
#import "InsureDataModel.h"
#import "ConfirmNoteTableViewController.h"
#import "PolicyListsModel.h"
#import "InsureDataModel.h"
#import "InsureHolderWithInsuredModel.h"
#import "InsureHolderModel.h"

#define valueTextFieldOriginalTagValue 190

@interface CarInfoTableViewController ()<UITextFieldDelegate,InsureFooterViewDelegate>

/**
 *  存储从plist文件中读取的数据
 */
@property(nonatomic,strong) NSMutableArray *carListArray;

/**
 *  第一个区的数据容器
 */
@property(nonatomic,strong) NSMutableArray *firstSectionArray;

/**
 *  第二个区的数据容器
 */
@property(nonatomic,strong) NSMutableArray *secondSectionArray;

/*
 第三个区的数据容器
 */

@property (nonatomic , strong ) NSMutableArray * thirdlySectionArray;


/*
 第四个区的数据容器
 */

@property (nonatomic , strong) NSMutableArray * fourthlySectionArray;


@property (nonatomic , strong) UIBarButtonItem * leftItemBar;


@property (nonatomic , strong) NSString * group;

/**
 *  暂存车辆信息
 */
@property(nonatomic,strong) CarInfo *tempCarInfo;

@property(nonatomic,strong) PriceDetail *tempPriceDetail;

@property(nonatomic,strong) NSArray *values;

@property (nonatomic , strong) InsureFooterView * insureFooterView;

@property (nonatomic , strong) KevinBaseController * kevinBaseController;

@property (nonatomic , assign) CGFloat cellHeight;


@end

/**
 *  cell重用标识符
 */
static NSString *basicCellIdentifier = @"basicCell";
static NSString *SFImageCell = @"SFImageCell";
static NSString *XSImageCell = @"XSImageCell";


/**
 *  存储电话号码的变量
 */
NSString *phone_Number;

/**
 *  身份证号码
 */
NSString *sfz_Number;


@implementation CarInfoTableViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController  setNavigationBarHidden:NO animated:NO];
    self.navigationItem.leftBarButtonItem = self.leftItemBar;
    self.title = @"车辆详情";
    
    //初始化tableView为平滑样式,这样好设置header的高度
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.tableView.bounces = NO;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CarInfoBasicCell" bundle:nil] forCellReuseIdentifier:basicCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"IdCardWithDrvingLicenseCell" bundle:nil] forCellReuseIdentifier:SFImageCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"IdCardWithDrvingLicenseCell" bundle:nil] forCellReuseIdentifier:XSImageCell];
    
    if(self.isClickWithShowView){
        [self.tableView setTableFooterView:self.insureFooterView];
    }
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}


#pragma mark - 加载数据
-(void)loadData{
    
    //得到从plist文件中解析出来的数据
    [self.carListArray addObjectsFromArray:[self getDataFromPlistFile:[[NSBundle mainBundle] pathForResource:@"CarList" ofType:@"plist"]]];
    
    //第一组数据
    for (NSDictionary *dict in [self.carListArray objectAtIndex:0]) {
        CarList *car = [[CarList  alloc]init];
        [car setValuesForKeysWithDictionary:dict];
        [self.firstSectionArray addObject:car];
    }
    
    //第二组数据
    for (NSDictionary *dict in [self.carListArray objectAtIndex:1]) {
        CarList *carList = [[CarList alloc] init];
        [carList setValuesForKeysWithDictionary:dict];
        [self.secondSectionArray addObject:carList];
    }
    
    //第三组数据
    for(NSDictionary * dict in [self.carListArray  objectAtIndex:2]){
        CarList * carList = [[CarList   alloc] init];
        [carList setValuesForKeysWithDictionary:dict];
        [self.thirdlySectionArray addObject:carList];
        
    }
    //第四组数据
    for (NSDictionary * dict in [self.carListArray  objectAtIndex:3]){
        CarList * carList = [[CarList   alloc] init];
        [carList setValuesForKeysWithDictionary:dict];
        [self.fourthlySectionArray addObject:carList];
    }
    
    NSString *jqxBeginTime = self.tempPriceDetail.insuranceBeginTime == nil ? @"null" : [self.tempPriceDetail.insuranceBeginTime substringToIndex:10];
    NSString *syxBeginTime = self.tempPriceDetail.insuranceBeginTime == nil ? @"null" : [self.tempPriceDetail.insuranceBeginTime substringToIndex:10];
    
    NSString *cph_no = self.tempCarInfo.cph_no == nil ? @"" : self.tempCarInfo.cph_no;
    NSString *cjh_no = self.tempCarInfo.cjh_no == nil ? @"" : self.tempCarInfo.cjh_no;
    NSString *xh_code = self.tempCarInfo.xh_code == nil ? @"" : self.tempCarInfo.xh_code;
    NSString *fdj_no = self.tempCarInfo.fdj_no == nil ? @"" : self.tempCarInfo.fdj_no;
    NSString *buy_date = self.tempCarInfo.buy_date == nil ? @"" : [self.tempCarInfo.buy_date substringToIndex:10];
    NSString *cz_Name = self.tempCarInfo.cz_name == nil ? @"" : self.tempCarInfo.cz_name;
    NSString *Idcard_No = self.tempCarInfo.Idcard_No == nil ? @"" : self.tempCarInfo.Idcard_No;
    NSString *cz_phone = self.tempCarInfo.Cz_phone == nil ? @"" : self.tempCarInfo.Cz_phone;
    //设置value的初始值
    
    if(self.isClickWithShowView){
        self.values = @[@[cph_no,cjh_no,xh_code,fdj_no,buy_date,jqxBeginTime,syxBeginTime],@[cz_Name,Idcard_No,cz_phone]];
        
    }else{
        NSString *jqxBeginTime = [self.insureDataModel sx_date] == nil ? @"null" : [self.insureDataModel.sx_date substringToIndex:10];
        NSString *syxBeginTime = self.insureDataModel.sx_date == nil ? @"null" : [self.insureDataModel.sx_date substringToIndex:10];
        NSString *cph_no = self.policyListsModel.cph_no == nil ? @"" : self.policyListsModel.cph_no;
        NSString *cjh_no = self.policyListsModel.cjh_no == nil ? @"" : self.policyListsModel.cjh_no;
        NSString *xh_code = self.policyListsModel.xh_code == nil ? @"" : self.policyListsModel.xh_code;
        NSString *fdj_no = self.policyListsModel.fdj_no == nil ? @"" : self.policyListsModel.fdj_no;
        NSString *buy_date = self.policyListsModel.buy_date == nil ? @"" : [self.policyListsModel.buy_date substringToIndex:10];
        NSString *cz_Name = self.policyListsModel.cz_name == nil ? @"" : self.policyListsModel.cz_name;
        NSString *Idcard_No = self.policyListsModel.Idcard_No == nil ? @"" : self.policyListsModel.Idcard_No;
        NSString * cz_phone = [self.contents objectForKey:@"cz_phone"] ==nil ?@"":[[self.insureDataModel Cntr_Holder] mob1];
        self.values = @[@[cph_no,cjh_no,xh_code,fdj_no,buy_date,jqxBeginTime,syxBeginTime],@[cz_Name,Idcard_No,cz_phone]];
    }
    
}


#pragma mark - 从plist文件中得到数据
-(NSArray *)getDataFromPlistFile:(NSString *)filePath{
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    return array;
}

#pragma mark - receiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.firstSectionArray.count;
    }else if (1 == section){
        return self.secondSectionArray.count;
    }else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CarList *car = [[CarList   alloc] init];
    //第二组数据
    if(indexPath.section ==2){
        IdCardWithDrvingLicenseCell * identityCardView=nil;
        //可以点击
        if(self.isClickWithShowView){
            if(self.tempCarInfo.Sf1_Id_Url.length == 0 && self.tempCarInfo.Sf2_Id_Url.length==0){
                identityCardView = [self tableView:tableView forIndexPath:indexPath positiveImage:@"car_identity_photo_positive" reverseImage:@"car_identity_photo_reverse" labelText:@"车主身份证"];
                //                  identityCardView.positiveUIButton.tag = 1;
                //                  identityCardView.reverseButton.tag = 2;
                //                  [identityCardView.positiveUIButton addTarget:self action:@selector(idCardPositiveWithReverse:) forControlEvents:UIControlEventTouchUpInside];
                //                  [identityCardView.reverseButton addTarget:self action:@selector(idCardPositiveWithReverse:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                identityCardView  = [self tableView:tableView WithImageUrl1: self.tempCarInfo.Sf1_Id_Url  withImageUrl2: self.tempCarInfo.Sf2_Id_Url withCarList: car indexPath: indexPath  labelText:@"车主身份证"];
                
            }
            identityCardView.positiveUIButton.tag = 1;
            identityCardView.reverseButton.tag = 2;
            [identityCardView.positiveUIButton addTarget:self action:@selector(idCardPositiveWithReverse:) forControlEvents:UIControlEventTouchUpInside];
            [identityCardView.reverseButton addTarget:self action:@selector(idCardPositiveWithReverse:) forControlEvents:UIControlEventTouchUpInside];
            
        } else{
            if(self.policyListsModel.Sf1_Id_Url.length==0  && self.policyListsModel.Sf2_Id_Url.length ==0 ){
                identityCardView = [ self  tableView: tableView withIdentifier:SFImageCell indexPath:indexPath labelText:@"车主身份证" imageStr: @"car_identity_photo_positive" imageStr2:@"car_identity_photo_reverse"];
            }else{
                identityCardView  = [self tableView:tableView WithImageUrl1: self.policyListsModel.Sf1_Id_Url  withImageUrl2: self.policyListsModel.Sf2_Id_Url withCarList: car indexPath: indexPath  labelText:@"车主身份证"];
            }
        }
        return  identityCardView;
        
    }else if(indexPath.section ==3){ //第三组
        IdCardWithDrvingLicenseCell*  identityCardView ;
        //可以点击
        if(self.isClickWithShowView){
            //车辆行驶证正面URL等于0
            if(self.tempCarInfo.xs1_pathUrl.length == 0 && self.tempCarInfo.xs2_pathUrl.length==0){
                identityCardView = [self tableView:tableView forIndexPath:indexPath positiveImage:@"car_identity_photo_positive" reverseImage:@"car_identity_photo_reverse" labelText:@"车辆行驶证"];
            }else{
                NSString * positiveImage=  self.tempCarInfo.xs1_pathUrl==nil||self.tempCarInfo.xs1_pathUrl.length==0 ? @"car_identity_photo_positive":  self.tempCarInfo.xs1_pathUrl;
                NSString * reverseImage =  self.tempCarInfo.xs1_pathUrl==nil || self.tempCarInfo.xs2_pathUrl.length==0  ? @"car_identity_photo_reverse": self.tempCarInfo.xs2_pathUrl;
                identityCardView  = [self tableView:tableView WithImageUrl1: positiveImage   withImageUrl2:reverseImage  withCarList: car indexPath: indexPath labelText:@"车辆行驶证"];
            }
            
            identityCardView.positiveUIButton.tag = 1;
            identityCardView.reverseButton.tag = 2;
            [identityCardView.positiveUIButton addTarget:self action:@selector(drvingLicensePositiveWithReverse:) forControlEvents:UIControlEventTouchUpInside];
            [identityCardView.reverseButton addTarget:self action:@selector(drvingLicensePositiveWithReverse:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if(self.policyListsModel.Sf1_Id_Url.length==0  && self.policyListsModel.Sf2_Id_Url.length ==0 ){
                identityCardView = [ self  tableView: tableView withIdentifier:XSImageCell indexPath:indexPath labelText:@"车辆行驶证" imageStr: @"car_identity_photo_positive" imageStr2:@"car_identity_photo_reverse"];
            }else{
                
                NSString * positiveImage=  self.policyListsModel.xs1_pathUrl==nil||self.policyListsModel.xs1_pathUrl.length==0 ? @"car_identity_photo_positive":  self.policyListsModel.xs1_pathUrl;
                NSString * reverseImage =  self.policyListsModel.xs1_pathUrl==nil || self.policyListsModel.xs2_pathUrl.length==0  ? @"car_identity_photo_reverse": self.policyListsModel.xs2_pathUrl;
                
                identityCardView  = [self tableView:tableView WithImageUrl1:positiveImage    withImageUrl2: reverseImage  withCarList: car indexPath: indexPath labelText:@"车辆行驶证"];
            }
        }
        return  identityCardView;
        
    }else { //第1和2组
        
        
        CarInfoBasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:basicCellIdentifier forIndexPath:indexPath];
        if (nil == basicCell) {
            basicCell = [[CarInfoBasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:basicCellIdentifier];
        }
        
        if (0 == indexPath.section) {
            car = [self.firstSectionArray objectAtIndex:indexPath.row];
        }else if (1==indexPath.section){
            car = [self.secondSectionArray objectAtIndex:indexPath.row];
        }
        
        basicCell.nameLabel.text = car.key;
        basicCell.valueTextField.text = self.values[indexPath.section][indexPath.row];
        basicCell.valueTextField.tag = valueTextFieldOriginalTagValue * indexPath.section + indexPath.row;
        basicCell.valueTextField.delegate = self;
        //如果标志位为YES,则不允许输入
        if (YES == car.flag) {
            basicCell.valueTextField.userInteractionEnabled = NO;
        }//否则,设置代理
        else {
            basicCell.valueTextField.delegate = self;
        }
        return basicCell;
        
    }
}

-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  SectionHeaderHeight;
}


/*
 身份证正面和反面
 */
-(void)idCardPositiveWithReverse :(UIButton *) sender
{
    [self   setButtonPositiveWithReverse : sender type:KevinBaseTypeIDCard];
}

/*
 行驶证正面和反面
 */
-(void) drvingLicensePositiveWithReverse:(UIButton *) sender
{
    [self   setButtonPositiveWithReverse : sender type:KevinBaseTypeDrivingLicense];
}

-(void)setButtonPositiveWithReverse :(UIButton * ) sender  type:(KevinBaseType) type
{
    
    self.kevinBaseController.prTtype = sender.tag;
    [self.view addSubview:self.kevinBaseController.view];
    [self.kevinBaseController callCameraOrPhotoLibary];
    
    self.kevinBaseController.imageFromType = ImageFromTypeCarInfo;
    
    //设置证件类型
    self.kevinBaseController.baseType = type;
    __weak typeof(self.kevinBaseController) tempKevinBase = self.kevinBaseController;
    __weak typeof(self) temp = self;
    self.kevinBaseController.addCarInfoCallBlock = ^(NSString * url, PositiveWithReverseType type,KevinBaseType baseType,  NSString *  photoId)
    {
        if(type== PositiveType){
            NSURL * nsUrl = [NSURL URLWithString: url];
            [[SDWebImageManager  sharedManager] downloadImageWithURL:nsUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [sender  setImage: image forState:UIControlStateNormal];
            }];
            
            if (baseType == KevinBaseTypeIDCard) {
                temp.tempCarInfo.Sf1_Id_Url = url;
                temp.tempCarInfo.Sf1_Id = photoId;
            }else{
                temp.tempCarInfo.xs1_pathUrl = url;
                temp.tempCarInfo.xs1_path = photoId;
            }
            
        }else if(type == ReverseType){
            NSURL * nsUrl = [NSURL URLWithString: url];
            [[SDWebImageManager  sharedManager] downloadImageWithURL:nsUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [sender  setImage: image forState:UIControlStateNormal];
            }];
            
            if (baseType == KevinBaseTypeIDCard) {
                temp.tempCarInfo.Sf2_Id_Url = url;
                temp.tempCarInfo.Sf2_Id = photoId;
            }else{
                temp.tempCarInfo.xs2_pathUrl = url;
                temp.tempCarInfo.xs2_path = photoId;
            }
        }
        [sender setNeedsDisplay];
        
        [tempKevinBase.view removeFromSuperview];
    };
    self.kevinBaseController.removeKevinBaseView = ^(){
        [tempKevinBase.view  removeFromSuperview];
    };
    
}


#pragma  mark  - InsureFooterView 代理 点击提交信息
-(void)insureFooterViewClick
{
    
    //提交后,需要返回 1、车主身份证号码 2、车主联系电话 3、车主身份证 证件id 4、车辆行驶证 证件id
    
    NSString *sf1_id = self.tempCarInfo.Sf1_Id;
    NSString *sf2_id = self.tempCarInfo.Sf2_Id;
    NSString *xs1_id = self.tempCarInfo.xs1_path;
    NSString *xs2_id = self.tempCarInfo.xs2_path;
    
    self.passValue(sfz_Number,phone_Number,sf1_id,sf2_id,xs1_id,xs2_id);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma  mark 加载车主身份证的图片和加载车辆行驶证的图片
-(IdCardWithDrvingLicenseCell * ) tableView :(UITableView * ) tableView   withIdentifier:(NSString * ) withIdentifier indexPath:(NSIndexPath * ) indexPath   labelText:(NSString * )  labelText   imageStr:(NSString * ) imageStr imageStr2:(NSString * )imageStr2   {
    IdCardWithDrvingLicenseCell *  identityCardView = [IdCardWithDrvingLicenseCell cellWithTableView: tableView forIndexPath:indexPath withIdentifier:withIdentifier];
#warning 这里是怎么回事，重用标识符
    //    identityCardView = [IdCardWithDrvingLicenseCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:SFImageCell];
    [identityCardView.positiveUIButton  setImage: [UIImage imageNamed:imageStr]  forState:UIControlStateNormal];
    [identityCardView.reverseButton setImage: [UIImage imageNamed:imageStr2] forState:UIControlStateNormal];
    [identityCardView  setCornerRadius:5.0f isToBounds:YES labelText: labelText];
    return identityCardView;
}

#pragma mark - 加载车主身份证
-(IdCardWithDrvingLicenseCell * )tableView:(UITableView * ) tableView forIndexPath:(NSIndexPath *)indexPath positiveImage:(NSString * )  positiveImage  reverseImage:(NSString * )  reverseImage labelText:(NSString * )labelText
{
    IdCardWithDrvingLicenseCell * identityCardView ;
    //判断是车主身份证section
    if (2 == indexPath.section) {
        identityCardView = [IdCardWithDrvingLicenseCell cellWithTableView: tableView forIndexPath:indexPath withIdentifier:SFImageCell];
    }
    if (3 == indexPath.section) {
        identityCardView = [IdCardWithDrvingLicenseCell cellWithTableView: tableView forIndexPath:indexPath withIdentifier:XSImageCell];
    }
    identityCardView.selectionStyle= UITableViewCellSelectionStyleNone;
    identityCardView.particularLabel.text = @"";
    [identityCardView.positiveUIButton setImage:[UIImage imageNamed:positiveImage] forState:UIControlStateNormal];
    [identityCardView.reverseButton  setImage:[UIImage imageNamed: reverseImage] forState:UIControlStateNormal];
    [identityCardView  setCornerRadius:5.0f isToBounds:YES labelText: labelText];
    return  identityCardView;
}

/*
 有url就给button设置图片
 */
- (IdCardWithDrvingLicenseCell * ) tableView:(UITableView * ) tableView WithImageUrl1 :(NSString * ) imageUrl1  withImageUrl2:(NSString * ) imageUrl2  withCarList:(CarList*) car  indexPath:(NSIndexPath *) indexPath labelText:(NSString * )labelText {
    
    IdCardWithDrvingLicenseCell * identityCardView ;
    if (2 == indexPath.section) {
        identityCardView = [IdCardWithDrvingLicenseCell cellWithTableView: tableView forIndexPath:indexPath withIdentifier:SFImageCell];
    }
    if (3 == indexPath.section) {
        identityCardView = [IdCardWithDrvingLicenseCell cellWithTableView: tableView forIndexPath:indexPath withIdentifier:XSImageCell];
    }
    identityCardView.selectionStyle= UITableViewCellSelectionStyleNone;
    identityCardView.particularLabel.text = @"";
    identityCardView.selectionStyle =UITableViewCellSelectionStyleNone;
    car = [self.thirdlySectionArray  objectAtIndex: indexPath.row ];
    identityCardView.leftLabel.text = car.key;
    
    if([imageUrl1 containsString:@"http"]){
        NSURL * positiveUrl = [NSURL  URLWithString: imageUrl1];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:positiveUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [ identityCardView.positiveUIButton setImage:  image forState:UIControlStateNormal];
        }];
    }else{
        [identityCardView.positiveUIButton setImage:[UIImage imageNamed: imageUrl1] forState:UIControlStateNormal];
        
    }
    if([imageUrl2 containsString:@"http"]){
        NSURL * reverseUrl = [NSURL  URLWithString:imageUrl2 ];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:reverseUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [identityCardView.reverseButton  setImage: image forState:UIControlStateNormal];
        }];
    }else{
        [identityCardView.reverseButton setImage:[UIImage imageNamed: imageUrl2] forState:UIControlStateNormal];
    }
    [identityCardView  setCornerRadius:5.0f isToBounds:YES labelText:labelText];
    return  identityCardView;
}




#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger section = textField.tag / valueTextFieldOriginalTagValue;
    NSInteger row = textField.tag % valueTextFieldOriginalTagValue;
    
    //身份证号码
    if (1 == section && 1 == row) {
        
        sfz_Number = textField.text;
        
    }
    
    //联系电话
    if (1 == section && 2 == row) {
        
        //判断是否是电话号码
        if ([NSString isPhoneNumber:textField.text]) {
            
            phone_Number = textField.text;
        }else{
            [GiFHUD showWithMessage:@"电话号码不正确"];
            [GiFHUD dismissBiggerFrame];
        }
    }
    
}

#pragma mark - carInfo的setter方法
-(void)setCarInfo:(CarInfo *)carInfo{
    self.tempCarInfo = carInfo;
}

-(void)setPriceDetail:(PriceDetail *)priceDetail{
    self.tempPriceDetail = priceDetail;
}

-(void)setIsClickWithShowView:(BOOL)isClickWithShowView
{
    _isClickWithShowView = isClickWithShowView;
}




#pragma mark - 懒加载
-(NSMutableArray *)carListArray{
    if (nil == _carListArray) {
        _carListArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _carListArray;
}

-(NSMutableArray *)firstSectionArray{
    if (nil == _firstSectionArray) {
        _firstSectionArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _firstSectionArray;
}

-(NSMutableArray *)secondSectionArray{
    if (nil == _secondSectionArray) {
        _secondSectionArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _secondSectionArray;
}

-(NSMutableArray *) thirdlySectionArray
{
    if(!_thirdlySectionArray){
        _thirdlySectionArray = [[NSMutableArray alloc] init];
    }
    return _thirdlySectionArray;
}


-(NSMutableArray * ) fourthlySectionArray{
    
    if(!_fourthlySectionArray){
        _fourthlySectionArray  = [[NSMutableArray alloc ]init];
    }
    
    return  _fourthlySectionArray;
}


#pragma  mark - leftItemBar  懒加载返回按钮
-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}

#pragma  mark - insureFooterView ；懒加载提交按钮
-(InsureFooterView *)insureFooterView
{
    if(!_insureFooterView){
        _insureFooterView = [[[NSBundle mainBundle] loadNibNamed:@"InsureFooterView" owner:nil options:nil] lastObject];
        _insureFooterView.delegate = self;
        _insureFooterView.buttonTitle = @"提交";
    }
    return _insureFooterView;
}


-(KevinBaseController *)kevinBaseController
{
    if(!_kevinBaseController){
        _kevinBaseController = [[KevinBaseController alloc] init];
        _kevinBaseController.delegate = self;
        _kevinBaseController.imageFromType = ImageFromTypeConfirmList;
    }
    return _kevinBaseController;
}


#pragma mark - back
-(void)  back
{
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController  setNavigationBarHidden:NO animated:YES];
    
    //加载数据
    [self loadData];
}



@end
