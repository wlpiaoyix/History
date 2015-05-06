//
//  CTM_MainController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^ExcueViewAppeardDo)(UIViewController *myself);
@interface CTM_MainController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
@protected ExcueViewAppeardDo dox;
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewRecord;
+(id) getSingleInstance;
-(void) setExcueViewAppearDo:(ExcueViewAppeardDo) appearDo;
-(void) refreshRecord;

@end
