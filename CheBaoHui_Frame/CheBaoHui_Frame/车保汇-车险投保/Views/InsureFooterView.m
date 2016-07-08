//
//  InsureFooterView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InsureFooterView.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

@interface InsureFooterView()
@property (weak, nonatomic) IBOutlet UIButton *paymentButton;

@end

@implementation InsureFooterView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}
- (IBAction)payClick:(id)sender {

    if([self.delegate  respondsToSelector:@selector(insureFooterViewClick)]){
        [self.delegate  insureFooterViewClick];
    }
}


-(void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [self.paymentButton setTitle: buttonTitle forState:UIControlStateNormal];
}

-(void)awakeFromNib
{
    [self.paymentButton.layer setMasksToBounds:YES];
    [self.paymentButton.layer  setCornerRadius:5.0f];

}


@end
