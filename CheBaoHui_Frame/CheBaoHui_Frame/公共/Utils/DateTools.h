//
//  DateTools.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTools : NSObject

 /**
 *
 *传入时间得到当前时间是星期几
 *  @param date     传入的时间
 *  @param weekdays 传入周一到周天,根据喜好 传入星期一到星期天都可以
 *
 *  @return 返回传入的时间得到周几
 */
+(NSString*)weekdayStringForDate:(NSDate*)date   weekdays:(NSArray * )  weekdays;


/**
 *  @param date   传入的时间
 *  @param format 格式化样式
 *
 *  @return 返回时间
 */
+(NSDate * ) StringDateForDate:(NSString * ) date  format:(NSString * ) format;

@end
