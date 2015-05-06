//
//  CTM_RightController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CTM_RightController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>
-(void) refreshData; 
+(id) getSingleInstance;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarInfo;
@property (strong, nonatomic) IBOutlet UITableView *tableViewContents;
@end
