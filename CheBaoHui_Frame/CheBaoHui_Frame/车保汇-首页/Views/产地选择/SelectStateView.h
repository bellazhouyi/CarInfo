//
//  SelectStateView.h
//  Template_Joker
//
//  Created by Bella on 16/3/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passSateOriginal)(NSString *state);

typedef void(^passCancleSige)();

@interface SelectStateView : UIView

@property(nonatomic,copy) passSateOriginal passState;
@property(nonatomic,copy) passCancleSige passCancleSige;

//设置原始视图
-(void)setOriginalViewWithArray:(NSArray *)array;


@end
