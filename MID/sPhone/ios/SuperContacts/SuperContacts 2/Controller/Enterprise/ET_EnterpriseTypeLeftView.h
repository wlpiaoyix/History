//
//  ET_EnterpriseTypeLeftView.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-24.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallBackClickEnterpriseType1)(int curtype,NSString *curname);
@interface ET_EnterpriseTypeLeftView : UIView
+(id) getNewInstance;
-(void) setData:(NSString*) typeName ImageUrl:(NSString*) imageUrl Type:(int) type;
-(int) getType;
-(void) setCallBack:(CallBackClickEnterpriseType1) callBack;
@end
