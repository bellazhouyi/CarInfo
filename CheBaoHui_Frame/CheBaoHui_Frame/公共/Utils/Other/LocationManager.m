//
//  LocationManager.m
//  BaiduMap
//
//  Created by pengshuai on 15/4/22.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#define LOCATION_LATITUDE @"location_latitude"
#define LOCATION_LONGITUDE @"location_longitude"
#define LOCATION_CITY @"location_city"
@interface LocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation LocationManager


static LocationManager *sharedManager;
+(LocationManager*)sharedInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[LocationManager alloc] init];
        
    });
    return sharedManager;
    
}
-(instancetype)init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}

-(void)updateLocation{
    
    if([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        
    }else {
        
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"定位失败,请确认开启定位"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
    

}

#pragma mark -
#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocationCoordinate2D coordinate;
    
    coordinate = [LocationManager fetchLastCoordinate];
    
    CLLocation *currentLocation = [locations lastObject];
    [self updateLocationCoordinate:currentLocation.coordinate];
    
    coordinate = [LocationManager fetchLastCoordinate];
    //停止定位
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"failed with error: %@", error);
             return;
         }
         if(placemarks.count > 0)
         {
             NSString *MyAddress = @"";
             NSString *city = @"";
             CLPlacemark *placeMark = [placemarks lastObject];
             
             if([placeMark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                 MyAddress = [[placeMark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             else
                 MyAddress = @"Address Not founded";
             
             if([placeMark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
                 city = [placeMark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             else if([placeMark.addressDictionary objectForKey:@"City"] != NULL)
                 city = [placeMark.addressDictionary objectForKey:@"City"];
             else if([placeMark.addressDictionary objectForKey:@"Country"] != NULL)
                 city = [placeMark.addressDictionary objectForKey:@"Country"];
             else
                 city = @"没定位到";
             
             NSLog(@"%@",city);
             NSLog(@"%@", MyAddress);
             NSLog(@"%@",placeMark.subLocality);
             [self updateLocationCity:[NSString stringWithFormat:@"%@%@",city,placeMark.subLocality]];
             
         }
     }];
    
    
    
    
}


/**
 *  获取最后一次的定位城市
 *
 *  @return 城市
 */
+(NSString*)fetchLastLocation{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:LOCATION_CITY];
}

#pragma mark -
#pragma mark - 保存/获取位置信息
-(void)updateLocationCoordinate:(CLLocationCoordinate2D)coordinate{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(coordinate.latitude) forKey:LOCATION_LATITUDE];
    [userDefaults setObject:@(coordinate.longitude) forKey:LOCATION_LONGITUDE];
    [userDefaults synchronize];

}

#pragma mark - 保存定位城市

-(void)updateLocationCity:(NSString *)city{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:city forKey:LOCATION_CITY];
    [userDefaults synchronize];
}

+(CLLocationCoordinate2D)fetchLastCoordinate{

    CLLocationCoordinate2D coordinate;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    coordinate.latitude = [[userDefaults objectForKey:LOCATION_LATITUDE] doubleValue];
    coordinate.longitude = [[userDefaults objectForKey:LOCATION_LONGITUDE] doubleValue];
    return coordinate;
}
@end












