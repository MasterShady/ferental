//
//  NSString+Date.m
//  ZHWBuyer
//
//  Created by 哈哈哈 on 2017/3/7.
//  Copyright © 2017年 ZuHaoWan. All rights reserved.
//

#import "NSString+Date.h"
#import "OC_Const.h"
@implementation NSString (Date)

+ (NSString *)getCurrentDate
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *str = [formatter stringFromDate:date];
    
    return str;
}


+ (NSString *)compareDate:(NSString *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    //设置东八区(北京时间)
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *inputDate = [formatter dateFromString:date];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[inputDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil, nil];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        [calendar setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:8]];
        
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
        
        return [weekdays objectAtIndex:theComponents.weekday];
    }
}

/**
 根据时间字符串返回周数
 **/
+ (NSString *)compareDateBackWeek:(NSString *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    //设置东八区(北京时间)
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *inputDate = [formatter dateFromString:date];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil, nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [calendar setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma mark - 给定时间返回明天时间
//传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSString *)aDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    //设置东八区(北京时间)
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *inputDate = [formatter dateFromString:aDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond fromDate:inputDate];
    [components setDay:([components day] + 1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateday setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return [dateday stringFromDate:beginningOfWeek];
}




+ (int)compareDate:(NSString *)starTime withDate:(NSString *)curTime {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *start;
    NSDate *cur;
    start = [df dateFromString:starTime];
    cur = [df dateFromString:curTime];
    NSComparisonResult result = [start compare:cur];
    switch (result) {
        case NSOrderedAscending:
            ci = 1;//curTime大于startTime
            break;
        case NSOrderedDescending:
            ci = -1;//curTime小于startTime
            break;
        case NSOrderedSame:
            ci = 0;//curTime等于startTime
            break;
        default:
            break;
    }
    return ci;
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    NSTimeInterval time=[timeString doubleValue] + 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


+ (NSString *)dateHourMinWithTimeIntervalString:(NSString *)timeString {
    NSTimeInterval time=[timeString doubleValue] + 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+ (NSDateComponents *)dateStrOne:(NSString *)oneTimeStr twoStr:(NSString *)twoTimeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    //设置东八区(北京时间)
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *oneDate = [formatter dateFromString:oneTimeStr];
    NSDate *twoDate = [formatter dateFromString:twoTimeStr];
    // 当前日历
    NSCalendar *calendar = nil;
    if (iOS8Later) {
         calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else {
        calendar = [NSCalendar currentCalendar];
    }
   
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:oneDate toDate:twoDate options:0];
    
    return dateCom;
}

/**
 计算几小时后的时间
 **/
+ (NSString *)addHourBackDateStrWith:(NSString *)dateStr hour:(NSString *)hour {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *date = [formatter dateFromString:dateStr];
    NSInteger secondes = [hour integerValue] * 60 * 60;//转化为秒
    NSDate *lastDate = [date dateByAddingTimeInterval:secondes];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *timeString = [dateFormatter stringFromDate:lastDate];
    return timeString;
}

/*计算几分钟后的时间*/
+ (NSString *)addHourBackDateStrWith:(NSString *)dateStr minute:(NSInteger)minute
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *date = [formatter dateFromString:dateStr];
    NSInteger secondes = minute * 60;//转化为秒
    NSDate *lastDate = [date dateByAddingTimeInterval:secondes];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    NSString *timeString = [dateFormatter stringFromDate:lastDate];
    
    return timeString;
}


/*
 根据所传的日期获取7天的日期(包含所传的日期),并根据所获取的日期获取天数和周几
 */

+ (NSMutableArray *)getSevenDayDateWith:(NSDate *)date
{
    NSMutableArray *allArray = [NSMutableArray array];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];// you can use your format.
    /*获取当前在内7天日期*/
    NSMutableArray *dateArray = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSDate *nextDate = [NSDate dateWithTimeInterval:24 * 60 * 60 * i sinceDate:date];
        NSString *timeStr = [dateFormat stringFromDate:nextDate];
        [dateArray addObject:timeStr];
    }
    
    /*根据时间获取当天的天数和星期几*/
    NSMutableArray *dayArr = [NSMutableArray array];
    NSMutableArray *weakArr = [NSMutableArray array];
    for (int i = 0; i < dateArray.count; i++) {
        NSDate *needDate = [dateFormat dateFromString:dateArray[i]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:needDate];
        // 获取几天是几号
        NSInteger day = [comp day];
        //获取今天是周几
        NSString *weak = [self compareDateBackWeek:dateArray[i]];
        [dayArr addObject:@(day)];
        [weakArr addObject:weak];
    }
    
    [allArray addObject:weakArr];
    [allArray addObject:dayArr];
    
    return allArray;
}


/*给定时间(秒为单位)，计算天数，小时数，分钟数,秒数*/

+ (NSString *)computeDateWithTime:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds % (60 * 60)) / 60;
    int hours = (totalSeconds % (60 * 60 * 24)) / (60 * 60);
    int day = totalSeconds / (60 * 60 * 24);
    
    if (day == 0) {
        return [NSString stringWithFormat:@"%02d小时%02d分钟%02d秒",hours, minutes, seconds];
    }else {
        return [NSString stringWithFormat:@"%d天%02d小时%02d分钟%02d秒",day, hours, minutes, seconds];
    }
}

/*给定时间，计算分钟，秒*/
+ (NSString *)computeMinutSecondDateWithTime:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds % (60 * 60)) / 60;
    
    return [NSString stringWithFormat:@"%02d分钟%02d秒", minutes, seconds];
}

+ (NSString *)helpLoginComputeMinutSecondDateWithTime:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds % (60 * 60)) / 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

/*给定时间(秒为单位)，计算小时数，分钟数,秒数  00:00:00*/
+ (NSString *)computeDateWithTime2:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds % (60 * 60)) / 60;
    int hours = (totalSeconds % (60 * 60 * 24)) / (60 * 60);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
