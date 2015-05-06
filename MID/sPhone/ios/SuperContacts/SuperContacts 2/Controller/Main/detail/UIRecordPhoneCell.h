//
//  UIRecordPhoneCell.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RPCCallBack)(UIView *targetView);
@interface UIRecordPhoneCell : UITableViewCell
-(UIRecordPhoneCell*) addViewInContext:(UIView*) view;
-(void) setRPVCallBack:(RPCCallBack) rpvcb;
-(void) setButtonOptSelected:(bool) selected;
-(void) setButtonOptHidden:(bool)hidden;
@end
