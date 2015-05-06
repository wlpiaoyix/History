//
//  RecordPhoneViewContext.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-28.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "RecordPhoneViewContext.h"
#import "Enum_PhoneType.h"

@implementation RecordPhoneViewContext{
@private
    NSMutableArray *phoneViews;
    NSMutableArray *expandViews;
    NSArray *enums;
}
-(id) init{
    if(self=[super init]){
        phoneViews = [NSMutableArray new];
        expandViews = [NSMutableArray new];
        enums = [Enum_PhoneType enums];
    }
    return self;
}
-(int) countPhoneView{
    int count = 0;
    for (UIRecordPhoneView *rpv in phoneViews) {
        if(rpv.flagHasSuper){
            count++;
        }
    }
    return count;
}
-(int) countExpandView{
    int count = 0;
    for (UIRecordPhoneView *rpv in expandViews) {
        if(rpv.flagHasSuper){
            count++;
        }
    }
    return count;
}
-(int) totalPhoneView{
    return (int)[enums count];
}
-(int) totalExpandView{
    return 10;
}

-(void) initPhoneView:(NSArray*) types{
    [self->phoneViews removeAllObjects];
    int i = -1;
    for (EntityPhone *ep in types) {
        if(i-ep.type.intValue!=1){
            for (int k=i+1; k<ep.type.intValue; k++) {
                UIRecordPhoneView *rpvx = [UIRecordPhoneView getNewInstance];
                EntityPhone *epx = [EntityPhone new];
                epx.type = [NSNumber numberWithInt:k];
                [rpvx setEntityPhone:epx];
                [self->phoneViews addObject:rpvx];
            }
        }
        UIRecordPhoneView *rpv = [UIRecordPhoneView getNewInstance];
        [rpv setEntityPhone:ep];
        [rpv setTypeName:[Enum_PhoneType nameByEnum:ep.type.intValue]];
        [rpv setPhoneNumber:ep.phoneNum];
        rpv.flagHasSuper = true;
        [self->phoneViews addObject:rpv];
        i=ep.type.intValue;
    }
}
-(UIRecordPhoneView*) createPhoneView{
    for (UIRecordPhoneView *rpv in self->phoneViews) {
        if(!rpv.flagHasSuper){
            rpv.flagHasSuper = true;
            return rpv;
        }
    }
    UIRecordPhoneView *rpv = [UIRecordPhoneView getNewInstance];
    EntityPhone *phone = [EntityPhone new];
    phone.type = [NSNumber numberWithInt:(int)[self->phoneViews count]];
    [rpv setEntityPhone:phone];
    [rpv setTypeName:[Enum_PhoneType nameByEnum:phone.type.intValue]];
    int index = -1;
    for (UIRecordPhoneView *rpv in self->phoneViews) {
        if(rpv.flagHasSuper){
            index = [Enum_PhoneType enumByName:[rpv getLableValue]];
        }
    }
    ++index;
    if(index<[self totalPhoneView]){
        [rpv setTypeName:[Enum_PhoneType nameByEnum:index]];
    }
    [self->phoneViews addObject:rpv];
    rpv.flagHasSuper = true;
    return rpv;
}
-(UIRecordPhoneView*) getPhoneView:(int) index{
    int i = 0;
    for (UIRecordPhoneView *rpv in self->phoneViews) {
        if (rpv.flagHasSuper) {
            if (index==i){
                return rpv;
            }
            i++;
        }
    }
    return nil;
}
-(bool) removePhoneView:(UIRecordPhoneView*) phoneView{
    [phoneView removeFromSuperview];
    phoneView.flagHasSuper = false;
    return YES;
}

-(void) initExpandView:(NSArray*) types{
    [self->expandViews removeAllObjects];
    for (NSDictionary *json in types) {
        NSString *lable = [json objectForKey:@"lable"];
        NSString *value = [json objectForKey:@"value"];
        UIRecordPhoneView *rpv = [UIRecordPhoneView getNewInstance];
        [rpv setTypeName:lable];
        [rpv setPhoneNumber:value];
        [rpv setKeyBoardType:UIKeyboardTypeNamePhonePad];
        [self->expandViews addObject:rpv];
        rpv.flagHasSuper = true;
    }
}
-(UIRecordPhoneView*) createExpandView{
    for (UIRecordPhoneView *rpv in self->expandViews) {
        if(!rpv.flagHasSuper){
            rpv.flagHasSuper = true;
            return rpv;
        }
    }
    UIRecordPhoneView *rpv = [UIRecordPhoneView getNewInstance];
    [self->expandViews addObject:rpv];
    rpv.flagHasSuper = true;
    [rpv setKeyBoardType:UIKeyboardTypeNamePhonePad];
    return rpv;
}
-(UIRecordPhoneView*) getExpandView:(int) index{
    int i = 0;
    for (UIRecordPhoneView *rpv in self->expandViews) {
        if (rpv.flagHasSuper) {
            if (index==i){
                rpv.flagHasSuper = true;
                return rpv;
            }
            i++;
        }
    }
    return nil;
}
-(bool) removeExpandView:(UIRecordPhoneView*) texpandView{
    [texpandView removeFromSuperview];
    texpandView.flagHasSuper = false;
    return YES;
}
@end
