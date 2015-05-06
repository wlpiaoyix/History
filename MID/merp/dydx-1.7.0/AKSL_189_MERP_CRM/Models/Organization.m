//
//  Organization.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-27.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "Organization.h"
#import "ConfigManage.h"
static Organization *organizationX;
@interface Organization()
@end;
@implementation Organization

+(Organization*) getInstance{
    @synchronized(organizationX){
        if(!organizationX){
            organizationX = [[Organization alloc]init];
            [Organization checkOrganzation:organizationX];
        }
    }
    return organizationX;
}
+(Organization*) getNewInstance{
    @synchronized(organizationX){
        organizationX = [[Organization alloc]init];
        [Organization checkOrganzation:organizationX];
    }
    return organizationX;
}
+(void) checkOrganzation:(Organization*) org{
    NSDictionary *temp1 = [(NSString*)[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy];
    NSDictionary *organization = [temp1 objectForKey:@"organization"];
    org.orgId = ((NSNumber*)[organization objectForKey:@"id"]).longLongValue;
    org.orgParentId = ((NSNumber*)[organization objectForKey:@"parentId"]).longLongValue;
    org.orgShortName = [organization objectForKey:@"shortName"];
    org.orgFullName = [organization objectForKey:@"fullName"];
    org.orgPhoneNum = [organization objectForKey:@"phoneNum"];
    if(CHECK_NULL_ENABLED(org.orgFullName)){
        org.orgFullName = NO;
    }
    if(CHECK_NULL_ENABLED(org.orgShortName)){
        org.orgShortName = NO;
    }
    if(CHECK_NULL_ENABLED(org.orgPhoneNum)){
        org.orgPhoneNum = NO;
    }
}
@end
