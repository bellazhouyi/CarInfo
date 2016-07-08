//
//  PayWayUIView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PayWayUIView.h"
#import "RadioButton.h"


@interface PayWayUIView()

@property (nonatomic, strong) IBOutlet RadioButton* radioButton;

-(IBAction)onRadioBtn:(id)sender;

@end

@implementation PayWayUIView


-(IBAction)onRadioBtn:(RadioButton * )sender
{
    if(sender.tag  ==1){
        self.payWay(sender.tag );  // tag 是当前点击的按钮
    }else if(sender.tag  ==2){ // 代领
        self.payWay( sender.tag );  // tag 是当前点击的按钮
    }else if(sender.tag  ==3){ //快递
        self.payWay( sender.tag );  // tag 是当前点击的按钮
    }else if(sender.tag == 4){
        self.payWay(sender.tag);
    }


}



@end
