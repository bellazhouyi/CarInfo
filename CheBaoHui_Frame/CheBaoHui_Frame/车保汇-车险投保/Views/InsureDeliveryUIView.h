//
//  RadioUIView.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/18.
//  Copyright © 2016年 Joker. All rights reserved.
//


#import <UIKit/UIKit.h>

@class  RadioButton;

typedef void(^InsureDeliver) (NSInteger tag);

@interface InsureDeliveryUIView : UIView

@property (nonatomic ,weak) id  delegate;

@property (nonatomic , copy) InsureDeliver  insureDeliver;


@end
