//
//  DetailViewCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DetailModel;
@protocol DetailViewCellDelegate  <NSObject>

-(void) callBackZoomImageUrl:(NSString * ) url;

@end

@interface DetailViewCell : UITableViewCell


@property (nonatomic , strong) DetailModel * detail;

@property (nonatomic , weak) id  delegate;

@end
