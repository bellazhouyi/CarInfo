//
//  MineViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineViewCell.h"

#import "UIView+Extension.h"
#import "MineItemModel.h"
#import "CustomRefreshHeader.h"
#import "UILabel+Extension.h"
#import "UIImage+Extension.h"

@interface MineViewCell()

/**
 *  名字
 */
@property (nonatomic , strong) UILabel * funcNameLabel;


@property (nonatomic , strong) UILabel * synopsisNameLabel;


/**
 *  标题图片
 */
@property (nonatomic , strong) UIImageView * imgView;


@property (nonatomic , strong) UIImageView * indicator;


@property (nonatomic , strong)  UILabel * detailLabel;


@property (nonatomic , strong) UIImageView * detailImageView;


@property (nonatomic,strong) UISwitch *aswitch;

@end

@implementation MineViewCell


-(void)setItem:(MineItemModel *)item
{
    _item = item;
    [self  updateUI];
    
}

-(void) updateUI
{
    [self.contentView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
   // self.contentView.height = 50;
    //如果有图片
    if(self.item.img){
        [self setupImgView];
    }
    //名字
    if(self.item.funcName){
        [self setupFuncLabel];
    }
    
    //类型
    if(self.item.accessoryType){
        [self setupAccessoryType];
    }
    //详细信息
    if(self.item.detailText){
        [self setupDetailText];
    }
    
    //图片
    if(self.item.detailImage){
        [self  setupDetailImage];
    }
    
    if(self.item.synopsisName){
        [self  setupSynopsisName];
    }
    
    if(self.item.hasColordetailText){
         [self   setupHasColordetailText];
        
    }
    
    if(self.item.headerImageUrl){
        [self setupHeaderImageUrl];
    }
    
    if(self.item.detailImageUrl){
        [self setupDetailImage];
    }
    
    
    
//    UIView * bottomLine = [[UIView alloc] initWithFrame: CGRectMake( 0 ,self.height- 1,SCREEN_HEIGHT,1)];
//    bottomLine.backgroundColor = ColorFromRGBA(234, 234, 234, 1);
//    [self.contentView  addSubview: bottomLine];
//
    
}



-(void) setupHeaderImageUrl
{
    
    NSURL * url = [NSURL  URLWithString:self.item.headerImageUrl];
    //下载图片
    [[SDWebImageManager  sharedManager] downloadImageWithURL: url  options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.detailImageView  = [[UIImageView  alloc] initWithImage:[image  transformtoSize:CGSizeMake(200, 200) image:image]
                                 ];
        
        self.detailImageView.width = 40;
        self.detailImageView.height = 40;
         self.detailImageView.centerY =  self.contentView.centerY;
        if(self.item.accessoryType == MineAccessoryTypeHeadPortrait){
            self.detailImageView.backgroundColor = [UIColor  redColor];
            self.detailImageView.layer.masksToBounds = YES;
            self.detailImageView.layer.cornerRadius =self.detailImageView.frame.size.width  / 2;
            self.detailImageView.x = SCREEN_WIDTH - self.detailImageView.width - DetailViewToIndicatorGap - 2;
        }
        [self.contentView addSubview: self.detailImageView];
    }];

    
}


/**
 *  标注文字
 */
-(void ) setupSynopsisName
{
    self.synopsisNameLabel = [[UILabel alloc] init];
    self.synopsisNameLabel.text = self.item.synopsisName;
    self.synopsisNameLabel.textColor =[UIColor  blackColor]; //ColorFromRGBA(51, 51, 51, 1);
    self.synopsisNameLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    self.synopsisNameLabel.size  = [self.synopsisNameLabel sizeForTitle: self.item.synopsisName withFont: self.synopsisNameLabel.font];
    if(self.item.accessoryType == MineAccessoryTypeHeadPortrait){
        self.synopsisNameLabel.centerY = self.contentView.height / 2;
    } else {
        self.synopsisNameLabel.centerY = self.contentView.centerY;
        self.synopsisNameLabel.x  =  CGRectGetMaxX(self.funcNameLabel.frame ) + FuncImgToLeftGap;
    }
    [self.contentView addSubview: self.synopsisNameLabel];
}

/**
 *  设置有颜色的字体
 */
-(void) setupHasColordetailText
{
    [self setDetailText: ColorFromRGB(56, 148, 225)   text: self.item.hasColordetailText];
}

-(void) setupDetailImage
{
    if(self.item.detailImageUrl!=nil){
        NSURL * url = [NSURL  URLWithString:self.item.detailImageUrl];
        [[SDWebImageManager  sharedManager] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage *   idCardFront = [image  transformtoSize: CGSizeMake(60, 40) image: image];
            self.detailImageView= [[UIImageView alloc] initWithImage: idCardFront];
        }];
    }else{
        self.detailImageView  = [[UIImageView  alloc] initWithImage: self.item.detailImage];
    }
    
    
    
    self.detailImageView.width = 60;
    self.detailImageView.height = 40;
    
    self.detailImageView.centerY =  self.contentView.centerY;
    switch (self.item.accessoryType) {
        case  MineAccessoryTypeNone:
            self.detailImageView.x = SCREEN_WIDTH - self.detailImageView.width - DetailViewToIndicatorGap - 2;
            break;
           case MineAccessoryTypeDisclosureIndicator:
            self.detailImageView.x = self.indicator.x  - self.detailImageView.width - DetailViewToIndicatorGap;
            break;
            case  MineAccessoryTypeSwitch:
                self.detailImageView.x = self.aswitch.x  - self.detailImageView.width - DetailViewToIndicatorGap;
            break;
            
        case MineAccessoryTypeHeadPortrait:
                self.detailImageView.backgroundColor = [UIColor  redColor];
                self.detailImageView.layer.masksToBounds = YES;
                self.detailImageView.layer.cornerRadius =self.detailImageView.frame.size.width  / 2;
                self.detailImageView.x = SCREEN_WIDTH - self.detailImageView.width - DetailViewToIndicatorGap - 2;
            break;
        default:
            break;
    }
    [self.contentView addSubview: self.detailImageView];
    
}


-(void) setupDetailText
{
    [self  setDetailText: ColorFromRGBA(142, 142, 142, 1) text: self.item.detailText];
}

//ColorFromRGBA(142, 142, 142, 1)
-(void) setDetailText :(UIColor  * )color  text :(NSString  *) text
{
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = text;
    self.detailLabel.textColor = color;
    self.detailLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    
    self.detailLabel.size = [self.detailLabel sizeForTitle: text withFont:self.detailLabel.font];
    self.detailLabel.centerY = self.contentView.centerY;
    
    switch ( self.item.accessoryType) {
        case  MineAccessoryTypeNone:
            self.detailLabel.x = SCREEN_WIDTH - self.detailLabel.width -DetailViewToIndicatorGap -2;
            break;
        case  MineAccessoryTypeDisclosureIndicator:
            self.detailLabel.x = self.indicator.x  - self.detailLabel.width -DetailViewToIndicatorGap;
            
            break;
        case  MineAccessoryTypeSwitch:
            self.detailLabel.x = self.aswitch.x - self.detailLabel.width -DetailViewToIndicatorGap;
            break;
        default:
            break;
    }
    [self.contentView addSubview: self.detailLabel];
    
    
}


-(void) setupAccessoryType
{
    switch (self.item.accessoryType) {
        case MineAccessoryTypeNone:
            break;
        case MineAccessoryTypeDisclosureIndicator:
            [self setupIndicator] ;
            break;
        case MineAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        default:
            break;
    }
}

-(void) setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc] init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor =[UIColor  blackColor]; //ColorFromRGBA(51, 51, 51, 1);
    self.funcNameLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    self.funcNameLabel.size  = [self.funcNameLabel sizeForTitle: self.item.funcName withFont: self.funcNameLabel.font];

    if(self.item.accessoryType == MineAccessoryTypeHeadPortrait){
        self.funcNameLabel.centerY = self.contentView.height / 2;
        self.funcNameLabel.x  =  CGRectGetMaxX(self.imgView.frame ) + FuncImgToLeftGap;
    } else if(self.item.accessoryType == MineAccessoryTypeCenter){
        self.funcNameLabel.centerY = self.contentView.centerY;
        self.funcNameLabel.centerX =SCREEN_WIDTH * 0.5;
    } else{
        self.funcNameLabel.centerY = self.contentView.centerY;
        self.funcNameLabel.x  =  CGRectGetMaxX(self.imgView.frame ) + FuncImgToLeftGap;
    }
    
    [self.contentView addSubview: self.funcNameLabel];
}


-(void) setupImgView
{
    self.imgView = [[UIImageView  alloc] initWithImage:self.item.img];
    self.imgView.x = FuncImgToLeftGap;
    self.imgView.height = self.imgView.height * 0.6;
    self.imgView.width = self.imgView.width * 0.6;
    self.imgView.centerY = self.contentView.centerY;
    [self.contentView addSubview: self.imgView];
}




- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setupSwitch
{
    [self.contentView addSubview:self.aswitch];
}

-(void) setupIndicator
{
     [self.contentView addSubview:self.indicator];
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

-(UISwitch * ) aswitch
{
    if(!_aswitch){
        _aswitch = [[UISwitch alloc] init];
        _aswitch.centerY = self.contentView.centerY;
        _aswitch.x  = SCREEN_WIDTH -_aswitch.width - IndicatorToRightGap;
        [_aswitch addTarget:self action: @selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return  _aswitch;
}


#pragma mark -- 消息推送 是否
- (void)switchTouched:(UISwitch *)sw
{
    __weak typeof(self)  weakSelf = self;
//    self.item.switchValueChanged(weakSelf.aswitch.isOn);
    
}




@end

