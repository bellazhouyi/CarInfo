//
//  InsureFooterView.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  InsureFooterViewDelegate  <NSObject>

/**
 *  点击
 */
-(void) insureFooterViewClick;


@end

@interface InsureFooterView : UIView

@property (nonatomic , copy) NSString *  buttonTitle;

@property (nonatomic , weak) id  delegate;

@end
