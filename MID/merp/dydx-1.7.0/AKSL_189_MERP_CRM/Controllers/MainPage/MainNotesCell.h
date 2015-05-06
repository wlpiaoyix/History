//
//  MainNotesCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-30.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNotesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TimeText;
@property (weak, nonatomic) IBOutlet UILabel *Content;
@property (weak, nonatomic) IBOutlet UIImageView *ImageToNotes;
@property (weak, nonatomic) IBOutlet UIView *mainview;

-(void)setData:(NSString *)content Type:(NSInteger)celltype Time:(NSDate *)date;
@end
