//
//  NotesForOrganizationController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^RetureMethodDic)(NSDictionary *selecteds);
/**
 用来选择当前用户下一级的所有部门
 */
@interface NotesForOrganizationController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
RetureMethodDic _returnMethod;
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewOrgList;//用来显示部门信息的列表
@property (retain, nonatomic) id target;//对应的class类
 
- (IBAction)buttonReturn:(UIButton *)sender;//回退事件
-(void) setRetureMethods:(RetureMethodDic) returnMethod;
@end
