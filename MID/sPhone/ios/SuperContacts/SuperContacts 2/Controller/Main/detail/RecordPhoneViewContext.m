//
//  RecordPhoneViewContext.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-28.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "RecordPhoneViewContext.h"

@implementation RecordPhoneViewContext{
@private
    UIRecordPhoneView *pv00;
    UIRecordPhoneView *pv01;
    UIRecordPhoneView *pv02;
    UIRecordPhoneView *pv03;
    UIRecordPhoneView *pv04;
    UIRecordPhoneView *pv10;
    UIRecordPhoneView *pv11;
    int indexView;
}
-(bool) isLastView:(int) tag{
    UIView *view = nil;
    if(pv00){
        view = pv00;
    }
    if(pv01){
        view = pv01;
    }
    if(pv02){
        view = pv02;
    }
    if(pv03){
        view = pv03;
    }
    if(pv04){
        view = pv04;
    }
    
    return view?(view.tag == tag?true:false):false;
}
-(UIRecordPhoneView*) getPhoneViewByIndex:(int) index{
    int i=0;
    if(pv00){
        if(i==index){
            return pv00;
        }
        i++;
    }
    if(pv01){
        if(i==index){
            return pv01;
        }
        i++;
    }
    if(pv02){
        if(i==index){
            return pv02;
        }
        i++;
    }
    if(pv03){
        if(i==index){
            return pv03;
        }
        i++;
    }
    if(pv04){
        if(i==index){
            return pv04;
        }
        i++;
    }
    return nil;
}
-(UIRecordPhoneView*) getProlongationViewByIndex:(int) index{
    int i= 0;
    if(pv10){
        if(i==index){
            return pv10;
        }
        i++;
    }
    if(pv11){
        if(i==index){
            return pv11;
        }
        i++;
    }
    return nil;
}
-(UIRecordPhoneView*) getPhoneView:(int) typex{
    UIRecordPhoneView *pv = nil;
    switch (typex) {
        case phone_default:{
            pv = pv00;
        }
            break;
        case phone_mobile:{
            pv = pv01;
        }
            break;
        case phone_home:{
            pv = pv02;
        }
            break;
        case phone_company:{
            pv = pv03;
        }
            break;
        case phone_other:{
            pv = pv04;
        }
            break;
        default:
            break;
    }
    return pv;
}
-(UIRecordPhoneView*) getProlongationView:(int) typex{
    UIRecordPhoneView *pv = nil;
    switch (typex) {
        case 0:{
            pv = pv10;
        }
            break;
        case 1:{
            pv = pv11;
        }
            break;
        default:
            break;
    }
    return pv;
}
-(UIRecordPhoneView*) addPhoneView:(int) typex{
    UIRecordPhoneView *pv = nil;
    switch (typex) {
        case phone_default:{
            if(!pv00){
                EntityPhone *phone = [EntityPhone new];
                phone.type = typex;
                pv00 = [UIRecordPhoneView getNewInstance];
                pv00.tag = self.tag+0;
                [pv00 setEntityPhone:phone];
            }
            pv = pv00;
        }
            break;
        case phone_mobile:{
            if(!pv01){
                EntityPhone *phone = [EntityPhone new];
                phone.type = typex;
                pv01 = [UIRecordPhoneView getNewInstance];
                pv01.tag = self.tag+1;
                [pv01 setEntityPhone:phone];
            }
            pv = pv01;
        }
            break;
        case phone_home:{
            if(!pv02){
                EntityPhone *phone = [EntityPhone new];
                phone.type = typex;
                pv02 = [UIRecordPhoneView getNewInstance];
                pv02.tag = self.tag+2;
                [pv02 setEntityPhone:phone];
            }
            pv = pv02;
        }
            break;
        case phone_company:{
            if(!pv03){
                EntityPhone *phone = [EntityPhone new];
                phone.type = typex;
                pv03 = [UIRecordPhoneView getNewInstance];
                pv03.tag = self.tag+3;
                [pv03 setEntityPhone:phone];
            }
            pv = pv03;
        }
            break;
        case phone_other:{
            if(!pv04){
                EntityPhone *phone = [EntityPhone new];
                phone.type = typex;
                pv04 = [UIRecordPhoneView getNewInstance];
                pv04.tag = self.tag+4;
                [pv04 setEntityPhone:phone];
            }
            pv = pv04;
        }
            break;
        default:
            break;
    }
    return pv;

}
-(UIRecordPhoneView*) addProlongationView:(int) typex{
    UIRecordPhoneView *pv = nil;
    switch (typex) {
        case 0:{
            if(!pv10){
                pv10 = [UIRecordPhoneView getNewInstance];
                pv10.tag = self.tag+10+typex;
                [pv10 setEntityPhone:nil];
                [pv10 setTypeName:@"昵称:"];
                [pv10 setKeyBoardType:UIKeyboardTypeNamePhonePad];
            }
            pv = pv10;
        }
            break;
        case 1:{
            if(!pv11){
                pv11 = [UIRecordPhoneView getNewInstance];
                [pv11 setEntityPhone:nil];
                pv11.tag = self.tag+10+typex;
                [pv11 setTypeName:@"电子邮件:"];
                [pv11 setKeyBoardType:UIKeyboardTypeEmailAddress];
                pv = pv11;
            }
        }
            break;
        default:
            break;
    }
    return pv;
}
-(UIRecordPhoneView*) addNextPhoneView{
    if(!pv00){
        return [self addPhoneView:0];
    }
    if(!pv01){
        return [self addPhoneView:1];
    }
    if(!pv02){
        return [self addPhoneView:2];
    }
    if(!pv03){
        return [self addPhoneView:3];
    }
    if(!pv04){
        return [self addPhoneView:4];
    }
    return nil;
}
-(int) countPhoneView{
    int i = 0;
    if(pv00){
        ++i;
    }
    if(pv01){
        ++i;
    }
    if(pv02){
        ++i;
    }
    if(pv03){
        ++i;
    }
    if(pv04){
        ++i;
    }
    return i;
}
-(int) countProlongationView{
    int i = 0;
    if(pv10){
        ++i;
    }
    if(pv11){
        ++i;
    }
    return i;
}
-(void) removePhoneViewByTag:(int) tag;{
    if(pv00){
        if(pv00.tag == tag){
            pv00 = nil;
            return;
        }
    }
    if(pv01){
        if(pv01.tag == tag){
            pv01 = nil;
            return;
        }
    }
    if(pv02){
        if(pv02.tag == tag){
            pv02 = nil;
            return;
        }
    }
    if(pv03){
        if(pv03.tag == tag){
            pv03 = nil;
            return;
        }
    }
    if(pv04){
        if(pv04.tag == tag){
            pv04 = nil;
            return;
        }
    }
}
-(void) removeAllView{
    pv00 = nil;
    pv01 = nil;
    pv02 = nil;
    pv03 = nil;
    pv04 = nil;
    pv10 = nil;
    pv11 = nil;
}
-(void) removePhoneView:(int) typex{
    switch (typex) {
        case 0:{
            pv00 = nil;
        }
            break;
        case 1:{
            pv01 = nil;
        }
            break;
        case 2:{
            pv02 = nil;
        }
            break;
        case 3:{
            pv03 = nil;
        }
            break;
        case 4:{
            pv04 = nil;
        }
            break;
        default:
            break;
    }
}

-(void) starEL{
    self->indexView = 0;
}
-(UIRecordPhoneView*) hasNext{
    int i = 0;
    if(pv00){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv00;
        }
        i++;
    }
    if(pv01){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv01;
        }
        i++;
    }
    if(pv02){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv02;
        }
        i++;
    }
    if(pv03){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv03;
        }
        i++;
    }
    if(pv04){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv04;
        }
        i++;
    }
    if(pv10){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv10;
        }
        i++;
    }
    if(pv11){
        if(i==indexView){
            self->indexView=i;
            self->indexView++;
            return pv11;
        }
        i++;
    }
    return nil;
}


@end
