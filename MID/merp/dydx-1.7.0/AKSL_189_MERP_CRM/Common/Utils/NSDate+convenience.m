//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "NSDate+convenience.h"

@implementation NSDate (Convenience)

-(int)year {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}


-(int)month {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

-(int)day {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}
-(int)hour {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}
-(int)minute {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMinuteCalendarUnit fromDate:self];
    return [components minute];
}
-(NSString *)getFriendlyTime:(bool) ifDisplayDate{
    NSString *time = @"";
    NSDate *currentDate = [NSDate new];
    if(currentDate.year==self.year){
        if (currentDate.month == self.month) {
            if(currentDate.day==self.day){
                time = [time stringByAppendingString:@"今天 "];
            }else if(currentDate.day-1==self.day){
                time = [time stringByAppendingString:@"昨天 "];
            }else if(currentDate.day+1==self.day){
                time = [time stringByAppendingString:@"明天 "];
            }else{
                time = [time stringByAppendingString:[NSString stringWithFormat:@"%d月",[self month]]];
                time = [time stringByAppendingString:[NSString stringWithFormat:@"%d日",[self day]]];
            }
        }else{
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%d月",[self month]]];
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%d日",[self day]]];
        }
    }else{
        time = [time stringByAppendingString:[NSString stringWithFormat:@"%d年",[self year]]];
        time = [time stringByAppendingString:[NSString stringWithFormat:@"%d月",[self month]]];
        time = [time stringByAppendingString:[NSString stringWithFormat:@"%d日",[self day]]];
       // time = [time stringByAppendingString:[NSDate dateFormateDate:self FormatePattern:@"yyyy年MM月dd日"]];
    }
    
    if(ifDisplayDate){
//        NSString * am = @"早上";
//        switch (self.hour) {
//            case 0:
//            case 1:
//            case 2:
//            case 3:
//            case 4:
//            case 5:
//            case 6:
//                am= @"凌晨";
//                break;
//            case 12:
//            case 13:
//            case 14:
//            case 15:
//            case 16:
//            case 17:
//            case 18:
//            case 19:
//                am =@"下午";
//                break;
//            case 20:
//            case 21:
//            case 22:
//            case 23:
//            case 24:
//                am = @"晚上";
//                break;
//        }
//        time = [time stringByAppendingString:am];
        time = [time stringByAppendingString:[NSDate dateFormateDate:self FormatePattern:@"HH:mm"]];
        
    }
    return time;
}

-(NSString *)getFriendlyTime2{
    NSString *time = @"";
    NSDate *currentDate = [NSDate new];
    if([self compareDate:1 compareDate:currentDate]==0){
        time = [NSDate dateFormateDate:self FormatePattern:@"HH:mm"];//[time stringByAppendingString:@"今天 "];
    }else{
        time = [time stringByAppendingString:[NSString stringWithFormat:@"%d/",[self month]]];
        time = [time stringByAppendingString:[NSString stringWithFormat:@"%d",[self day]]];
    }
    return time;
}
-(int)firstWeekDayInMonth {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    //[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"]];
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];

    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

-(NSDate *)offsetYear:(int)numYears {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:numYears];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetMonth:(int)numMonths {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetHours:(int)hours {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //[offsetComponents setMonth:numMonths];
    [offsetComponents setHour:hours];
     //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetMinutes:(int)minute {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //[offsetComponents setMonth:numMonths];
    [offsetComponents setMinute:minute];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}



-(int)numDaysInMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}
+(NSDate *)getTodayZero{
    NSDate * date = [NSDate new];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMinute:date.minute*-1];
    [offsetComponents setHour:date.hour*-1];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:date options:0];
}
+(NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: date];
    return [gregorian dateFromComponents:components];
}
+(NSDate *)monthStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: date];
    NSDate *d = [gregorian dateFromComponents:components];
    return [d offsetDay:1-d.day];
}
+(NSDate *)monthEndOfDay:(NSDate *)date{
    NSDate *_date = [NSDate monthStartOfDay:date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setSecond:-1];
    [offsetComponents setMonth:1];
    
    _date = [gregorian dateByAddingComponents:offsetComponents
                                      toDate:_date options:0];
    return _date;
}

+(NSDate *)dateStartOfWeek {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];

    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

+(NSDate *)dateEndOfWeek {
    NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: + (((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7))+6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                       fromDate: endOfWeek];
    
    //gestript
    endOfWeek = [gregorian dateFromComponents: componentsStripped];
    return endOfWeek;
}
+(NSDate*) dateFormateString:(NSString*) date FormatePattern:(NSString*) formatePattern{
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:formatePattern==nil?@"yyyy-MM-dd HH:mm:ss":formatePattern];
    return [dft dateFromString:date];
}
+(NSString*) dateFormateDate:(NSDate*) date FormatePattern:(NSString*) formatePattern{
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:formatePattern==nil?@"yyyy-MM-dd HH:mm:ss":formatePattern];
    return [dft stringFromDate:date];
}

-(int)compareDate:(int)type compareDate:(NSDate *)tow{
    int year = self.year-tow.year;
    int month = self.month - tow.month;
    int day = self.day - tow.day;
    return year*400+month*40+day;
}
@end
