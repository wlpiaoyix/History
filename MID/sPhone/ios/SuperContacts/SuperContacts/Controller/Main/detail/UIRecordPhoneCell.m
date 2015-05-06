//
//  UIRecordPhoneCell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "UIRecordPhoneCell.h"
@interface UIRecordPhoneCell(){
    IBOutlet UIView *viewContext;
    IBOutlet UIButton *buttonOpt;
@private
@private
    RPCCallBack rpvcbx;
    bool flagInit;
    UIView *targetView;
}
@end
@implementation UIRecordPhoneCell

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
        if(flagInit){
            return;
        }
        flagInit = YES;
        [buttonOpt addTarget:self action:@selector(clickButtonOpt:) forControlEvents:UIControlEventTouchUpInside];
    }
    @finally {
        [super willMoveToSuperview:newSuperview];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.859 green:0.937 blue:0.973 alpha:0.7];
    }
}
-(UIRecordPhoneCell*) addViewInContext:(UIView*) view{
    NSArray *views = [viewContext subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    [viewContext addSubview:view];
    targetView = view;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void) clickButtonOpt:(id) sender{
    if(rpvcbx){
        rpvcbx(targetView);
    }
}
-(void) setButtonOptHidden:(bool)hidden{
    [self->buttonOpt setHidden:hidden];
}
-(void) setButtonOptSelected:(bool) selected{
    self->buttonOpt.selected = selected;
}
-(void) setRPVCallBack:(RPCCallBack) rpvcb{
    self->rpvcbx = rpvcb;
}

@end
