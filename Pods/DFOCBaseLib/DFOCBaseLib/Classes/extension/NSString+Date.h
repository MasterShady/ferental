//
//  NSString+Date.h
//  ZHWBuyer
//
//  Created by 哈哈哈 on 2017/3/7.
//  Copyright © 2017年 ZuHaoWan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

/*获取当前时间*/
+ (NSString *)getCurrentDate;


/**
 给定时间字符串返回周几或者今天

 @param date 时间字符串
 @return 今天，昨天，周
 */
+ (NSString *)compareDate:(NSString *)date;

/**
 根据时间字符串返回周数
 **/
+ (NSString *)compareDateBackWeek:(NSString *)date;

/**
 传入时间返回明天时间
 **/
+ (NSString *)GetTomorrowDay:(NSString *)aDate;


/**
 比较两个时间之间的大小
 
 @param starTime 时间字符串
 @return 0、1、-1
 */
+(int)compareDate:(NSString*)starTime withDate:(NSString*)curTime;


/**
 给定时间戳转化为时间字符串

 @param timeString 时间戳
 @return 2017-2-1
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

+ (NSString *)dateHourMinWithTimeIntervalString:(NSString *)timeString;

/*
 获取两个时间段之间时间差
 */

+ (NSDateComponents *)dateStrOne:(NSString *)oneTimeStr twoStr:(NSString *)twoTimeStr;

/**
 计算几小时后的时间
 **/
+ (NSString *)addHourBackDateStrWith:(NSString *)dateStr hour:(NSString *)hour;

/*计算几分钟后的时间*/
+ (NSString *)addHourBackDateStrWith:(NSString *)dateStr minute:(NSInteger)minute;

/*
 根据所传的日期获取7天的日期(包含所传的日期),并根据所获取的日期获取天数和周几
 */

+ (NSMutableArray *)getSevenDayDateWith:(NSDate *)date;


/*给定时间(秒为单位)，计算天数，小时数，分钟数,秒数*/

+ (NSString *)computeDateWithTime:(int)totalSeconds;

+ (NSString *)computeMinutSecondDateWithTime:(int)totalSeconds;
/*给定时间(秒为单位)，计算小时数，分钟数,秒数  00:00:00*/
+ (NSString *)computeDateWithTime2:(int)totalSeconds;


+ (NSString *)helpLoginComputeMinutSecondDateWithTime:(int)totalSeconds;
@end
