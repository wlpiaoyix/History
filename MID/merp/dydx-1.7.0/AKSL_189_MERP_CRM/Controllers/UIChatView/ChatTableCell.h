//
//  ChatTableCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-13.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMAsyncImageView;
@interface ChatTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIControl *ViewForTextContent;
@property (weak, nonatomic) IBOutlet UILabel *labelForDate;
@property (weak, nonatomic) IBOutlet UILabel *labelForContent;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *ImageForHader;

-(void)setData:(NSString *)haderImage Content:(NSString*)content DateForMessage:(NSDate*)date;
@end
