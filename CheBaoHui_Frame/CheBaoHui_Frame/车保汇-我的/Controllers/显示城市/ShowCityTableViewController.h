//
//  ShowCityTableViewController.h
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/16.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  城市Model
 *
 *  @param cityName <#cityName description#>
 */
typedef void(^passCityName)(NSString *cityName,NSString *cityCode);


@interface ShowCityTableViewController : UITableViewController


@property(nonatomic,strong) id responseObject;

@property(nonatomic,copy) passCityName passCityName;

@end
