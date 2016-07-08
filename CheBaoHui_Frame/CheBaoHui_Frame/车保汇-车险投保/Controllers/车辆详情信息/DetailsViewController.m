//
//  DetailsViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DetailsViewController.h"
#import "InsureHeadView.h"
#import "DetailModel.h"
#import "DetailSectionModel.h"
#import "DetailViewCell.h"
#import "InsureFooterView.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "InsureModel.h"
#import "InsureDataModel.h"
#import "WarrantyModel.h"
#import "InsureHolderWithInsuredModel.h"
#import "InsureDeliveryUIView.h"
#import "PayWayUIView.h"
#import "GiFHUD.h"
#import "InsurePayWayUIView.h"
#import "HTTPManager.h"
#import "WeChatPayManager.h"
#import "AliPayManager.h"
#import "CarInfoTableViewController.h"
#import "ResultModel.h"
#import "PolicyListsModel.h"


typedef NS_ENUM(NSInteger, DetailsViewControllerType) {
    procuratorType=1, //代理人
    procuratorPhoneNumberType, //代理人电话
    addresseeType,// 收件人
    addresseePhoneNumberType, //收件人电话
    addressType, //地址
    serialNumberType  //流水号
    
};

@interface DetailsViewController ()<InsureFooterViewDelegate,UITextFieldDelegate,InsurePayWayUIViewDelegate,DetailViewCellDelegate>
/**
 *  头view
 */
@property (nonatomic  , strong) InsureHeadView *  insureHeadView;

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@property (nonatomic , strong) UIBarButtonItem * leftItemBar;


@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/

@property (nonatomic , strong)  InsureFooterView *  insureFooterView;

@property (nonatomic , assign) NSInteger  deliveryType;//配送的类型 0未选择  1现领 2代领 3快递

@property (nonatomic , assign) NSInteger payWayType; // 支付的类型 0未选择  1微信 2支付宝 3刷卡 4银联

@property (nonatomic , copy) NSString * procuratorStr;  //代领人姓名

@property (nonatomic , copy) NSString * procuratorPhoneNumberStr; //代领人电话

@property (nonatomic , copy) NSString * addresseeStr; //收件人

@property (nonatomic , copy) NSString *  addresseePhoneNumberStr; //收件人电话

@property (nonatomic , copy) NSString * addressStr; //地址

@property (nonatomic , copy) NSString * serialNumberStr; //流水号

//车辆详细
@property (nonatomic , strong) CarInfoTableViewController  *  carInfoTableViewController;

//蒙板
@property (nonatomic , strong )  UIButton * cover;


@property (nonatomic , strong) InsurePayWayUIView * insurePayWayUIView;


@property (nonatomic , strong) NSDictionary * contents;

///**
// *  总金额
// */
//@property(nonatomic , assign) CGFloat   amount;


/**
 *  配送方式
 */
@property(nonatomic,strong) NSString *ps_way;

/**
 *  预支付订单号
 */
@property(nonatomic,strong) NSString *prepayid;

/**
 *  后台返回的随机字符串
 */
@property(nonatomic,strong) NSString *nonceStr;

//回执保单印象件
@property (nonatomic , strong) UIView *   baodanImageView;

@property (nonatomic , strong) InsureDataModel * insureData;

/**
 *  网络请求实例
 */
@property(nonatomic,strong) HTTPManagerOfInsurance *HTTPManager;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deliveryType = 0;
    self.payWayType = 0;
    
    //设置tableview的取消弹簧效果
    self.detailsTableView.bounces = NO;
    self.detailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //隐藏上下拉滑动条
    self.detailsTableView.showsVerticalScrollIndicator = NO;
    self.navigationItem.leftBarButtonItem = self.leftItemBar;
    self.detailsTableView.backgroundColor = ColorFromRGB(243, 244, 245);
    [GiFHUD setGifWithImageName:@"pika.gif"];
}



#pragma mark -- 
-(void) showDetailOfInsureingWithInsureDataModal:(InsureDataModel *)insureData contens:(NSDictionary *)contents policy:(PolicyListsModel *)policyModel{
    
    DetailModel  * carInfo = [[DetailModel alloc] init];
    carInfo.headerTitle = @"车辆信息";
    carInfo.detailText = @"详情";
    carInfo.accessoryType = DetailAccessoryTypeDisclosureIndicator;
    
    //Owner information
    DetailModel  * ownerInformation  = [[DetailModel alloc] init];
    ownerInformation.headerTitle = @"车主姓名";
    ownerInformation.detailText= [contents objectForKey:@"cz_name"];
    ownerInformation.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailModel  * plateNumber  = [[DetailModel alloc] init];
    plateNumber.headerTitle = @"车牌号码";
    plateNumber.detailText=  policyModel.cph_no;
    plateNumber.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    //TCI     Traffic compulsory insurance
    DetailModel  * tciDate  = [[DetailModel alloc] init];
    tciDate.headerTitle = @"交强险起保日期";
    tciDate.detailText=  [self.insureData.sx_date substringToIndex:10];
    tciDate.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    //VCI Vehicle commercial insurance
    DetailModel  * vciDate  = [[DetailModel alloc] init];
    vciDate.headerTitle = @"商业险起保日期";
    vciDate.detailText=  [self.insureData.sx_date substringToIndex:10];
    vciDate.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailSectionModel * detailSection1 = [[DetailSectionModel alloc] init];
    
    detailSection1.itemArray = @[carInfo,ownerInformation,plateNumber,tciDate,vciDate];
    detailSection1.sectionHeaderHeight  = SectionHeaderHeight;
    
    DetailModel * policy = [[DetailModel alloc] init];
    policy.headerTitle = @"保单信息";
    
    DetailModel * policyNumber = [[DetailModel alloc] init];
    policyNumber.headerTitle = @"保险单号";
    policyNumber.detailText=  insureData.cntr_id ;
    policyNumber.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailModel * insuranceCo = [[DetailModel alloc] init];
    insuranceCo.headerTitle = @"保险公司";
    insuranceCo.detailText=  insureData.subcomp_code ;
    insuranceCo.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailModel * insuranceMo = [[DetailModel alloc] init];
    insuranceMo.headerTitle = @"保险金额";
#warning 总报价金额
    insuranceMo.detailText=  _insureData.pre_premium ;
    insuranceMo.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailSectionModel * detailSection2 = [[DetailSectionModel alloc] init];
    detailSection2.itemArray = @[policy,policyNumber,insuranceCo,insuranceMo];
    detailSection2.sectionHeaderHeight = SectionHeaderHeight;
    
    DetailModel * policyImage= [[DetailModel alloc] init];
    
    policyImage.headerTitle = @"回执保单影像件";
    policyImage.url1  =  insureData.Jqxyyj_imgUrl;
    policyImage.url2  =  insureData.Syxyyj_imgUrl;
    
    
    DetailSectionModel * detailSection3 = [[DetailSectionModel alloc] init];
    detailSection3.itemArray = @[policyImage];
    detailSection3.sectionHeaderHeight = SectionHeaderHeight;
    
    self.sectionArray = @[detailSection1,detailSection2,detailSection3];
    [self.detailsTableView reloadData];
    
}




#pragma mark -- 待审核,审核中,审核失败,接口
/**
 *  <#Description#>
 *
 *  @param policy   <#policy description#>
 *  @param contents <#contents description#>
 */
-(void) detailsViewWithpolicy:(PolicyListsModel *)policy contents:(NSDictionary * )contents andStatus:(NSString *)status{
    self.contents = contents;
    self.sectionArray=nil;
    
    //调用接口
    [self.HTTPManager GetInsureDataWithcph_no:policy.cph_no cjh_no:policy.cjh_no];
    
    __weak typeof(self) temp = self;
    //得到成功的数据
    _HTTPManager.passResponseObjectOfGetInsureData = ^(id responseObject){
        InsureModel * insure =  [InsureModel  mj_objectWithKeyValues:responseObject];
        
        InsureDataModel * insureData = [insure data];
        
        temp.insureData = insureData;
        int statusValue = [[status removeSpace] intValue];
        if (statusValue == -1 || statusValue == 0 || statusValue == 1 || statusValue == 4 || statusValue == 5) {
            [temp showDetailInfoWithInsureDataModal:insureData contens:contents policy:policy];
        }else if(statusValue == 2 || statusValue == 3){
            [temp showDetailAboutPayWithInsureDataModal:insureData contens:contents policy:policy];
        }
        else{
            [temp showDetailOfInsureingWithInsureDataModal:insureData contens:contents policy:policy];
        }
        
        
    };
    
    //失败
    _HTTPManager.passErrorOfGetInsureData = ^(NSError *error){
        [super showFailureHUD:FailureAboutRequestData hideTime:ToastHideTime];
    };
    
}

#pragma mark -- 待审核-1 审核中0 审核失败1 支付成功4 刷卡支付，待财务确认5
-(void)showDetailInfoWithInsureDataModal:(InsureDataModel *)insureData contens:(NSDictionary *)contents policy:(PolicyListsModel *)policy{
    WarrantyModel * statusModel = [[WarrantyModel alloc] init];
    statusModel.leftText = @"保险状态";
    statusModel.rightText  =[NSString detailText: insureData.status];
    statusModel.warantyType = WarantyTypeStatus;
    WarrantyModel * insuranceCo = [[WarrantyModel alloc] init];
    insuranceCo.leftText = @"保险公司";
    insuranceCo.rightText = insureData.subcomp_code;
    
    WarrantyModel *  insureaceMoney   =[[WarrantyModel alloc] init];
    insureaceMoney.leftText  = @"保险金额";
    insureaceMoney.rightText = self.insureData.pre_premium;
    
    //policy holder
    WarrantyModel  * policyHolder = [[WarrantyModel alloc] init];
    InsureHolderWithInsuredModel * insureHolder =  [insureData  Cntr_Holder];
    policyHolder.leftText = @"投保人";
    policyHolder.rightText = [contents objectForKey:@"cz_name"] ;
    
    //recognizee
    WarrantyModel  * recognizee = [[WarrantyModel alloc] init];
    insureHolder =  [insureData  Cntr_Insured];
    recognizee.leftText = @"被保人";
    recognizee.rightText = [contents objectForKey:@"cz_name"];
    NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithObjects: statusModel,insuranceCo,insureaceMoney, policyHolder,recognizee,nil];
    self.insureHeadView.data = mutableArray;
    
    DetailModel  * carInfo = [[DetailModel alloc] init];
    carInfo.headerTitle = @"车辆信息";
    carInfo.detailText = @"详情";
    carInfo.accessoryType = DetailAccessoryTypeDisclosureIndicator;
    
    //Owner information
    DetailModel  * ownerInformation  = [[DetailModel alloc] init];
    ownerInformation.headerTitle = @"车主姓名";
    ownerInformation.detailText= [contents objectForKey:@"cz_name"];
    ownerInformation.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailModel  * plateNumber  = [[DetailModel alloc] init];
    plateNumber.headerTitle = @"车牌号码";
    plateNumber.detailText=  policy.cph_no;
    plateNumber.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    //TCI     Traffic compulsory insurance
    DetailModel  * tciDate  = [[DetailModel alloc] init];
    tciDate.headerTitle = @"交强险起保日期";
    tciDate.detailText=  [insureData.sx_date substringToIndex:10];
    
    tciDate.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    //VCI Vehicle commercial insurance
    DetailModel  * vciDate  = [[DetailModel alloc] init];
    vciDate.headerTitle = @"商业险起保日期";
    vciDate.detailText=  [insureData.sx_date substringToIndex:10];
    vciDate.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailSectionModel * detailSection1 = [[DetailSectionModel alloc] init];
    detailSection1.itemArray = @[carInfo,ownerInformation,plateNumber,tciDate,vciDate];
    
    if([insureData.status  isEqualToString:@"5"]){
        DetailModel  * delivery = [[DetailModel alloc] init];
        delivery.headerTitle = @"保单配送";
        delivery.detailText = @"现领";
        DetailSectionModel * detailSection2 = [[DetailSectionModel alloc] init];
        detailSection2.itemArray = @[delivery];
        detailSection2.sectionHeaderHeight = SectionHeaderHeight;
        self.sectionArray = @[detailSection1,detailSection2];
    }else{
        self.sectionArray = @[detailSection1];
    }
    [self.detailsTableView reloadData];
    if(self.showHead){
        self.detailsTableView.tableHeaderView = self.insureHeadView;
    }
}

#pragma mark -- 审核成功,待支付2 支付失败3
-(void)showDetailAboutPayWithInsureDataModal:(InsureDataModel *)insureData contens:(NSDictionary *)contents policy:(PolicyListsModel *)policy{
    WarrantyModel * insuranceCo = [[WarrantyModel alloc] init];
    insuranceCo.leftText = @"保险公司";
    insuranceCo.rightText = insureData.subcomp_code;
    
    WarrantyModel *  insureaceMoney   =[[WarrantyModel alloc] init];
    insureaceMoney.leftText  = @"保险金额";
    insureaceMoney.rightText = insureData.pre_premium;
    
    NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithObjects:insuranceCo,insureaceMoney ,nil];
    self.insureHeadView.data = mutableArray;
    
    // 被保人即车主
    DetailModel  * recognizeeBeOwner = [[DetailModel alloc] init];
    recognizeeBeOwner.headerTitle = @"被保人即车主";
    recognizeeBeOwner.imageStr = @"check_box_checked" ;
    recognizeeBeOwner.accessoryType = DetailAccessoryTypeTextBlackWithImageAndDate;
    
    //投保人即被保人
    DetailModel  * recognizeeBePolicyHolder = [[DetailModel alloc] init];
    recognizeeBePolicyHolder.headerTitle = @"投保人即被保人";
    recognizeeBePolicyHolder.imageStr = @"check_box_checked";
    recognizeeBePolicyHolder.accessoryType = DetailAccessoryTypeTextBlackWithImageAndDate;
    
    //TCI     Traffic compulsory insurance
    DetailModel  * tciDate  = [[DetailModel alloc] init];
    tciDate.headerTitle = @"交强险起保日期";
    tciDate.detailText= [insureData.sx_date substringToIndex:10];
    tciDate.accessoryType = DetailAccessoryTypeTextBlackWithImageAndDate;
    
    //VCI Vehicle commercial insurance
    DetailModel  * vciDate  = [[DetailModel alloc] init];
    vciDate.headerTitle = @"商业险起保日期";
    vciDate.detailText=  [insureData.sx_date substringToIndex:10];
    vciDate.accessoryType = DetailAccessoryTypeTextBlackWithImageAndDate;
    
    DetailSectionModel * detailSection1 = [[DetailSectionModel alloc] init];
    detailSection1.itemArray = @[recognizeeBeOwner,recognizeeBePolicyHolder,tciDate,vciDate];
    
    DetailModel  * carInfo = [[DetailModel alloc] init];
    carInfo.headerTitle = @"车辆信息";
    carInfo.detailText = @"详情";
    carInfo.accessoryType = DetailAccessoryTypeDisclosureIndicator;
    
    //Owner information
    DetailModel  * ownerInformation  = [[DetailModel alloc] init];
    ownerInformation.headerTitle = @"车主姓名";
    ownerInformation.detailText=  [contents objectForKey:@"cz_name"];
    ownerInformation.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    DetailModel  * plateNumber  = [[DetailModel alloc] init];
    plateNumber.headerTitle = @"车牌号码";
    plateNumber.detailText= policy.cph_no;
    plateNumber.accessoryType = DetailAccessoryTypeTextBlackAndBlueColor;
    
    //第二组
    DetailSectionModel * detailSection2 = [[DetailSectionModel alloc] init];
    detailSection2.itemArray = @[carInfo,ownerInformation,plateNumber];
    
    detailSection2.sectionHeaderHeight  = SectionHeaderHeight;
    
    DetailModel * delivery = [[DetailModel alloc] init];
    InsureDeliveryUIView * insureDeliveView =    [[[NSBundle  mainBundle] loadNibNamed:@"InsureDeliveryUIView" owner:nil options:nil] lastObject];
    delivery.radioView = insureDeliveView;
    //第3组
    DetailSectionModel * detailSection3 = [[DetailSectionModel alloc] init];
    detailSection3.itemArray = @[delivery];
    
    insureDeliveView.insureDeliver = ^(NSInteger tag){
        //设置
        self.deliveryType = tag;
        
        //代领人
        DetailModel * dailing = [[DetailModel alloc] init];
        //联系电话
        DetailModel * contactNumber = [[DetailModel alloc] init];
        if(tag==1){
            detailSection3.itemArray = @[delivery];
            self.ps_way = nowWay;
        }else if(tag==2){
            self.ps_way = behalfWay;
            dailing.leftLabel = @"代 领 人";
            dailing.accessoryType =  DetailAccessoryTypeTextBlackWithInputText;
            UITextField * dailingText = [[UITextField alloc] init];
            dailingText.delegate = self;
            dailingText.tag = procuratorType ; //代领人 tag
            
            [dailingText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            dailingText.placeholder = @"请输入代领人姓名";
            dailing.inputTextFiled = dailingText;
            contactNumber.leftLabel = @"联系电话";
            
            contactNumber.accessoryType =  DetailAccessoryTypeTextBlackWithInputText;
            
            UITextField * contactText =  [[UITextField  alloc] init];
            contactText.delegate = self;
            contactText.placeholder = @"请输入联系电话";
            contactNumber.inputTextFiled = contactText ;
            [contactText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
            contactText.tag = procuratorPhoneNumberType; //代理人电话
            detailSection3.itemArray = @[delivery,dailing,contactNumber];
        }else if(tag == 3){
            self.ps_way = sendWay;
            dailing.leftLabel = @"收 件 人";
            dailing.accessoryType =  DetailAccessoryTypeTextBlackWithInputText;
            UITextField * dailingText = [[UITextField alloc] init];
            dailingText.delegate = self;
            dailingText.text = _insureData.Cntr_Holder.name;
            dailingText.placeholder = @"请输入联系人";
            dailing.inputTextFiled =dailingText;
            dailingText.tag = addresseeType;
            self.addresseeStr = [contents objectForKey:@"cz_name"];
            [dailingText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
            
            contactNumber.leftLabel = @"联系电话";
            UITextField * contactText = [[UITextField alloc] init];
            NSString *phoneNUmber = [self.contents objectForKey:@"cz_name"];
            contactText.text = phoneNUmber;
            contactText.placeholder = @"请输入联系电话";
            contactNumber.inputTextFiled = contactText;
            
            contactText.delegate = self;
            self.addresseePhoneNumberStr =[self.contents objectForKey:@"cz_name"];
            contactNumber.accessoryType =  DetailAccessoryTypeTextBlackWithInputText;
            contactText.tag = addresseePhoneNumberType;
            
            [contactText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
            DetailModel * address = [[DetailModel alloc] init];
            address.leftLabel = @"快递地址";
            
            UITextField * addressText = [[UITextField alloc] init];
            addressText.delegate = self;
            addressText.placeholder = @"请输入联系人";
            address.inputTextFiled = addressText;
            
            addressText.tag = addressType;
            
            [addressText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
            address.accessoryType =  DetailAccessoryTypeTextBlackWithInputText;
            detailSection3.itemArray = @[delivery,dailing,contactNumber,address];
        }
        [self.detailsTableView reloadData];
    };
    
    detailSection3.sectionHeaderHeight  = SectionHeaderHeight;
    DetailModel *  payWay = [[DetailModel alloc] init];
    
    PayWayUIView * payWayView=  [[[NSBundle mainBundle] loadNibNamed:@"PayWayUIView" owner:nil options:nil] lastObject];
    payWay.radioView = payWayView ;
    
    //第4组
    DetailSectionModel * detailSection4 = [[DetailSectionModel alloc] init];
    detailSection4.itemArray = @[payWay];
    detailSection4.sectionHeaderHeight  = SectionHeaderHeight;
    
    
    //配送方式
    payWayView.payWay = ^(NSInteger tag){
        
        self.payWayType = tag;
        if(tag==1){
            detailSection4.itemArray = @[payWay];
        }else if(tag==2){
            detailSection4.itemArray = @[payWay];
        }else if(tag==3){
            
            DetailModel * slotCard = [[DetailModel alloc] init];
            slotCard.leftLabel = @"流水号";
            slotCard.accessoryType =  DetailAccessoryTypeTextBlackWithInputText;
            UITextField * serialNumber = [[UITextField alloc] init];
            serialNumber.delegate = self;
            serialNumber.placeholder = @"请输入刷卡流水号";
            slotCard.inputTextFiled = serialNumber;
            serialNumber.tag = serialNumberType;
            
            [serialNumber addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
            
            detailSection4.itemArray = @[payWay,slotCard];
            
            
        }else if(4 == tag){
            detailSection4.itemArray = @[payWay];
        }
        [self.detailsTableView  reloadData];
    };
    
    self.sectionArray = @[detailSection1,detailSection2,detailSection3,detailSection4];
    
    //是否显示底部view
    if(self.showFooter){
        self.insureFooterView.delegate = self;
        self.insureFooterView.buttonTitle = @"支付";
        [self.detailsTableView setTableFooterView:self.insureFooterView];
        
    }else{
        [self.detailsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        
    }
    [self.detailsTableView reloadData];
    
    
    //是否显示头部view
    if(self.showHead){
        self.detailsTableView.tableHeaderView = self.insureHeadView;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setData:(NSArray *)data
{
    _data = data;
}


-(void) setPolicyListModel:(PolicyListsModel *)policyListModel
{
    _policyListModel = policyListModel;
}


/**
 * 实时监听text输入的内容完毕
 */
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case procuratorType:{
            self.procuratorStr = textField.text;
        }break;
        case procuratorPhoneNumberType:{
            self.procuratorPhoneNumberStr = textField.text;
        }break;
        case addresseeType:{
            self.addresseeStr = textField.text;
        }break;
        case addresseePhoneNumberType:{
            self.addresseePhoneNumberStr = textField.text;
        }break;
        case addressType:{
            self.addressStr = textField.text;
        }break;
        case  serialNumberType:{
            self.serialNumberStr = textField.text;
        } break;
    }
    
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma  mark -- InsureFooterViewDelegate 选择配送方式
-(void)insureFooterViewClick
{
    //获取
    if(self.deliveryType ==0){
        [super  showToastHUD:@"请选择配送方式" hideTime:2.0f];
        return;
    }else if(self.deliveryType==2){
        
        //获取代领人的信息
        if(self.procuratorStr==nil  || self.procuratorStr.length==0){
            [super  showToastHUD:@"请输入代领人姓名" hideTime:2.0f];
            return;
        }
        
        if(self.addresseeStr ==nil || self.addresseeStr.length ==0){
            [super  showToastHUD:@"请输入代领人电话" hideTime:2.0f];
            return;
        }
    }else if(self.deliveryType==3){
        
        //获取代领人的信息
        if(self.addresseeStr==nil  || self.addresseeStr.length==0){
            [super  showToastHUD:@"请输入收件人姓名" hideTime:2.0f];
            return;
        }
        if(self.addresseePhoneNumberStr ==nil || self.addresseePhoneNumberStr.length ==0){
            [super  showToastHUD:@"请输入收件人电话" hideTime:2.0f];
            return;
        }
        if(self.addressStr ==nil || self.addressStr.length ==0){
            [super  showToastHUD:@"请输入快递详细地址" hideTime:2.0f];
            return;
        }
    }
    
    if(self.payWayType ==0){
        [super showToastHUD:@"请选择支付方式" hideTime:2.0f];
        return;
    }else if(self.payWayType==1){
        // 调用 微信
        [GiFHUD showWithOverlay];
        // dismiss after 2 seconds
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [GiFHUD dismiss];
            //出现 支付方式界面
            [self cover];
            [UIView animateWithDuration:0 animations:^{
                [self   payWinChatWithpaytype:wechat];
            } completion:^(BOOL finished) {
                
            }];
        });
    }else if(self.payWayType==2){
        //调用支付宝
        [GiFHUD showWithOverlay];
        // dismiss after 2 seconds
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [GiFHUD dismiss];
            [self cover];
            [UIView animateWithDuration:0 animations:^{
                [self   payWinChatWithpaytype:alipay];
            }completion:^(BOOL finished) {
                
            }];
        });
        
    }else if(self.payWayType==3){
        //卡单号
        if(self.serialNumberStr == nil || self.serialNumberStr.length ==0){
            [super  showToastHUD:@"输入刷卡流水号" hideTime:2.0f];
            return;
        }
        
        //刷卡支付
        [self payWinChatWithpaytype:cash];
        
    }else if(self.payWayType == 4){
        //银联支付
        [self payWinChatWithpaytype:yinLian];
    }
}

#pragma mark --- 调起支付接口(支付宝、微信)
-(void)insurePayWayType:(NSString *)payType{
    
    NSString *cntr_id = [self.contents objectForKey:@"cntr_id"];
    
    
    if ([wechat isEqualToString:payType]) {
        //微信支付
        WeChatPayManager *weChatPayManager = [WeChatPayManager new];
        
        //跳到微信支付界面
        [weChatPayManager toPayWithprepayid:self.prepayid nonceStr:self.nonceStr];
        
    }
    
    if([alipay isEqualToString:payType]){
        
        //调起支付宝支付
        AliPayManager *aliPayManager = [AliPayManager new];
        
        NSString *productName = [NSString stringWithFormat:@"%@在%@投保",[self.contents objectForKey:@"cz_name"],[self.insureData subcomp_code]];
        NSString *productDescription = [self.insureData pre_premium];
        
        
        [aliPayManager configureInfoWithtradeNO:cntr_id productName:productName productDescription:productDescription amount:[_insureData.pre_premium floatValue]];
    }
    
    
}


#pragma mark -- 得到二维码地址,生成二维码
-(void)  payWinChatWithpaytype:(NSString * ) paytype
{
    
    HTTPManager * manager = [HTTPManager  sharedHTPPManager];
    
#warning 总报价金额
    //链接接口
    [manager payInsurancePriceWithps_way:self.ps_way sdr_name:[self.contents objectForKey:@"cz_name"] sdr_mobile:[self.contents  objectForKey:@"Cz_phone"] sdr_addr:self.addressStr == nil ? @"" : self.addressStr cntr_id:[self.contents objectForKey:@"cntr_id"] amount:[_insureData.pre_premium floatValue]  paytype:paytype cardno:self.serialNumberStr == nil ? @"" : self.serialNumberStr companycode:[self.contents objectForKey:@"companycode"]];
    
    //如果是刷卡,则不需要封面来显示方式
    if ([cash isEqualToString:paytype]) {
        
        //支付成功
        manager.passNullMsg_PayPolicy = ^(id responseObject){
            [GiFHUD showWithMessage:responseObject[@"msg"]];
            
            self.view.alpha = 0;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC * 2)), dispatch_get_main_queue(), ^{
                
                [GiFHUD dismissBiggerFrame];
                
                self.view.alpha = 1;
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        };
    }
    
    //银联支付
    if ([yinLian isEqualToString:paytype]) {
        
        //传回html数据
        manager.passYinLianData = ^(NSString *url){
            
            NSString *htmlData = [NSString stringWithFormat:@"%@",url];

            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            
            webView.backgroundColor = [UIColor whiteColor];
            
            //加载html页面
            [webView loadHTMLString:htmlData baseURL:nil];
            
            [self.view addSubview:webView];
            
            [self.view bringSubviewToFront:webView];
            
        };
        
        return;
    }
    
    //出现封面
    self.cover.alpha = 1.0;
    
    self.insurePayWayUIView.payType = paytype;
    //设置代理
    self.insurePayWayUIView.delegate = self;
    
    
    //成功生成二维码
    manager.passErWeiMaURL = ^(NSString * erWeiMaURL){
        
        //传递二维码地址
        self.insurePayWayUIView.erweimaUrl = erWeiMaURL;
        
        //添加封面
        [self.view addSubview: self.insurePayWayUIView];
        
        
        [self.insurePayWayUIView  mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.center.mas_equalTo(self.view);
            //make.size.mas_equalTo(CGSizeMake(250,400));
            
            make.edges.mas_offset(UIEdgeInsetsMake(50, 30, 50, 30));
        }];
        
        
    };
    
    
    //生成二维码失败
    manager.passNullMsg_PayPolicy = ^(id responseObject){
        NSLog(@"生成二维码失败");
        //添加封面
        [self.view addSubview: self.insurePayWayUIView];
        
        [self.insurePayWayUIView  mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.center.mas_equalTo(self.view);
            //make.size.mas_equalTo(CGSizeMake(250,400));
            
            make.edges.mas_offset(UIEdgeInsetsMake(50, 30, 50, 30));
        }];
    };
    
    //微信本地支付
    manager.passPrepayid = ^(NSDictionary *dict){
        if (dict == nil) {
            
            self.view.alpha = 0;
            [GiFHUD showWithMessage:@"该车不可重复支付"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GiFHUD dismissBiggerFrame];
                self.view.alpha = 1;
            });
        }
        //后台返回预支付订单号后,调用微信进行支付
        NSString *prepayid = dict[@"prepay_id"];
        self.prepayid = prepayid;
        
        NSString *nonceStr = dict[@"nonceStr"];
        self.nonceStr = nonceStr;
        
        [self.insurePayWayUIView  mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.center.mas_equalTo(self.view);
            //make.size.mas_equalTo(CGSizeMake(250,400));
            
            make.edges.mas_offset(UIEdgeInsetsMake(50, 30, 50, 30));
        }];
    };
    
    
    //内部服务器请求错误 500
    manager.passErrorPayPolicy = ^(){
        [GiFHUD showWithMessage:@"网络繁忙,请稍后再试"];
        self.view.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC * 2)), dispatch_get_main_queue(), ^{
            
            [GiFHUD dismissBiggerFrame];
            
            self.view.alpha = 1;
        });
    };
    
    
    
}


#pragma mark -- 添加支付封面
-(UIButton *)cover
{
    if(!_cover){
        _cover = [[UIButton alloc] init];
        _cover.height = SCREEN_HEIGHT;
        _cover.width = SCREEN_WIDTH;
        _cover.backgroundColor  = [UIColor  colorWithWhite:0.0 alpha:0.5];
        [self.view addSubview:_cover];
        _cover.alpha = 0.0;
        [_cover  addTarget:self action:@selector(hideCover:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cover;
}

-(InsurePayWayUIView *)insurePayWayUIView
{
    if(!_insurePayWayUIView){
        _insurePayWayUIView= [[[ NSBundle mainBundle] loadNibNamed:@"InsurePayWayUIView" owner:nil options:nil] lastObject] ;
        //4
        //            _insurePayWayUIView.x =  (self.view.width - _insurePayWayUIView.width) * 0.5 ;
        //            _insurePayWayUIView.y = (self.view.height - _insurePayWayUIView.height)*0.5;
    }
    return  _insurePayWayUIView;
}


#pragma mark -- 隐藏视图
-(void) hideCover:(UIButton * ) cover
{
    [UIView animateWithDuration:0 animations:^{
        if(self.insurePayWayUIView !=nil){
            [self.insurePayWayUIView  removeFromSuperview];
        }
        if(self.baodanImageView!=nil){
            [self.baodanImageView removeFromSuperview];
        }
        cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    } ];
}

#pragma mark -- InsurePayWayUIViewDelegate
#pragma mark --- 点击确定后,关闭视图
-(void)insurePayWayCallBackColsePop{
    [self hideCover:self.cover];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DetailSectionModel  * sectionModel =  self.sectionArray [section];
    return  sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *  ID = @"ID";
    DetailSectionModel  * sectionModel =  self.sectionArray [indexPath.section];
    DetailModel *  detail =  sectionModel.itemArray[indexPath.row];
    DetailViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[DetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detail = detail;
    return cell;
}


#pragma mark  点击cell单元格--进入车辆详情页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailSectionModel * sectionModel = self.sectionArray[indexPath.section];
    DetailModel * detail = sectionModel.itemArray[indexPath.row];
    
    if(detail.accessoryType == DetailAccessoryTypeDisclosureIndicator){
     

        self.carInfoTableViewController.policyListsModel = self.policyListModel;
        self.carInfoTableViewController.insureDataModel = self.insureData;
        self.carInfoTableViewController.contents = self.contents;
        pushToViewControllerAndTarget(self, CarInfoTableViewController, self.carInfoTableViewController);
           
        
    }
}

-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    DetailSectionModel * sectionModel = self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}



#pragma  mark DetailViewCellDelegate 代理
/**
 *实现代理 让图片放大
 */
-(void)callBackZoomImageUrl:(NSString *)url
{   //弹出cover
    [self cover];
    self.cover.alpha = 0.5f;
    
    UIView * baodanImageView = [[UIView alloc]init];
    //距离top 和bottom
    CGFloat baodanImageViewMarginTopWithBottom= 50;
    //距离 right和left
    CGFloat baodanImageViewMarginRightWithLeft=30;
    
    
    baodanImageView.width = SCREEN_WIDTH;
    baodanImageView.height = SCREEN_HEIGHT;
    
    CGFloat textX =  10;
    CGFloat textY  = 10;
    CGFloat textHeight = 20;
    //width
    CGFloat width = self.view.width - (baodanImageViewMarginRightWithLeft*2)-(10*2);
    
    //Label 设置title
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, textY, width, textHeight)];
    textLabel.text = @"回执单影像件";
    [baodanImageView addSubview: textLabel];
    
    CGFloat lineViewx = textX;
    
    CGFloat lineViewY= textLabel.y+textLabel.height+textX;
    //线条
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewx, lineViewY, width , 2)];
    lineView.backgroundColor = ColorFromRGB(219,219, 219);
    
    [baodanImageView addSubview: lineView];
    
    //按钮显示图片
    CGFloat  buttonX = lineView.x;
    CGFloat  buttonY = lineView.y+textY;
    CGFloat buttonHeight =  self.view.height-(baodanImageViewMarginTopWithBottom*2)-(10*2)-lineView.y;
    
    UIButton *  buttonImage= [UIButton  buttonWithType:UIButtonTypeSystem] ;
    
    buttonImage.frame = CGRectMake(buttonX, buttonY, width, buttonHeight);
    
    [buttonImage  addTarget:self action:@selector(hideBaodanImageView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSURL * reverseUrl = [NSURL  URLWithString: url ];
    
    [[SDWebImageManager  sharedManager] downloadImageWithURL:reverseUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        [ buttonImage  setImage: [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    }];
    
    [baodanImageView addSubview: buttonImage];
    
    baodanImageView.backgroundColor = [UIColor whiteColor];
    self.baodanImageView = baodanImageView;
    
    [self.view addSubview: baodanImageView];
    
    [baodanImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(baodanImageViewMarginTopWithBottom, baodanImageViewMarginRightWithLeft, baodanImageViewMarginTopWithBottom, baodanImageViewMarginRightWithLeft));
    }];

}

-(void) hideBaodanImageView:(UIButton *) sender
{
    [self hideCover:self.cover];
}



- (void)viewWillDisappear: (BOOL)animated
{
    [super  viewWillDisappear:animated];
    [self.navigationController  setNavigationBarHidden:YES animated:NO];
    
    self.insurePayWayUIView = nil;
}

-(InsureHeadView *)insureHeadView
{
    if(_insureHeadView==nil){
        InsureHeadView * insureHead = [[[NSBundle mainBundle] loadNibNamed:@"InsureHeadView" owner:nil options:nil] lastObject];
        self.insureHeadView = insureHead;
    }
    return  _insureHeadView;
}

-(InsureFooterView *)insureFooterView
{
    if(_insureFooterView ==nil){
        InsureFooterView *  insure = [[[NSBundle mainBundle] loadNibNamed:@"InsureFooterView" owner:nil options:nil] lastObject];
        self.insureFooterView = insure;
    }
    
    return  _insureFooterView;
}

-(CarInfoTableViewController *)carInfoTableViewController
{
    if(_carInfoTableViewController==nil){
        _carInfoTableViewController = [[CarInfoTableViewController alloc] init];
    }
    return  _carInfoTableViewController;
}


-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}



-(void)  back
{
    [self.navigationController  popViewControllerAnimated:YES];
}


#pragma mark -- 懒加载
-(HTTPManagerOfInsurance *)HTTPManager{
    if (_HTTPManager == nil) {
        _HTTPManager = [HTTPManagerOfInsurance sharedHTTPManagerOfInsurance];
    }
    return _HTTPManager;
}

@end
