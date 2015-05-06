//
//  UIPersonFlowView.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIPersonFlowView.h"
#import "UIFlowUploadCell2.h"
@interface UIPersonFlowView(){
@private
    __weak UIViewController *controller;
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewDatas;
@property (strong, nonatomic) IBOutlet UIButton *buttonQuery;

@end
@implementation UIPersonFlowView
+(id) getNewInstance{
    UIPersonFlowView *cvc = [[[NSBundle mainBundle] loadNibNamed:@"UIPersonFlowView" owner:self options:nil] lastObject];
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
    _tableViewDatas.delegate = self;
    _tableViewDatas.dataSource = self;
    //==>
    UINib *nib = [UINib nibWithNibName:@"UIFlowUploadCell2" bundle:nil];
    [_tableViewDatas registerNib:nib forCellReuseIdentifier:@"UIFlowUploadCell2"];
    //<==
    [super willMoveToSuperview:newSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFlowUploadCell2 *fuc  = [_tableViewDatas dequeueReusableCellWithIdentifier:@"UIFlowUploadCell2"];
    [fuc setController:controller];
    return fuc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 231.0f;
}
-(void) setController:(UIViewController*) vc{
    controller = vc;
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
