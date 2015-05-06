//
//  CTM_ViewContentController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 3/20/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTM_ViewContentController : UIViewController<UITableViewDelegate,UITableViewDataSource>
+(id) getNewInstance;
-(void) setEntityUser:(id) user;

@end
