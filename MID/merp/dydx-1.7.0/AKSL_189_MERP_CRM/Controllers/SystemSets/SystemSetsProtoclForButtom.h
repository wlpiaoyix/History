//
//  SystemSetsProtoclForButtom.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-3.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemSetViewBottom.h"

@protocol SystemSetsProtoclForButtom <NSObject>

@required-(id) getSystemSetViewBottom;
@required-(void) setTarget:(id) target;

@end
