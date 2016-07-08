//
//  DateTools.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DateTools.h"

@implementation DateTools





/**
 *  @param date   传入的时间
 *  @param format 格式化样式
 *
 *  @return 返回时间
 */
+(NSDate * ) StringDateForDate:(NSString * ) date  format:(NSString * ) format
{
     NSDateFormatter * dateFormat = [[NSDateFormatter   alloc] init];
    
    [dateFormat setDateFormat: format];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *  newDate = [dateFormat  dateFromString:date];
    
    return newDate;
    
}


/**
*
*传入时间得到当前时间是星期几
*  @param date     传入的时间
*  @param weekdays 传入周一到周天,根据喜好 传入星期一到星期天都可以
*
*  @return 返回传入的时间得到周几
*/
+(NSString*)weekdayStringForDate:(NSDate*)date  weekdays:(NSArray *)weekdays{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
@end
