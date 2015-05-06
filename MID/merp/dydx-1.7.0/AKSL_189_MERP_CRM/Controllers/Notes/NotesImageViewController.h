//
//  NotesImageViewController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-15.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NotesScrollVIew.h"
@interface NotesImageViewController : BaseViewController
@property (retain, nonatomic) IBOutlet NotesScrollVIew *viewCheck;
@property (retain, nonatomic) IBOutlet NotesScrollVIew *viewCheck2;
@property (retain, nonatomic) IBOutlet UIView *viewImageInfo;
@property (retain, nonatomic) IBOutlet UILabel *lableImageInfo;
@property (retain, nonatomic) IBOutlet UIView *viewHD;
@property (retain, nonatomic) IBOutlet UILabel *lableTitle;
@property (retain, nonatomic) NSString *title;
- (IBAction)buttonReturn:(id)sender;
- (void) setJsonData:(NSMutableDictionary *)jsonData;
- (void) setCurrentIndexJsonData:(int)currentIndexJsonData;
@end
