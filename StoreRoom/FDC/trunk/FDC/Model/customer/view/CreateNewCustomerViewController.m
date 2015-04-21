//
//  CreateNewCustomerViewController.m
//  FDC
//
//  Created by NewDoone on 15/2/2.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CreateNewCustomerViewController.h"
#import "LeveyPopListView.h"

@interface CreateNewCustomerViewController ()<LeveyPopListViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray* names;
@property (nonatomic,strong) NSMutableArray* numbers;
@property (nonatomic,strong) NSMutableArray* IDCards;
@property (nonatomic,assign) NSUInteger count;
@property (nonatomic,assign) NSUInteger phoneCount;
@property (nonatomic,assign) NSUInteger IDCount;
@property (nonatomic,strong) NSMutableArray* nameViews;
@property (nonatomic,strong) NSMutableArray* numberViews;
@property (nonatomic,strong) NSMutableArray* IDCardViews;
//数据填充
@property (nonatomic,strong) NSArray * callBackTypes;
@property (nonatomic,strong) NSArray * customerTypes;
@property (nonatomic,strong) NSArray * customerLevels;
@property (nonatomic,strong) NSArray * mindOfLevels;
@property (nonatomic,strong) NSArray * inertviewAddress;


@end

@implementation CreateNewCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
   
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


-(void)initData{
    self.names=nil;
    self.names=[NSMutableArray array];
    self.numbers=nil;
    self.numbers=[NSMutableArray array];
    self.IDCards=nil;
    self.IDCards=[NSMutableArray array];
    self.nameViews=nil;
    self.nameViews=[NSMutableArray array];
    self.numberViews=nil;
    self.numberViews=[NSMutableArray array];
    self.IDCardViews=nil;
    self.IDCardViews=[NSMutableArray array];
    
    self.callBackTypes=@[@"来电",@"来访",@"来访"];
    self.customerTypes=@[@"个人用户",@"集团用户"];
    self.customerLevels=@[@"普通用户",@"中级用户",@"高级用户"];
    self.mindOfLevels=@[@"高",@"中",@"低"];
    self.inertviewAddress=@[@"房交会",@"售楼部"];
    
    self.lb_callBackType.text=[self.callBackTypes objectAtIndex:0];
    self.lb_customerType.text=[self.customerTypes objectAtIndex:0];
    self.lb_customerLevel.text=[self.customerLevels objectAtIndex:0];
    self.lb_mindOfLevel.text=[self.mindOfLevels objectAtIndex:0];
    self.lb_inertviewAddress.text=[self.inertviewAddress objectAtIndex:0];
    
    
}
-(void)initView{
    self.photoIV.layer.cornerRadius=30;
    self.photoIV.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.photoIV.layer.borderWidth=0.6;
    
    
    self.tf_userName.backgroundColor=[UIColor whiteColor];
    self.tf_phoneNumber.backgroundColor=[UIColor whiteColor];
    self.tf_IDNumber.backgroundColor=[UIColor whiteColor];
    self.tf_customerBirthday.backgroundColor=[UIColor whiteColor];
    self.tf_commander.backgroundColor=[UIColor whiteColor];
    self.tf_address.backgroundColor=[UIColor whiteColor];
    self.lb_callBackType.backgroundColor=[UIColor whiteColor];
    self.lb_customerLevel.backgroundColor=[UIColor whiteColor];
    self.lb_customerType.backgroundColor=[UIColor whiteColor];
    self.lb_inertviewAddress.backgroundColor=[UIColor whiteColor];
    self.lb_mindOfLevel.backgroundColor=[UIColor whiteColor];
    CGRect frame=self.bigView.frame;
    frame.origin.y=self.IDView.frame.origin.y+self.IDView.frame.size.height+10;
    
    self.bigView.frame=frame;
    
    self.scrollView.frame=[UIScreen mainScreen].bounds;
    frame =self.scrollView.frame;
    frame.size.height=frame.size.height-self.navigationController.toolbar.frameHeight;
    self.scrollView.frame=frame;
  
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70);
   
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator =NO;
    self.scrollView.bounces=NO;
    
}
#pragma 选照片
- (IBAction)addNewPhotoAction:(id)sender {
    UIImagePickerController* ipc=[[UIImagePickerController alloc]init];
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    ipc.delegate=self;
    ipc.allowsEditing = YES;
//    [self presentViewController:ipc animated:YES completion:nil];
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.photo.image=image;
    
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma 添加多个姓名、电话、身份证
- (IBAction)addCustomerName:(id)sender {
    self.count++;
    UIView* view=[self createViewOnParentView:self.nameView];
    
    [self.nameViews addObject:view];
    
    CGRect viewFrame=CGRectZero;
    UITextField* tf=[self createTextFieldOnParentView:view];
    [self.names addObject:tf];
    
    CGRect frame=view.frame;
    frame.origin.y= (self.tf_userName.frame.size.height+6)*self.count+8;
    view.frame=frame;

    UIButton* btn=[self createButtonOnParentView:view];
    btn.tag=1;

    viewFrame=self.nameView.frame;
    viewFrame.size.height=self.nameView.frame.size.height+self.tf_userName.frame.size.height+5;
    self.nameView.frame=viewFrame;
    
    viewFrame=self.phoneView.frame;
    viewFrame.origin.y=self.nameView.frame.origin.y+self.nameView.frame.size.height+5;
    self.phoneView.frame=viewFrame;
    
    viewFrame=self.IDView.frame;
    viewFrame.origin.y=self.phoneView.frame.origin.y+self.phoneView.frame.size.height+5;
    self.IDView.frame=viewFrame;
    
    viewFrame=self.bigView.frame;
    viewFrame.origin.y=self.IDView.frame.origin.y+self.IDView.frame.size.height+5;
    self.bigView.frame=viewFrame;
    
    self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70+self.tf_userName.frame.size.height+5);

}
- (IBAction)addCustomerPhoneNumber:(id)sender {
    self.phoneCount++;
    UIView* view=[self createViewOnParentView:self.phoneView];
    
    [self.numberViews addObject:view];
    
    CGRect viewFrame=CGRectZero;
    UITextField* tf=[self createTextFieldOnParentView:view];
    [self.numbers addObject:tf];
    
    CGRect frame=view.frame;
    frame.origin.y= (self.tf_phoneNumber.frame.size.height+6)*self.phoneCount+8;
    view.frame=frame;
    
    UIButton* btn=[self createButtonOnParentView:view];
    btn.tag=2;
    
    viewFrame=self.phoneView.frame;
    viewFrame.size.height=self.phoneView.frame.size.height+self.tf_phoneNumber.frame.size.height+5;
    self.phoneView.frame=viewFrame;

    viewFrame=self.IDView.frame;
    viewFrame.origin.y=self.phoneView.frame.origin.y+self.phoneView.frame.size.height+5;
    self.IDView.frame=viewFrame;
    
    viewFrame=self.bigView.frame;
    viewFrame.origin.y=self.IDView.frame.origin.y+self.IDView.frame.size.height+5;
    self.bigView.frame=viewFrame;
    
    self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70+self.tf_phoneNumber.frame.size.height+5);

}
- (IBAction)addCustomerIDCardNumber:(id)sender {
    self.IDCount++;
    UIView* view=[self createViewOnParentView:self.IDView];
    
    [self.IDCardViews addObject:view];
    
    CGRect viewFrame=CGRectZero;
    UITextField* tf=[self createTextFieldOnParentView:view];
    [self.numbers addObject:tf];
    
    CGRect frame=view.frame;
    frame.origin.y= (self.tf_IDNumber.frame.size.height+6)*self.IDCount+8;
    view.frame=frame;
    
    UIButton* btn=[self createButtonOnParentView:view];
    btn.tag=3;
    
    viewFrame=self.IDView.frame;
    viewFrame.size.height=self.IDView.frame.size.height+self.tf_IDNumber.frame.size.height+5;
    self.IDView.frame=viewFrame;
    
    
    viewFrame=self.bigView.frame;
    viewFrame.origin.y=self.IDView.frame.origin.y+self.IDView.frame.size.height+5;
    self.bigView.frame=viewFrame;
    
    self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70+self.tf_IDNumber.frame.size.height+5);
}
- (IBAction)showCallBackType:(id)sender {
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择" options:self.callBackTypes];
    view.delegate=self;
    view.tag=100;
    [view showInView:self.view.window animated:YES];
}
- (IBAction)showCustomerType:(id)sender {
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择" options:self.customerTypes];
    view.delegate=self;
    view.tag=101;
    [view showInView:self.view.window animated:YES];
}
- (IBAction)showCustomerLevel:(id)sender {
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择" options:self.customerLevels];
    view.delegate=self;
    view.tag=102;
    [view showInView:self.view.window animated:YES];
}
- (IBAction)showMinderLevel:(id)sender {
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择" options:self.mindOfLevels];
    view.delegate=self;
    view.tag=103;
    [view showInView:self.view.window animated:YES];
}
- (IBAction)showInterviewAddress:(id)sender {
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择" options:self.inertviewAddress];
    view.delegate=self;
    view.tag=104;
    [view showInView:self.view.window animated:YES];
}
- (IBAction)saveAction:(id)sender {
}
-(UITextField*)createTextFieldOnParentView:(UIView*)view{
    UITextField* tf=[[UITextField alloc]init];
    tf.frame=CGRectMake(0, 0, 177, 32);
    tf.borderStyle=UITextBorderStyleNone;
    tf.backgroundColor=[UIColor whiteColor];
    [view addSubview:tf];
    return tf;
   
}
-(UIButton*)createButtonOnParentView:(UIView*)view{
    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(185, 1, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"button_minus.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeTextFieldWithDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return btn;
}
-(UIView*)createViewOnParentView:(UIView*)view{
    UIView* backView=[[UIView alloc]initWithFrame:CGRectMake(84, 0, 210, 32)];
    backView.backgroundColor=[UIColor clearColor];
    [view addSubview:backView];
    return backView;
}
-(void)removeTextFieldWithDeleteButton:(UIButton*)btn{
    [btn.superview removeFromSuperview];
    if (btn.tag==1) {
        CGRect viewFrame=CGRectZero;
        viewFrame=self.nameView.frame;
        viewFrame.size.height=self.nameView.frame.size.height-self.tf_userName.frame.size.height-5;
        self.nameView.frame=viewFrame;
        
        viewFrame=self.phoneView.frame;
        viewFrame.origin.y=self.phoneView.frame.origin.y-self.tf_userName.frame.size.height-5;
        self.phoneView.frame=viewFrame;
        
        viewFrame=self.IDView.frame;
        viewFrame.origin.y=self.IDView.frame.origin.y-self.tf_userName.frame.size.height-5;
        self.IDView.frame=viewFrame;
        
        viewFrame=self.bigView.frame;
        viewFrame.origin.y=self.bigView.frame.origin.y-self.tf_userName.frame.size.height-5;
        self.bigView.frame=viewFrame;
        
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70);
        [self.nameViews removeObject:btn.superview];
        for (int i=0; i<self.nameViews.count; i++) {
            UIView * view=self.nameViews[i];
            CGRect viewFrame=CGRectZero;
            viewFrame=view.frame;
            viewFrame.origin.y=(self.tf_userName.frame.size.height+6)*(i+1)+8;
            [UIView animateWithDuration:0.3 animations:^{
                view.frame=viewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
         --self.count;
    }
    if (btn.tag==2) {
        CGRect viewFrame=CGRectZero;
        viewFrame=self.phoneView.frame;
        viewFrame.size.height=self.phoneView.frame.size.height-self.tf_phoneNumber.frame.size.height-5;
        self.phoneView.frame=viewFrame;
        
        viewFrame=self.IDView.frame;
        viewFrame.origin.y=self.IDView.frame.origin.y-self.tf_phoneNumber.frame.size.height-5;
        self.IDView.frame=viewFrame;
        
        viewFrame=self.bigView.frame;
        viewFrame.origin.y=self.bigView.frame.origin.y-self.tf_phoneNumber.frame.size.height-5;
        self.bigView.frame=viewFrame;

        
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70);
        [self.numberViews removeObject:btn.superview];
        for (int i=0; i<self.numberViews.count; i++) {
            UIView * view=self.numberViews[i];
            CGRect viewFrame=CGRectZero;
            viewFrame=view.frame;
            viewFrame.origin.y=(self.tf_phoneNumber.frame.size.height+6)*(i+1)+8;
            [UIView animateWithDuration:0.3 animations:^{
                view.frame=viewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        --self.phoneCount;
    }
    if (btn.tag==3) {
        CGRect viewFrame=CGRectZero;
        viewFrame=self.IDView.frame;
        viewFrame.size.height=self.IDView.frame.size.height-self.tf_IDNumber.frame.size.height-5;
        self.IDView.frame=viewFrame;
        
        viewFrame=self.bigView.frame;
        viewFrame.origin.y=self.bigView.frame.origin.y-self.tf_IDNumber.frame.size.height-5;
        self.bigView.frame=viewFrame;
        
        
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.bigView.frameY+self.bigView.frameHeight+70);
        [self.IDCardViews removeObject:btn.superview];
        for (int i=0; i<self.IDCardViews.count; i++) {
            UIView * view=self.IDCardViews[i];
            CGRect viewFrame=CGRectZero;
            viewFrame=view.frame;
            viewFrame.origin.y=(self.tf_IDNumber.frame.size.height+6)*(i+1)+8;
            [UIView animateWithDuration:0.3 animations:^{
                view.frame=viewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        --self.IDCount;
    }
}
#pragma levelPopViewDelegate
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    if (popListView.tag==100) {
        self.lb_callBackType.text=[self.callBackTypes objectAtIndex:anIndex];
    }
    if (popListView.tag==101) {
        self.lb_customerType.text=[self.customerTypes objectAtIndex:anIndex];
    }

    if (popListView.tag==102) {
        self.lb_customerLevel.text=[self.customerLevels objectAtIndex:anIndex];
    }

    if (popListView.tag==103) {
        self.lb_mindOfLevel.text=[self.mindOfLevels objectAtIndex:anIndex];
    }

    if (popListView.tag==104) {
        self.lb_inertviewAddress.text=[self.inertviewAddress objectAtIndex:anIndex];
    }

}
@end
