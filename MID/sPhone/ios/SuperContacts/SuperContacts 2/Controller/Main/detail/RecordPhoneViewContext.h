//
//  RecordPhoneViewContext.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-28.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIRecordPhoneView.h"
#import "EntityPhone.h"
@interface RecordPhoneViewContext : NSObject
@property int tag;
//-(UIRecordPhoneView*) getPhoneView:(int) typex;
//-(UIRecordPhoneView*) getProlongationView:(int) typex;
-(bool) isLastView:(int) tag;
-(UIRecordPhoneView*) getPhoneViewByIndex:(int) index;
-(UIRecordPhoneView*) getProlongationViewByIndex:(int) index;
-(UIRecordPhoneView*) addPhoneView:(int) typex;
-(UIRecordPhoneView*) addProlongationView:(int) typex;
-(UIRecordPhoneView*) addNextPhoneView;
-(int) countPhoneView;
-(int) countProlongationView;
-(void) removePhoneViewByTag:(int) tag;
-(void) removePhoneView:(int) typex;
-(void) removeAllView;
-(void) starEL;
-(UIRecordPhoneView*) hasNext;
@end
