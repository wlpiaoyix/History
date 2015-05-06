//
//  CTM_AddContentController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityUser.h"
#import "BaseViewController.h"
typedef void (^CallBackSave)(EntityUser*);
@interface CTM_AddContentController : BaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>{
}
+(id) getNewInstance;
-(void) setEntityUser:(EntityUser*) user;
-(void) setTitleName:(NSString *)titleName;
-(void) setCallBackSave:(CallBackSave) callCackSave;
@end
