//
//  LocationManager.h
//  BaiduMap
//
//  Created by pengshuai on 15/4/22.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+(LocationManager*)sharedInstance;
/**
 *  更新位置
 */
-(void)updateLocation;

/**
 *  获取最近一次定位坐标
 *
 *  @return CLLocationCoordinate2D
 */
+(CLLocationCoordinate2D)fetchLastCoordinate;

/**
 *  获取最后一次的定位城市
 *
 *  @return 城市
 */
+(NSString*)fetchLastLocation;
@end


