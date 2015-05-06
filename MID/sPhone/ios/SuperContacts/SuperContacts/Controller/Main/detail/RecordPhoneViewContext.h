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
-(int) countPhoneView;
-(int) countExpandView;
-(int) totalPhoneView;
-(int) totalExpandView;

-(void) initPhoneView:(NSArray*) types;
-(UIRecordPhoneView*) createPhoneView;
-(UIRecordPhoneView*) getPhoneView:(int) index;
-(bool) removePhoneView:(UIRecordPhoneView*) phoneView;

-(void) initExpandView:(NSArray*) types;
-(UIRecordPhoneView*) createExpandView;
-(UIRecordPhoneView*) getExpandView:(int) index;
-(bool) removeExpandView:(UIRecordPhoneView*) texpandView;
@end
