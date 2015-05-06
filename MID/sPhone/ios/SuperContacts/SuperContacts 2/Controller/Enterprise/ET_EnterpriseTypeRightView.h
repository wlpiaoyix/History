//
//  ET_EnterpriseTypeRightView.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-24.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallBackClickEnterpriseType2)(int curtype,NSString *curname);
@interface ET_EnterpriseTypeRightView : UIView
+(id) getNewInstance;
-(void) setData:(NSString*) typeName ImageUrl:(NSString*) imageUrl Type:(int) type;
-(int) getType;
-(void) setCallBack:(CallBackClickEnterpriseType2) callBack;
@end
