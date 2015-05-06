//
//  UIPersonalFlowManagerView.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIPersonalFlowManagerView.h"
#import "UIFlowUploadCell.h"
#import "FlowManagerDetailController.h"
@interface UIPersonalFlowManagerView(){
@private
    UIColor *colorSubTitle;
    UIViewController *controller;
}
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) IBOutlet UILabel *lableNum;
@property (strong, nonatomic) IBOutlet UITableView *tableViewFlowDatas;
@property (strong, nonatomic) IBOutlet UIView *viewTitle;

@end
@implementation UIPersonalFlowManagerView
+(id) getNewInstance{
    UIPersonalFlowManagerView *cvc = [[[NSBundle mainBundle] loadNibNamed:@"UIPersonalFlowManagerView" owner:self options:nil] lastObject];
    cvc->colorSubTitle = [UIColor colorWithRed:0.988 green:1.000 blue:0.957 alpha:1];
    return cvc;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    _viewTitle.backgroundColor = colorSubTitle;
    //==>
    UINib *nib = [UINib nibWithNibName:@"UIFlowUploadCell" bundle:nil];
    [_tableViewFlowDatas registerNib:nib forCellReuseIdentifier:@"UIFlowUploadCell"];
    //<==
    
    _tableViewFlowDatas.delegate = self;
    _tableViewFlowDatas.dataSource = self;
    _tableViewFlowDatas.scrollEnabled = NO;
    
    [self setCornerRadiusAndBorder:_viewTitle];
    [self setCornerRadiusAndBorder:self];
    [super willMoveToSuperview:newSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFlowUploadCell *fuc  = [_tableViewFlowDatas dequeueReusableCellWithIdentifier:@"UIFlowUploadCell"];
    UIView *u = [UIView new];
    u.backgroundColor = [UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:0.5];
    [fuc setSelectedBackgroundView:u];
    return fuc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FlowManagerDetailController *fmdc = [FlowManagerDetailController getNewInstance];
    [controller.navigationController pushViewController:fmdc animated:YES];
}
-(void) setController:(UIViewController*) vc{
    controller = vc;
}
-(void)setCornerRadiusAndBorder:(UIView *)view{
    view.layer.cornerRadius = 5;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
