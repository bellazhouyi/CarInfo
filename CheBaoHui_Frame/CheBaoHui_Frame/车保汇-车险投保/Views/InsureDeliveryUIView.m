//
//  RadioUIView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InsureDeliveryUIView.h"
#import "RadioButton.h"


@interface  InsureDeliveryUIView()

@property (nonatomic, strong) IBOutlet RadioButton* radioButton;



-(IBAction)onRadioBtn:(id)sender;

@end

@implementation InsureDeliveryUIView


-(IBAction)onRadioBtn:(RadioButton *)sender
{
    if(sender.tag  ==1){
         self.insureDeliver(sender.tag );  //  tag 是当前点击的按钮
    }else if(sender.tag  ==2){ // 代领
        self.insureDeliver( sender.tag );  //  tag 是当前点击的按钮
    }else if(sender.tag  ==3){ //快递
        self.insureDeliver( sender.tag );  // tag 是当前点击的按钮
        
    }
}


@end
