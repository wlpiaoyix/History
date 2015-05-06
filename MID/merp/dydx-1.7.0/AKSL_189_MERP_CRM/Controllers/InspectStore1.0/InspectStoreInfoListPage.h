//
//  InspectStoreInfoListPage.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorOfInspectStore.h"
#import "BaseViewController.h"

@interface InspectStoreInfoListPage : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UILabel * textForTitle;
@property (weak,nonatomic) IBOutlet UILabel * textForDate;
@property (weak,nonatomic) IBOutlet UITableView * tableForInspectInfoView;

 
@property (weak, nonatomic) IBOutlet UIButton *butSendPingjia;
@property (weak, nonatomic) IBOutlet UITextField *TextInputPingjia;

@property (weak, nonatomic) IBOutlet UIView *viewZanpingjia;
@property (weak, nonatomic) IBOutlet UIView *viewPingjiaInput;
@property (weak, nonatomic) IBOutlet UIButton *butZanOrCans;

-(void)setData:(SelectorOfInspectStore *)data;

-(IBAction)showSelectType:(UIButton *)sender;
-(IBAction)showSelectSort:(UIButton *)sender;
-(IBAction)goBack:(id)sender;

-(void)reloadData;
-(void)hideZanpingjia;
-(void)showZanpingjia:(long)inspectID isZan:(BOOL)isZan Top:(CGFloat)top indexForData:(int)index;
-(void)showPingjia:(long)inspectID indexForData:(int)index pId:(long)p_id  pname:(NSString *)pname cId:(long)c_id;
-(BOOL)isShowPingjiaInput;
-(void)showImagesView:(int)index;
-(void)showSingePage:(NSString *)userCode Name:(NSString *)name;
@end
