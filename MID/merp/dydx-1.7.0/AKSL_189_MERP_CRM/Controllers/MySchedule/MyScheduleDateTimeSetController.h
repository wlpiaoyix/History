//
//  MyScheduleDateTimeSetController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
@interface MyScheduleDateTimeSetController : UIViewController<VRGCalendarViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
@private NSArray *arrayHours;
@private NSArray *arrayMunites;
}
@property (retain, nonatomic) IBOutlet UIView *viewDateTime;
@property (retain, nonatomic) IBOutlet UIView *viewSet;
@property (retain, nonatomic) id targets;
@property  SEL methods;
@property (weak, nonatomic) NSDate *date;
@end
