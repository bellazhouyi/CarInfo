//
//  NSDate+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Joker)

/**
*  Date转换为格式化字符串
*
*  @param format 时间格式
*
*  @return NSString:格式化字符串
*/
-(NSString*)toStringWithFormat:(NSString*)format;

/**
 *  获取当前时间字符串
 *
 *  @param format 时间格式
 *
 *  @return NSString:当前时间字符串
 */
+(NSString*)stringWithCurrentTimeFormat:(NSString*)format;



+(NSString*)stringWithCurrentTimeInterval1970_13;

/**
 *  获取当前时间的时间戳字符串10位
 *
 *  @return NSString:时间戳字符串
 */
+(NSString*)stringWithCurrentTimeInterval1970_10;

/**
 *  dateString转换为NSDate类型
 *
 *  @param format     @param format 时间格式
 *  @param dateString @param dateString 时间字符串
 *
 *  @return NSDate
 */
+(NSDate*)dateWithFormat:(NSString*)format dateString:(NSString*)dateString;

/**
 *  将时间戳字符串转换为时间格式字符串
 *
 *  @param format    时间格式
 *  @param timestamp timestamp
 *
 *  @return 字符串NSString
 */
+(NSString*)dateStringWithFormat:(NSString*)format timestamp:(NSString*)timestamp;

/**
 *  将时间戳字符串转换为Date
 *
 *  @param timestamp 时间戳字符串
 *
 *  @return NSDate
 */
+(NSDate*)dateForTimestamp:(NSString*)timestamp;

#pragma mark -
#pragma mark - ------------------------------
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

+ (NSInteger)daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)dateWithHour:(int)hour
                  minute:(int)minute;

#pragma mark - Getter
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSString *)weekday;


#pragma mark - Time string
- (NSString *)timeHourMinute;
- (NSString *)timeHourMinuteWithPrefix;
- (NSString *)timeHourMinuteWithSuffix;
- (NSString *)timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix;

#pragma mark - Date String
- (NSString *)stringTime;
- (NSString *)stringMonthDay;
- (NSString *)stringYearMonthDay;
- (NSString *)stringYearMonthDayHourMinuteSecond;
+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date;      //date为空时返回的是当前年月日
+ (NSString *)stringLoacalDate;

#pragma mark - Date formate
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)timestampFormatStringSubSeconds;

#pragma mark - Date adjust
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;

#pragma mark - Relative dates from the date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *) dateStandardFormatTimeZeroWithDate: (NSDate *) aDate;  //标准格式的零点日期
- (NSInteger) daysBetweenCurrentDateAndDate;                     //负数为过去，正数为未来

#pragma mark - Date compare
- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate;
- (NSString *)stringYearMonthDayCompareToday;                 //返回“今天”，“明天”，“昨天”，或年月日
- (NSString *)stringMonthDayCompareToday;//返回“今天”，“明天”，“昨天”，或月日
#pragma mark - Date and string convert
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)string;
- (NSString *)stringCutSeconds;
/**
 * 计算指定时间与当前的时间的距离
 * @param date 指定时间
 */
+ (NSString*)intervalSinceNowWithTimeStamp:(NSString*)timeStamp;

/**
 *  得到秒数
 *
 *  @param beginDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return <#return value description#>
 */
+(long long int)intervalWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;

@end











