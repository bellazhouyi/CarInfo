//
//  JJTextField.m
//  JJTools
//
//  Created by pengshuai on 15/6/10.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "JJTextField.h"

@implementation JJTextField

-(void)layoutSubviews{
    if(self.placeholderColor){
        [self setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    [super layoutSubviews];
}


-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    _placeholderColor = placeholderColor;
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
}

@end
