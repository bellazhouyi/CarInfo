//
//  SelectDateView.m
//  Template_Joker
//
//  Created by Bella on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SelectMoneyView.h"
#define currentMonth [currentMonthString integerValue]

@interface SelectMoneyView ()<UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;

#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;


@property(nonatomic,strong) NSMutableArray *moneyNumberMutableArray;

@property(nonatomic,strong) NSMutableArray *danWeiMutableArray;

@property(nonatomic,strong) NSString *moneyNumber;

@property(nonatomic,strong) NSString *danWei;

@property(nonatomic,strong) NSString *unit;

@end


@implementation SelectMoneyView

#pragma mark -- 设置初始视图
-(void)setOriginalViewWithNumberArray:(NSArray *)array withUnit:(NSString *)unit{
    self.moneyNumberMutableArray = [NSMutableArray arrayWithCapacity:20];
    
    //清除上一次数据
    [self.moneyNumberMutableArray removeAllObjects];
    
    [self.moneyNumberMutableArray addObjectsFromArray:array];
    
    [self.danWeiMutableArray removeAllObjects];
    [self.danWeiMutableArray addObject:unit];
    
    self.unit = unit;
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (1 == component) {
        self.moneyNumber = [NSString stringWithFormat:@"%@",self.moneyNumberMutableArray[row]];
    }
    if (2 == component) {
        self.danWei = _unit;
    }
}


#pragma mark - UIPickerViewDatasource
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width * 0.3, self.bounds.size.height * 0.5);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20.0f]];
    }
    
    
    if (component == 0)
    {
        
    }
    else if (component == 1)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@",self.moneyNumberMutableArray[row]];
    }
    else if (component == 2)
    {
        pickerLabel.text = _unit;
        
    }
    
    
    return pickerLabel;
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return pickerView.bounds.size.height * 0.4;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (0 == component) {
        return 0;
    }else if (1 == component){
        return self.moneyNumberMutableArray.count;
    }else{
        return 1;
    }
    
}




#pragma mark -- 取消

- (IBAction)actionCancel:(id)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.hidden = YES;
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}

#pragma mark -- 日期选择完成
- (IBAction)actionDone:(id)sender
{
    
    NSString *money ;
    
    if (self.moneyNumber == nil && self.moneyNumber.length == 0) {
        money = [self.moneyNumberMutableArray objectAtIndex:0];
    }else{
        money = self.moneyNumber;
    }
    
    NSString *danwei ;
    if (self.danWei == nil && self.danWei.length == 0) {
        danwei = _unit;
    }else{
        danwei = self.danWei;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.hidden = YES;
                         
                     }
                     completion:^(BOOL finished){
                         //回调，传值
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             self.passMoney([NSString stringWithFormat:@"%@",money],danwei);
                         });
                         
                     }];
    
    
    
}



@end
