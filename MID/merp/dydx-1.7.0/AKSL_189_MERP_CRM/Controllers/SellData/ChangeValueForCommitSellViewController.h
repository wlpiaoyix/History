//
//  ChangeValueForCommitSellViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-4.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChangeValueForCommitSellViewController : BaseViewController{
    NSString * pname;
}

-(void)setData:(NSString *)name ID:(int)ids;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (assign,nonatomic) int ids;
@property (weak, nonatomic) IBOutlet UITextField *numForSell;

@end
