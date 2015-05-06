//
//  SystemSetsListController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-1.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemSetsProtoclForButtom.h"
#import "BaseViewController.h"
@interface SystemSetsListController : BaseViewController <SystemSetsProtoclForButtom,UITableViewDelegate, UITableViewDataSource>{
    CallBakeMethod _clickSelectionRow;
    CallBakeMethod _clickButtonCancle;
    CallBakeMethod _clickButtonConfirm;
}
@property (retain, nonatomic) UIView *viewBottom;
@property (retain, nonatomic) UIButton *buttonCancel;
@property (retain, nonatomic) UIButton *buttonConfirm;
@property (retain, nonatomic) UIViewController *target;
@property (retain, nonatomic) IBOutlet UITableView *tableViewMain;
-(SystemSetsListController*) setClickSelectionRow:(CallBakeMethod) method;
-(SystemSetsListController*) setClickButtonCancle:(CallBakeMethod) method;
-(SystemSetsListController*) setClickButtonConfirm:(CallBakeMethod) method;
-(SystemSetsListController*) setMenuss:(NSArray*) menuss;
+(NSString*) getJson_datas;
+(NSString*) getJson_rowHeight;
+(NSString*) getJson_cellType;
+(NSString*) getJson_sizeH;

@end
