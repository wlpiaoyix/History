//
//  CTM_RecordCell.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityCallRecord.h"
#import "EMAsyncImageView.h"
typedef void* (^ExcueClickButton)(id target);
@interface CTM_RecordCell : UITableViewCell{
    @protected ExcueClickButton clickCallx;
}
+(id) getNewInstance;
-(void) setRecord:(EntityCallRecord*) record;
-(void) setComing:(int)times;
-(void) setAction:(int)action;
-(void) setClickCallM:(ExcueClickButton) clickCall;
/**
 是否隐藏操作按钮
 */
-(void) isHiddenOptButton:(bool) flag;
@end
