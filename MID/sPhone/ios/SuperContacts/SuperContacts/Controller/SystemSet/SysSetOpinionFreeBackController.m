//
//  SysSetOpinionFreeBackController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-5.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SysSetOpinionFreeBackController.h"
static SysSetOpinionFreeBackController *xOpinionFreeBackController;
@interface SysSetOpinionFreeBackController (){
@private CGRect viewOpinionFrame;//初始化时对应的Frame
@private int maxlength;
}
@property (strong, nonatomic) IBOutlet UIView *viewOpinion;
@property (strong, nonatomic) IBOutlet UITextView *textViewOpinion;
@property (strong, nonatomic) IBOutlet UILabel *lableTextLength;
@end

@implementation SysSetOpinionFreeBackController
+(id) getSingleInstance{
    @synchronized(xOpinionFreeBackController){
        if(!xOpinionFreeBackController){
            xOpinionFreeBackController = [[SysSetOpinionFreeBackController alloc]initWithNibName:@"SysSetOpinionFreeBackController" bundle:nil];
            xOpinionFreeBackController->methodIntputshow = @selector(inputshowKeyborad:);
            xOpinionFreeBackController->methodIntputhidden = @selector(hiddenshowKeyborad:);
        }
    }
    return xOpinionFreeBackController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) tempself = self;
    _textViewOpinion.delegate = tempself;
    [super setCornerRadiusAndBorder:_textViewOpinion CornerRadius:0.0f];
    [super setCornerRadiusAndBorder:_lableTextLength CornerRadius:_lableTextLength.frame.size.height/2 BorderWidth:0 BorderColor:[[UIColor clearColor] CGColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll)];
    [self.view addGestureRecognizer:tapGesture];
    viewOpinionFrame = _viewOpinion.frame;
    
    [super setKeyboardNotification];
    
    maxlength = 150;
}
-(bool) toucheControll{
    return [_textViewOpinion resignFirstResponder];
}
-(void) viewWillAppear:(BOOL)animated{
    [_textViewOpinion resignFirstResponder];
    [super viewWillAppear:animated];
}

- (IBAction)clickConfirm:(id)sender {
    @try {
        NSString *opinion = _textViewOpinion.text;
        if(![NSString isEnabled:opinion]){
            COMMON_SHOWALERT(@"请输入您的意见!");
            return;
        }
        if(opinion.length>maxlength){
            NSString *msg = [NSString stringWithFormat:@"已超出%lu字",(opinion.length-maxlength)];
            COMMON_SHOWALERT(msg);
        }
    }
    @catch (NSException *exception) {
        COMMON_SHOWALERT(exception.reason);
    }
    @finally {
        [super hideActivityIndicator];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    _lableTextLength.text = (maxlength - textView.text.length>=0)?[NSString stringWithFormat:@"%d",maxlength - textView.text.length]:@"--";
}

-(void)inputshowKeyborad:(NSNotification *)notification{
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if(keyBoardFrame.origin.y<_viewOpinion.frame.size.height+84){
        __weak typeof(self) tempself = self;
        [UIView animateWithDuration:animationTime animations:^{
            CGRect r = tempself.viewOpinion.frame;
            r = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height);
            r.size.height = keyBoardFrame.origin.y - 84;
            tempself.viewOpinion.frame = r;
        }];
    }
}
-(void)hiddenshowKeyborad:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak typeof(self) tempself = self;
    [UIView animateWithDuration:animationTime animations:^{
        tempself.viewOpinion.frame = viewOpinionFrame;
    }];
    
}
- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
