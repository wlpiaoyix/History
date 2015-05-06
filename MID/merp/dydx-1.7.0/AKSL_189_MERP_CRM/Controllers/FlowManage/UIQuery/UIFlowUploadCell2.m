//
//  UIFlowUploadCell2.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIFlowUploadCell2.h"
#import "UIPersonalFlowManagerView.h"
@interface UIFlowUploadCell2(){
@private
    __weak UIViewController *controller;
}
@end
@implementation UIFlowUploadCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    UIPersonalFlowManagerView *psmv = [UIPersonalFlowManagerView getNewInstance];
    NSArray *viewArray = [self.contentView viewWithTag:3333].subviews;
    for (UIView *view in viewArray) {
        [view removeFromSuperview];
    }
    [psmv setController:controller];
    [[self.contentView viewWithTag:3333] addSubview:psmv];
    [super willMoveToSuperview:newSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setController:(UIViewController*) vc{
    controller = vc;
}

@end
