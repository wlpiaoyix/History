//
//  SystemSetsMainController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-2.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SystemSetsListController.h"
@interface SystemSetsMainController:BaseViewController<UIAlertViewDelegate>
+(SystemSetsListController*)  initForReturnList;
@end
