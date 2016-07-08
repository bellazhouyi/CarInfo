//
//  DetailViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DetailViewCell.h"
#import "DetailModel.h"
#import "UIView+Extension.h"
#import "UILabel+Extension.h"

#define  GlobalFontSize  14
#define   blueColor  ColorFromRGB(55, 152,215)

@interface DetailViewCell()

@property (nonatomic , strong) UILabel * headerTitleLabel;

@property (nonatomic , strong) UILabel * detailsTextLabel;

@property (nonatomic , strong) UIImageView *  callImage;

@property (nonatomic , strong) UIImageView * indicator;

@property (nonatomic , strong) UILabel * ownerNameTextLabel;

@property (nonatomic , strong) UIView * radioView;

@property (nonatomic , strong) UIImageView * statusImage;

@property (nonatomic , strong) UITextField * inputTextFiled;

@property (nonatomic , strong) UIButton * button1;

@property (nonatomic , strong) UIButton * button2;

@end

@implementation DetailViewCell

- (void)awakeFromNib {
}

-(void)setDetail:(DetailModel *)detail
{
    _detail = detail;
    [self  updateUI];
}

-(void ) updateUI
{
    [self.contentView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //头部title
    if(self.detail.headerTitle){
        [self setupHeaderTitle];
    }
    //详细
    if(self.detail.detailText){
        [self  setupDetailText];
    }
    
    //类型
    if(self.detail.accessoryType){
        [self setupAccessoryType];
    }
    //车主名字
    if(self.detail.ownerName){
        [self setupOwnerName];
    }
    
    //选择按钮
    if(self.detail.radioView){
        [self  setupRadioView];
    }
    //图片的地址
    if(self.detail.imageStr){
        [self  setupImageStr];
    }
    
    if(self.detail.leftLabel){
        [self setupLeftLabel];
    }
    
    if(self.detail.inputTextFiled){
        [self setupInputTextFiled];
    }
    
    if(self.detail.url1 || self.detail.url2){
        NSLog(@"%@",self.detail.url1);
        NSLog(@"%@",self.detail.url2);
        [self  setupButton1AndButton2];
    }
}



-(void) setupButton1AndButton2
{
    if(self.detail.url1!=nil){
        self.button1 = [[UIButton alloc]  init];
        self.button1.width = 30;
        self.button1.height = self.contentView.height-2;
        NSURL * reverseUrl = [NSURL  URLWithString:self.detail.url1 ];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:reverseUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [self.button1  setImage: image forState:UIControlStateNormal];
        }];
        self.button1.x =  SCREEN_WIDTH-self.button1.width-10;
        self.button1.tag = 1;
        [self.button1 addTarget:self action:@selector(zoomImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview: self.button1];
    }
    
    if(self.detail.url2!=nil){
        self.button2 = [[UIButton  alloc] init];
        self.button2.width = 30;
        self.button2.height = self.contentView.height-2;
        NSURL * reverseUrl = [NSURL  URLWithString:self.detail.url2 ];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:reverseUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [self.button2  setImage: image forState:UIControlStateNormal];
        }];
        if(self.button1!=nil){
            self.button2.x =SCREEN_WIDTH - self.button2.width - self.button1.width - 20;
        }else{
            self.button2.x =  SCREEN_WIDTH-self.button2.width-10;
        }
        self.button2.tag  = 2;
        [self.button2 addTarget: self action:@selector(zoomImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview: self.button2];
    }
}



-(void) zoomImage:(UIButton * ) sender
{
    if([self.delegate  respondsToSelector:@selector(callBackZoomImageUrl:)]){
        if(sender.tag ==1){
            [self.delegate  callBackZoomImageUrl: self.detail.url1];
        }else{
            [self.delegate  callBackZoomImageUrl: self.detail.url2];
        }
    }
}


-(void)setupInputTextFiled
{
    
    self.detail.inputTextFiled.width = self.contentView.width - self.headerTitleLabel.width;
    self.detail.inputTextFiled.height = self.contentView.height = self.contentView.height - 4;
    self.detail.inputTextFiled.centerY =self.contentView.centerY+1;
    self.detail.inputTextFiled.font = [UIFont   systemFontOfSize:GlobalFontSize];
    self.detail.inputTextFiled.x =  100;
    [self.contentView addSubview: self.detail.inputTextFiled];
    
//    
//    if(self.detail.placeholder){
//        self.inputTextFiled.placeholder = self.detail.placeholder;
//        
//    }else{
//        self.inputTextFiled.text = self.detail.inputText;
//    }
//    
    

    
}

-(void) setupLeftLabel
{
    self.headerTitleLabel = [[UILabel alloc] init];
    self.headerTitleLabel.text = self.detail.leftLabel;
    self.headerTitleLabel.centerY = self.contentView.centerY * 0.5;
    
    self.headerTitleLabel.x = FuncImgToLeftGap;
    
    self.headerTitleLabel.size  = [self.headerTitleLabel sizeForTitle: self.detail.leftLabel withFont: self.headerTitleLabel.font];
    self.headerTitleLabel.font = [UIFont  systemFontOfSize:GlobalFontSize];
    
    if(self.detail.accessoryType==DetailAccessoryTypeTextBlackWithInputText){
         self.headerTitleLabel.x = FuncImgToLeftGap+10;
    }
    [self.contentView addSubview: self.headerTitleLabel];
}


-(void) setupImageStr
{
    [self.contentView addSubview: self.statusImage];
}

/**
 *  设置radioview
 */
-(void) setupRadioView
{
    self.radioView =  self.detail.radioView;
    [self.contentView  addSubview: self.radioView];
}


-(void) setupOwnerName
{
    self.ownerNameTextLabel = [[UILabel alloc] init];
    
    self.ownerNameTextLabel.text = self.detail.ownerName;
    
    self.ownerNameTextLabel.centerY = self.contentView.centerY * 0.5;
    
    self.ownerNameTextLabel.size  = [ self.ownerNameTextLabel sizeForTitle:self.detail.ownerName withFont: self.ownerNameTextLabel.font];
    if(self.detail.accessoryType == DetailAccessoryTypeOwnerNameAndImage){
        self.ownerNameTextLabel.textColor = blueColor;
        self.ownerNameTextLabel.x =self.callImage.x- self.ownerNameTextLabel.width-2;
    }
    self.ownerNameTextLabel.font = [UIFont  systemFontOfSize:GlobalFontSize];
    [self.contentView addSubview: self.ownerNameTextLabel];
}

-(void) setupDetailText
{
    self.detailsTextLabel = [[UILabel alloc] init];
    self.detailsTextLabel.text = self.detail.detailText;
    self.detailsTextLabel.centerY = self.contentView.centerY * 0.5;
    self.detailsTextLabel.textAlignment = NSTextAlignmentRight;
  
    self.detailsTextLabel.size  = [ self.detailsTextLabel sizeForTitle:self.detail.detailText withFont: self.detailsTextLabel.font];
    self.detailsTextLabel.font = [UIFont  systemFontOfSize:GlobalFontSize];
    
    if(self.detail.accessoryType == DetailAccessoryTypeDisclosureIndicator){
        self.detailsTextLabel.x =self.indicator.x- self.detailsTextLabel.width;
    }else if(self.detail.accessoryType == DetailAccessoryTypeTextBlackAndBlueColor) {
        self.detailsTextLabel.x = SCREEN_WIDTH-self.detailsTextLabel.width-10;
        self.detailsTextLabel.textColor = blueColor;
    }else  if(self.detail.accessoryType == DetailAccessoryTypeTextBlackWithImageAndDate) {
        self.detailsTextLabel.x = SCREEN_WIDTH-self.detailsTextLabel.width-10;
        self.detailsTextLabel.textColor = blueColor;
    }else{
        self.detailsTextLabel.x = SCREEN_WIDTH-self.detailsTextLabel.width-10;
        self.detailsTextLabel.textColor = [UIColor  grayColor];
    }
    [self.contentView  addSubview: self.detailsTextLabel];
}


-(void) setupHeaderTitle
{
    self.headerTitleLabel = [[UILabel alloc] init];
    self.headerTitleLabel.text = self.detail.headerTitle;
    self.headerTitleLabel.centerY = self.contentView.centerY * 0.5;
    self.headerTitleLabel.x = FuncImgToLeftGap;
    
    self.headerTitleLabel.size  = [self.headerTitleLabel sizeForTitle: self.detail.headerTitle withFont: self.headerTitleLabel.font];
    self.headerTitleLabel.font = [UIFont  systemFontOfSize:GlobalFontSize];
    
    switch (self.detail.accessoryType) {
        case  DetailAccessoryTypeNone:{
            self.headerTitleLabel.textColor = blueColor;
        }
            break;
        case   DetailAccessoryTypeOwnerNameAndImage:{
            self.headerTitleLabel.textColor = [UIColor  blackColor];
        }
            break;
            case   DetailAccessoryTypeDisclosureIndicator:{
            self.headerTitleLabel.textColor = blueColor;
        }
            break;
            
            case DetailAccessoryTypeTextBlackAndBlueColor:{
             self.headerTitleLabel.textColor = [UIColor  blackColor];
                self.headerTitleLabel.x = FuncImgToLeftGap+10;
        }
            break;
            case DetailAccessoryTypeTextGrayColor:{
             self.headerTitleLabel.textColor = [UIColor  grayColor];
        }
            break;
        case DetailAccessoryTypeTextBlackWithImageAndDate:{
               self.headerTitleLabel.x = 10;
        }break;
            
         case DetailAccessoryTypeTextBlackWithInputText:
            
            break;

    }
    
    [self.contentView addSubview: self.headerTitleLabel];
    
}


-(void) setupIndicator
{
    [self.contentView addSubview:self.indicator];
}

-(void) setupCallImage
{
    [self.contentView addSubview: self.callImage];
}

-(UIImageView * ) indicator
{
    if(!_indicator){
        _indicator = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"icon-arrow1"]];
        _indicator.centerY = self.contentView.centerY;
        _indicator.x = SCREEN_WIDTH - _indicator.width - IndicatorToRightGap;
    }
    return  _indicator;
}


-(UIImageView *)callImage
{
    if(!_callImage){
        _callImage = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"icon-list01"]];
        _callImage.centerY = self.contentView.centerY;
        _statusImage.height = _statusImage.height * 0.5;
        _statusImage.width = _statusImage.width * 0.5;
        _callImage.x = SCREEN_WIDTH - _callImage.width - IndicatorToRightGap;
    }
    return  _callImage;
}

-(UIImageView * )statusImage
{
    if(!_statusImage){
        _statusImage = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:self.detail.imageStr]];
        
        _statusImage.height = _statusImage.height * 0.5;
        _statusImage.width = _statusImage.width * 0.5;
        
        
        _statusImage.centerY = self.contentView.centerY;
        _statusImage.x = SCREEN_WIDTH - _statusImage.width - IndicatorToRightGap;
    }
    return  _statusImage;
}


-(void) setupAccessoryType
{
    if(self.detail.accessoryType == DetailAccessoryTypeDisclosureIndicator){
        [self setupIndicator] ;
    }else if(self.detail.accessoryType == DetailAccessoryTypeOwnerNameAndImage){
        [self setupCallImage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
