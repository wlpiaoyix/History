//
//  InspectStoreViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DAPagesContainer.h"

@interface InspectStoreViewController : BaseViewController<DAPagesContainerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *MainPage;
@property (weak, nonatomic) IBOutlet UIButton *toLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *toQueryButton;
@property (weak, nonatomic) IBOutlet UIView *viewZanpingjia;
@property (weak, nonatomic) IBOutlet UIView *viewPingjiaInput;
@property (weak, nonatomic) IBOutlet UIButton *butZanOrCans;
@property (assign,nonatomic) bool isQueryRest;
@property (assign) long QueryInspectId;
@property (assign) bool isSingeInfo;
@property (weak, nonatomic) IBOutlet UILabel *textForTitle;
@property (weak, nonatomic) IBOutlet UIButton *butSendPingjia;
@property (weak, nonatomic) IBOutlet UITextField *TextInputPingjia;
-(NSArray *)getListType; 
+(InspectStoreViewController *)getInspectStoreMain;
+(void)newInspectStore;
-(void)clearNotReadMsg;
-(void)reloadData;
-(void)setChangeType:(long)typeId;
-(void)hideZanpingjia;
-(void)showZanpingjia:(long)inspectID isZan:(BOOL)isZan Top:(CGFloat)top indexForData:(int)index;
-(void)showPingjia:(long)inspectID indexForData:(int)index pId:(long)p_id  pname:(NSString *)pname cId:(long)c_id;
-(BOOL)isShowPingjiaInput;
-(void)showPeopleList:(NSString *)userCode;
@end
