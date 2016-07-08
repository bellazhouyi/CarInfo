//
//  PayWayUIView.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PayWay) (NSInteger tag);

@interface PayWayUIView : UIView

@property (nonatomic , copy) PayWay  payWay;

@end
