//
//  SelectFoyerTypeController.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "BaseViewController.h" 
typedef void (^RetureMethod)(NSArray *selecteds);
@interface SelectFoyerTypeController : BaseViewController <UITableViewDelegate, UITableViewDataSource>{
    RetureMethod _returnMethod;
}
//@property int dateType;//0厅店类型 1类务类型 2经营区域 3分支局
@property (strong, nonatomic) NSString *titleName;
@property bool ifSingleSelected;
@property (strong, nonatomic) NSMutableArray *catachData;
-(void) setRetureMethods:(RetureMethod) returnMethod;
@end
