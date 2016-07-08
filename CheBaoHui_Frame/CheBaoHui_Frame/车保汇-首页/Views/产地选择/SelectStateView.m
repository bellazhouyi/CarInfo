//
//  SelectStateView.m
//  Template_Joker
//
//  Created by Bella on 16/3/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SelectStateView.h"

@interface SelectStateView ()<UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;

#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;


@property(nonatomic,strong) NSMutableArray *stateMutableArray;

@property(nonatomic,strong) NSMutableArray *danWeiMutableArray;

@property(nonatomic,strong) NSString *state;


@end



@implementation SelectStateView

#pragma mark -- 设置初始视图
-(void)setOriginalViewWithArray:(NSArray *)array{
    self.stateMutableArray = [NSMutableArray arrayWithCapacity:20];
    
    self.customPicker.delegate = self;
    self.customPicker.dataSource = self;
    [self.stateMutableArray removeAllObjects];
    [self.stateMutableArray addObjectsFromArray:array];
    
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (1 == component) {
        self.state = [NSString stringWithFormat:@"%@",self.stateMutableArray[row]];
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
    
     if (component == 1)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%@",self.stateMutableArray[row]];
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
    
     if (1 == component){
        return self.stateMutableArray.count;
     }else{
         return 0;
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
                         self.passCancleSige();
                     }];
    
    
}

#pragma mark -- 日期选择完成
- (IBAction)actionDone:(id)sender
{
    //0--进口，1--国产
    NSString *state ;
    if (_state == nil) {
        state = [self.stateMutableArray objectAtIndex:0];
    }else{
        state = _state;
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
                             
                             self.passState(state);
                             
                         });
                         
                     }];
    
    
    
}






@end
