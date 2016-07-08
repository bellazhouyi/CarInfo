//
//  SelectDateView.m
//  Template_Joker
//
//  Created by Bella on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SelectDateView.h"
#define currentMonth [currentMonthString integerValue]

@interface SelectDateView ()<UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;

#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;

@property(nonatomic,strong) NSDateFormatter *dateFormatter;


@end


@implementation SelectDateView
{
    
    NSMutableArray *yearArray;
    NSMutableArray *yearMutableArray;
    NSMutableArray *monthArray;
    NSMutableArray *monthMutableArray;
    NSMutableArray *DaysArray;
    NSMutableArray *DaysMutableArray;
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSInteger m ;
    int year;
    int month;
    int day;
    
}

#pragma mark -- 设置初始视图
-(void)setOriginalViewWithDateString:(NSString *)dateStr{
    
    // Get Current Year
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date ;
    if ([NSString isDate:dateStr]) {
        
        date = [_dateFormatter dateFromString:dateStr];
        
    }else{
        
        date = [NSDate date];
    }
    
    [_dateFormatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [_dateFormatter stringFromDate:date]];
    year =[currentyearString intValue];
    
    
    // Get Current  Month
    
    [_dateFormatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[_dateFormatter stringFromDate:date]integerValue]];
    month=[currentMonthString intValue];
    
    
    // Get Current  Date
    [_dateFormatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[_dateFormatter stringFromDate:date]];
    
    day =[currentDateString intValue];
    
    [yearArray removeAllObjects];
    [yearMutableArray removeAllObjects];
    yearArray = [[NSMutableArray alloc]init];
    yearMutableArray = [[NSMutableArray alloc] init];
    
    for (int i = 1970; i <= year ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    [monthArray removeAllObjects];
    monthArray = [[NSMutableArray alloc] init];
    int indexOfMonth = 0 ;
    for (int i = 1; i <= 12; i++) {
        [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
        if (i == month) {
            [self.customPicker selectRow:indexOfMonth inComponent:1 animated:YES];
        }
        indexOfMonth ++;
    }
    
    
    
    // --Days data
    [DaysArray removeAllObjects];
    [DaysMutableArray removeAllObjects];
    DaysArray = [[NSMutableArray alloc]init];
    DaysMutableArray= [[NSMutableArray alloc]init];
    
    int indexOfDay = 0 ;
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        if (i == day) {
            [self.customPicker selectRow:indexOfDay inComponent:2 animated:YES];
        }
        indexOfDay ++;
    }
    
    
    
    //设置默认值
    [self.customPicker selectRow:(yearArray.count - 1) inComponent:0 animated:YES];
    
    
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.customPicker reloadAllComponents];
        
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
        CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width * 0.3, self.bounds.size.height * 0.4);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20.0f]];
    }
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
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
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        
            return [monthArray count];
    
    }
    else
    {
        NSInteger selectRow1 =  [pickerView selectedRowInComponent:0];
        int n;
        n= year-1970;
        NSInteger selectRow =  [pickerView selectedRowInComponent:1];
        
        if (selectRow==month-1 &selectRow1==n) {
            
            return day;
            
        }else{
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
        }
        
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
    
    //获取到当前拼接好的日期
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ ",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.hidden = YES;
                         
                     }
                     completion:^(BOOL finished){
                         //回调，传值
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             self.passDate(dateStr);
                         });
                         
                     }];
    
    
    
}

#pragma mark - 懒加载
-(NSDateFormatter *)dateFormatter{
    if (nil == _dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
    }
    return _dateFormatter;
}



@end
