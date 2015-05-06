//
//  EntityManagerAddressBook.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityManagerAddressBook.h"
#import "LocationAddressBook.h"
@interface EntityManagerAddressBook(){
@private
    LocationAddressBook *lab;
}
@end
@implementation EntityManagerAddressBook
-(id) init{
    if(self=[super init]){
        lab = [LocationAddressBook new];
    }
    return self;
}
-(NSMutableArray*) queryAllRecord{
    [lab queryContentByParams:@"李"];
    return nil;
}


@end
