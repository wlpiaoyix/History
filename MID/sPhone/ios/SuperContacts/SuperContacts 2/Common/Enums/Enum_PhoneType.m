//
//  Enum_PhoneType.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "Enum_PhoneType.h"
static const NSString* Enum_PhoneDefault = @"常用号码";
static const NSString* Enum_PhoneMobile = @"手机号码";
static const NSString* Enum_PhoneHome= @"家庭号码";
static const NSString* Enum_PhoneCompany = @"公司号码";
static const NSString* Enum_PhoneOther = @"其它号码";
@implementation Enum_PhoneType
+(int) enumByName:(NSString*) name{
    if([Enum_PhoneDefault isEqual:name]){
        return phone_default;
    }else if([Enum_PhoneMobile isEqual:name]){
        return phone_mobile;
    }else if([Enum_PhoneHome isEqual:name]){
        return phone_home;
    }else if([Enum_PhoneCompany isEqual:name]){
        return phone_company;
    }else if([Enum_PhoneOther isEqual:name]){
        return phone_other;
    }else{
        return phone_default;
    }

}
+(const NSString*) nameByEnum:(int) enums{
    switch (enums) {
        case 0:
            return Enum_PhoneDefault;
        case 1:
            return Enum_PhoneMobile;
        case 2:
            return Enum_PhoneHome;
        case 3:
            return Enum_PhoneCompany;
        case 4:
            return Enum_PhoneOther;
        default:
            return Enum_PhoneDefault;
    }
}
+(NSMutableArray*) enums{
    return [[NSMutableArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:phone_default],[[NSNumber alloc] initWithInt:phone_mobile],[[NSNumber alloc] initWithInt:phone_home],[[NSNumber alloc] initWithInt:phone_company],[[NSNumber alloc] initWithInt:phone_other], nil];
}
@end
