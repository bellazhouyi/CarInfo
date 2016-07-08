//
//  BrokerageListCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BrokerageListCell.h"
#import "BrokerageListModel.h"
#import "UIView+Extension.h"
#import "UILabel+Extension.h"
#import "DateTools.h"



#define leftMargin   20

@interface BrokerageListCell()

/**
 *  周
 */
@property (strong, nonatomic)  UILabel *weekLabel;

/**
 *  佣金
 */
@property (strong, nonatomic)  UILabel *commissionLabel;
/**
 *  日期
 */
@property (strong, nonatomic)  UILabel *dateLabel;

@property (strong,nonatomic) UILabel * descLabel;



@end

@implementation BrokerageListCell


-(void) setBrokerage:(BrokerageListModel *)brokerage
{
    _brokerage = brokerage;
    
    [self.contentView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.contentView.height = 60;
    
    if(brokerage.Cd_Date!=nil){
        [self  setupWeek:brokerage.Cd_Date ];
        [self setupMonthAndDay :brokerage.Cd_Date];
    }
    
    if(brokerage.Amount!=nil){
        [self  setupAmout : brokerage.Amount];
    }
    
    if(brokerage.Title !=nil){
        [self  setupTitle :brokerage.Title];
    }

}


-(void)setDescTitle:(NSString *)descTitle
{
    _descTitle = descTitle;
    
}

-(void) setupTitle:(NSString * )  title
{
    self.descLabel = [[UILabel alloc] init];
    
    NSString * newDescTitle ;
    switch (self.brokerageType) {
        case BrokerageTypeIncome:{
           newDescTitle  = [NSString  stringWithFormat:@"%@%@",title ,self.descTitle];
        }
            break;
            case BrokerageTypeExamine:{
            newDescTitle  = [NSString  stringWithFormat:@"%@",self.descTitle];
        }
            break;
           case BrokerageTypeWithdrawCash:{
               newDescTitle  = [NSString  stringWithFormat:@"%@",self.descTitle];
        }
            break;
        default:
            break;
    }
    
    self.descLabel.text = newDescTitle;
    
    self.descLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    
    self.descLabel.size = [self.descLabel  sizeForTitle: newDescTitle withFont:self.descLabel.font];
    
    self.descLabel.x = self.commissionLabel.x;
    self.descLabel.y = self.self.dateLabel  .y;
    self.descLabel.textColor = ColorFromRGB(153, 153, 153);
    
    [self.contentView addSubview: self.descLabel];
    
}

//设置佣金
-(void) setupAmout :(NSNumber * ) amount
{
    self.commissionLabel = [[UILabel alloc] init];
    NSString * str = [NSString  stringWithFormat:@"+%@",[amount  stringValue]];
    self.commissionLabel.text = str;

    self.commissionLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    
    self.commissionLabel.x = self.weekLabel.width+leftMargin+10;
    self.commissionLabel.y = self.weekLabel.y;
    
    self.commissionLabel.size  = [self.weekLabel sizeForTitle: str withFont: self.commissionLabel.font];
    
    [self.contentView addSubview: self.commissionLabel];
    
}

//设置日期
-(void) setupMonthAndDay :(NSString *) date
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSDate *  newDate = [DateTools  StringDateForDate: date format:@"yyyy-MM-dd HH:mm:ss"];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:newDate];
    [dateformatter setDateFormat:@"dd"];
    NSString * dayString = [dateformatter stringFromDate:newDate];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text =[NSString  stringWithFormat:@"%@-%@",monthString,dayString];
    
    self.dateLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    
    self.dateLabel.size  = [self.weekLabel sizeForTitle: date withFont: self.weekLabel.font];
    
    self.dateLabel.y =  self.weekLabel.y+25;
    
    self.dateLabel.x = leftMargin;
    
    self.dateLabel.textColor = ColorFromRGB(119,119, 119);
    
    [self.contentView addSubview: self.dateLabel];
    
 
}

/**
 *  一周7天
 */
-(void) setupWeek :(NSString * )  date
{
    /**
     星期    金额
     日期
     */
    self.weekLabel = [[UILabel alloc] init];

    NSArray * weekDays = [NSArray arrayWithObjects: [NSNull null], @"周天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSDate *  newDate = [DateTools  StringDateForDate: date format:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * str = [DateTools  weekdayStringForDate:newDate weekdays:weekDays];
    
    self.weekLabel.textColor =  ColorFromRGB(104, 104, 104);
    
    self.weekLabel.text  =str;
    
    self.weekLabel.y = 10;
    
    self.weekLabel.x = leftMargin;
    
    [self.contentView addSubview: self.weekLabel];
    
    
    self.weekLabel.font = [UIFont  systemFontOfSize:FuncLabelFont];
    
    self.weekLabel.size  = [self.weekLabel sizeForTitle: str withFont: self.weekLabel.font];
    
    [self.contentView addSubview: self.weekLabel];
    
}


- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
