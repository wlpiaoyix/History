//
//  DatePickerOperation.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-11.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DPOReturnBack)(NSDate *curDate);
@interface DatePickerOperation : UIView{
    DPOReturnBack callBack;
}
-(void) setCallBacks:(DPOReturnBack) callBacks;
@end
