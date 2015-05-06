//
//  SysSetPersonInfoController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-3.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface SysSetPersonInfoController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,NSURLConnectionDelegate>
+(id) getNewInstance;
-(void) setUserx:(ModleUser*) userx;

@end
