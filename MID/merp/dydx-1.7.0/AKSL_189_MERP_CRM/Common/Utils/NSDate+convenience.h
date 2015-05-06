//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

-(NSDate *)offsetYear:(int)numYears;
-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(NSDate *)offsetMinutes:(int)minute;
-(NSString *)getFriendlyTime:(bool) ifDisplayDate;
-(NSString *)getFriendlyTime2;
-(int)numDaysInMonth;
-(int)firstWeekDayInMonth;
-(int)year;
-(int)month;
-(int)day;
-(int)hour;
-(int)minute;
+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)monthStartOfDay:(NSDate *)date;
+(NSDate *)monthEndOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;
+(NSDate *)getTodayZero;
+(NSDate*) dateFormateString:(NSString*) date FormatePattern:(NSString*) formatePattern;
+(NSString*) dateFormateDate:(NSDate*) date FormatePattern:(NSString*) formatePattern;
-(int)compareDate:(int)type compareDate:(NSDate *)tow;
@end
