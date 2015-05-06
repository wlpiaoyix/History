//
//  SellDataViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "BaseViewController.h"
@interface SellDataViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
    NSInteger isLoadStart;
    NSInteger numberOfTab;
    NSInteger selectedIndex;
    UIScrollView *mainScrollView;
    UILabel *selectedLabelBackground;
    UIView *mainView;
    bool nibsRegistered;
    UITextField *currInput;
    NSMutableArray * ChannelManagerList;
    NSMutableArray * CuomstList;
    NSMutableArray * CommitDataList;
    NSMutableArray * getProductsList;
    LoginUser * loginuser;
}
- (IBAction)toButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *CompView;
@property (strong, nonatomic) IBOutlet UIView *CustomerView;
@property (strong, nonatomic) IBOutlet UIButton *filerButtonView;
@property (strong, nonatomic) IBOutlet UIControl *CommitMainPage;
@property (weak, nonatomic) IBOutlet UIButton *FilerAndCommit;
@property (weak, nonatomic) IBOutlet UILabel *lableForCommitSum;
@property (weak, nonatomic) IBOutlet UILabel *lableForNoCommit;
- (IBAction)ChangePage:(id)sender;
- (IBAction)TextInputBegin:(id)sender;
- (IBAction)CommitDataToServer:(id)sender;
- (IBAction)HideKeyborad:(id)sender;
-(void)setSelectIndex:(NSInteger)index;
@property (strong, nonatomic) IBOutlet UIView *viewForGetCommitDataCuostmSell;
@property (strong, nonatomic) IBOutlet UIButton *commitData;
+(id)getSellData;
+(void)newSellData;
@end
