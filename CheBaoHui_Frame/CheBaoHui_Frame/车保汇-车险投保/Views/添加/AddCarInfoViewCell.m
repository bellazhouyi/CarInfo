//
//  AddCarInfoViewCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AddCarInfoViewCell.h"
#import "AddCarModel.h"
#import "UIView+Extension.h"
#import "UILabel+Extension.h"

#define   GlobalLeft 20
#define  GlobalMarginLeft 30

@interface AddCarInfoViewCell()


@property (nonatomic , strong) UILabel * leftTextLabel;

@property (nonatomic , strong) UIButton * downButton;

@property (nonatomic , strong) UILabel * rangeTextLabel;

@property (nonatomic , strong) UIImageView * indicator;

@property (nonatomic , strong) UITextField *  textFiled;

@property (nonatomic , strong) UIButton * selectDateButton;


@end

@implementation AddCarInfoViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setItem:(AddCarModel *)item
{
    _item = item;
    
    [self  updateUI];
    
}

-(void) updateUI
{
    [self.contentView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //类型
    if(self.item.accessoryType){
        [self setupAccessoryType];
    }
    
    
    if(self.item.leftText){
        [self  setupLeftText];
    }
    
    if(self.item.downImage){
        [self setupDownImage];
    }
    
    if(self.item.textFiled){
        [self setupTextFiled];
    }
    
    if(self.item.rangeName){
        [self setupRangeName];
    }
}


-(void) setupTextFiled
{
        self.textFiled = self.item.textFiled;
        self.textFiled.placeholder = self.item.placeholderText;
    self.textFiled.font  = [UIFont systemFontOfSize:15];
        self.textFiled.height = 40;
        self.textFiled.centerY = self.contentView.centerY;
    self.textFiled.x = self.leftTextLabel.width+GlobalMarginLeft;
    self.textFiled.width = self.contentView.width - self.leftTextLabel.width;
    
    if(self.item.accessoryType == AddCarAccessoryTypeHasRangeAndDownImage){
        self.textFiled.x = self.downButton.x+GlobalLeft;
        self.textFiled.width = self.contentView.width - self.leftTextLabel.width-self.rangeTextLabel.width-self.downButton.width;
        [self.contentView addSubview: self.textFiled];
    }else  if(self.item.accessoryType == AddCarAccessoryTypeDisclosureIndicator){
        self.selectDateButton = [[UIButton  alloc] init];
        [self.selectDateButton setTitle: self.item.placeholderText forState:UIControlStateNormal];
        self.selectDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.selectDateButton  setTitleColor:ColorFromRGB(211,211,215)  forState:UIControlStateNormal ];
        self.selectDateButton.titleLabel.font = [UIFont  systemFontOfSize:15];
        self.selectDateButton.height =self.contentView.height;
        self.selectDateButton.x = self.leftTextLabel.width+GlobalMarginLeft;
        self.selectDateButton.width = self.contentView.width - self.leftTextLabel.width;
        
        self.selectDateButton.tag = self.item.dateType;
        
        [self.selectDateButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview: self.selectDateButton];
        
    }else{
        [self.contentView addSubview: self.textFiled];
    }
}

/**
 * 弹出日期
 */
-(void) selectDate :(UIButton *) button
{
    //发出代理,
    if([self.delegate respondsToSelector:@selector(addCarInfoViewShowPickerDateWithTitle:withTag:)]){
        [self.delegate  addCarInfoViewShowPickerDateWithTitle:self.leftTextLabel.text withTag:button.tag];
    }
}

-(void) setupDownImage
{
    self.downButton = [[UIButton alloc]  init];
    self.downButton.width = 14;
    self.downButton.height  = 10;
    [self.downButton setImage: [UIImage  imageNamed:self.item.downImage]
                     forState:UIControlStateNormal];
    self.downButton.centerY = self.contentView.centerY;
    
    if(self.item.accessoryType == AddCarAccessoryTypeHasRangeAndDownImage){
        self.downButton.x = self.leftTextLabel.width +self.rangeTextLabel.width+44;
    }
    
    [self.contentView addSubview:self.downButton];
}



-(void) setupRangeName
{
    self.rangeTextLabel = [[UILabel alloc] init];
    self.rangeTextLabel.text = self.item.rangeName;
    self.rangeTextLabel.textColor = [UIColor  blackColor];
    self.rangeTextLabel.font = [UIFont  systemFontOfSize: FuncLabelFont];
    self.rangeTextLabel.size = [self.rangeTextLabel  sizeForTitle: self.item.rangeName withFont:self.leftTextLabel.font];
    self.rangeTextLabel.centerY = self.contentView.centerY;
    if(self.item.accessoryType == AddCarAccessoryTypeHasRangeAndDownImage){
        self.rangeTextLabel.x = self.leftTextLabel.width +  GlobalMarginLeft;
    }
    self.rangeTextLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.rangeTextLabel];
}

-(void) setupLeftText
{
    self.leftTextLabel = [[UILabel alloc] init];
    self.leftTextLabel.text = self.item.leftText;
    self.leftTextLabel.textColor =[UIColor  blackColor]; //ColorFromRGBA(51, 51, 51, 1);
    self.leftTextLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    self.leftTextLabel.size  = [self.leftTextLabel sizeForTitle: self.item.leftText withFont: self.leftTextLabel.font];
    self.leftTextLabel.centerY = self.contentView.centerY;
    self.leftTextLabel.x  =  FuncImgToLeftGap;
    [self.contentView addSubview: self.leftTextLabel];
}

-(void) setupAccessoryType
{
    switch (self.item.accessoryType) {
        case AddCarAccessoryTypeNone:
            break;
        case AddCarAccessoryTypeDisclosureIndicator:
            [self setupIndicator] ;
            break;
        default:
            break;
    }
    
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




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
