//
//  LeftMenuViewController.h
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-10-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface LeftMenuViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *viewForOp;
-(void)showBadge:(int)num Set:(int)set;
-(void)hideBadge:(int)set;
- (IBAction)mainButtonCilck:(id)sender;
-(void)setSelectButton:(int)setindex;
-(void)hideButton:(int)setindex;
@end
