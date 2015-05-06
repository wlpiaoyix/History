//
//  UIRecordPhoneViewCell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 3/20/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import "UIRecordPhoneViewCell.h"
#import "SerCallService.h"
@implementation UIRecordPhoneViewCell{
    IBOutlet UILabel *lableTitle;
    IBOutlet UILabel *lableContext;
    IBOutlet UIButton *buttonCall;
}
-(id) init{
    if(self = [super init]){
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    @try {
        [buttonCall addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.859 green:0.937 blue:0.973 alpha:0.7];
    }
    @finally {
        [super willMoveToSuperview:newSuperview];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setTitle:(NSString*) title Name:(NSString *) name flag:(bool) isCall{
    lableTitle.text = title;
    lableContext.text = name;
    [buttonCall setHidden:!isCall];
}
-(void) call:(id) sender{
    [SerCallService call:lableContext.text];
}
@end
