//
//  CTM_RecordDetailController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityCallRecord.h"
#import "BaseViewController.h"
#import "PopUpDialogView.h"
@interface CTM_RecordDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopUpDialogViewDelegate>
@property (strong, nonatomic) NSArray *recordData;
@property (strong, nonatomic) EntityCallRecord *curRecord;
@end
