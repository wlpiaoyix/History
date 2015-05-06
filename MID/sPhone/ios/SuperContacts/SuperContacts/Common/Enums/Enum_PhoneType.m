//
//  Enum_PhoneType.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//


#import "Enum_PhoneType.h"
#import <AddressBook/AddressBook.h>
static const NSString* Enum_PhoneHome= @"住宅号码";
static const NSString* Enum_PhoneWork= @"工作号码";
static const NSString* Enum_PhoneMobile = @"移动号码";
static const NSString* Enum_PhoneIPhone = @"IPhone";
static const NSString* Enum_PhoneMain= @"家庭号码";
static const NSString* Enum_PhonePager = @"传呼";
static const NSString* Enum_PhoneHomeFax= @"住宅传真";
static const NSString* Enum_PhoneWorkFax = @"工作传真";
static const NSString* Enum_PhoneOtherFax = @"其它号码";


static NSString* STR_PhoneHome;
static NSString* STR_PhoneWork;
static NSString* STR_PhoneMobile;
static NSString* STR_PhoneIPhone;
static NSString* STR_PhoneMain;
static NSString* STR_PhonePager;
static NSString* STR_PhoneHomeFax;
static NSString* STR_PhoneWorkFax;
static NSString* STR_PhoneOtherFax;
@implementation Enum_PhoneType

+(void) initialize{
    STR_PhoneHome = 	@"_$!<Home>!$_";//(__bridge NSString*)kABPersonHomePageLabel;
    STR_PhoneWork = 	@"_$!<Work>!$_";
    STR_PhoneMobile = (__bridge NSString*)kABPersonPhoneMobileLabel;
    STR_PhoneIPhone = (__bridge NSString*)kABPersonPhoneIPhoneLabel;
    STR_PhoneMain = (__bridge NSString*)kABPersonPhoneMainLabel;
    STR_PhonePager = (__bridge NSString*)kABPersonPhonePagerLabel;
    STR_PhoneHomeFax = (__bridge NSString*)kABPersonPhoneHomeFAXLabel;
    STR_PhoneWorkFax = (__bridge NSString*)kABPersonPhoneWorkFAXLabel;
    STR_PhoneOtherFax = (__bridge NSString*)kABPersonPhoneOtherFAXLabel;
}
+(int) enumByName:(NSString*) name{
    if([Enum_PhoneHome isEqual:name]){
        return phone_home;
    }else if([Enum_PhoneWork isEqual:name]){
        return phone_mobile;
    }else if([Enum_PhoneMobile isEqual:name]){
        return phone_mobile;
    }else if([Enum_PhoneIPhone isEqual:name]){
        return phone_iphone;
    }else if([Enum_PhoneMain isEqual:name]){
        return phone_main;
    }else if([Enum_PhonePager isEqual:name]){
        return phone_pager;
    }else if([Enum_PhoneHomeFax isEqual:name]){
        return phone_homeFax;
    }else if([Enum_PhoneWorkFax isEqual:name]){
        return phone_workFax;
    }else if([Enum_PhoneOtherFax isEqual:name]){
        return phone_otherFax;
    }else{
        return phone_home;
    }
}
+(int) enumByValue:(NSString*) value{
    if([STR_PhoneHome isEqual:value]){
        return phone_home;
    }else if([STR_PhoneWork isEqual:value]){
        return phone_work;
    }else if([STR_PhoneMobile isEqual:value]){
        return phone_mobile;
    }else if([STR_PhoneIPhone isEqual:value]){
        return phone_iphone;
    }else if([STR_PhoneMain isEqual:value]){
        return phone_main;
    }else if([STR_PhonePager isEqual:value]){
        return phone_pager;
    }else if([STR_PhoneHomeFax isEqual:value]){
        return phone_homeFax;
    }else if([STR_PhoneWorkFax isEqual:value]){
        return phone_workFax;
    }else if([STR_PhoneOtherFax isEqual:value]){
        return phone_otherFax;
    }else{
        return phone_home;
    }
}
+(const NSString*) nameByEnum:(int) enums{
    switch (enums) {
        case 0:
            return Enum_PhoneHome;
        case 1:
            return Enum_PhoneWork;
        case 2:
            return Enum_PhoneMobile;
        case 3:
            return Enum_PhoneIPhone;
        case 4:
            return Enum_PhoneMain;
        case 5:
            return Enum_PhonePager;
        case 6:
            return Enum_PhoneHomeFax;
        case 7:
            return Enum_PhoneWorkFax;
        case 8:
            return Enum_PhoneOtherFax;
        default:
            return Enum_PhoneHome;
    }
}
+(NSString*) valueByEnum:(int) enums{
    switch (enums) {
        case 0:
            return STR_PhoneHome;
        case 1:
            return STR_PhoneWork;
        case 2:
            return STR_PhoneMobile;
        case 3:
            return STR_PhoneIPhone;
        case 4:
            return STR_PhoneMain;
        case 5:
            return STR_PhonePager;
        case 6:
            return STR_PhoneHomeFax;
        case 7:
            return STR_PhoneWorkFax;
        case 8:
            return STR_PhoneOtherFax;
        default:
            return STR_PhoneHome;
    }
}
+(NSMutableArray*) enums{
    return [[NSMutableArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:1],[[NSNumber alloc] initWithInt:2],[[NSNumber alloc] initWithInt:3],[[NSNumber alloc] initWithInt:4],[[NSNumber alloc] initWithInt:5],[[NSNumber alloc] initWithInt:6],[[NSNumber alloc] initWithInt:7],[[NSNumber alloc] initWithInt:8], nil];
}
@end
