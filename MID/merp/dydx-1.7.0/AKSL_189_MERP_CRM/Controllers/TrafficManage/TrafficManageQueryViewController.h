//
//  TrafficManageQueryViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-22.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RetureMethod)(NSString *tagDic,NSDate *startDate,NSDate *endDate);
@interface TrafficManageQueryViewController : UIViewController
{
    RetureMethod _returnMethod;
}
- (IBAction)back:(id)sender;
- (IBAction)ObtainDate:(id)sender;
- (IBAction)trafficQuery:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dateSelectView;
-(void)setRetureMethods:(RetureMethod) returnMethod;

@end
