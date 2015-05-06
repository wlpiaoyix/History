//
//  ET_PhoneNumListController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ET_PhoneNumListController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property long long int type;
@property long long int cityId;
@end
