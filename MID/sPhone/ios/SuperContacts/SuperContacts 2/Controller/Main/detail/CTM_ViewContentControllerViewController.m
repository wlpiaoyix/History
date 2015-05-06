//
//  CTM_ViewContentControllerViewController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_ViewContentControllerViewController.h"
#import "CTM_AddContentController.h"
#import "EMAsyncImageView.h"
#import "EntityPhone.h"
#import "MADE_COMMON.h"
static CTM_ViewContentControllerViewController *xViewContentController;
@interface CTM_ViewContentControllerViewController (){
@private CGRect rectlableTitle02;//初始化时对应的Frame
@private CGRect rectview01;//初始化时对应的Frame
@private CGRect rectview02;//初始化时对应的Frame
@private CGSize contentSize;//初始化时对应的ContentSize
}

@property (strong, nonatomic) IBOutlet UILabel *lableTitle02;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBase;
@property (strong, nonatomic) IBOutlet UIView *viewName;
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIView *view02;
@property (strong, nonatomic) IBOutlet UIView *view0103;
@property (strong, nonatomic) IBOutlet UIView *view0104;
@property (strong, nonatomic) IBOutlet UIView *view0105;
@property (strong, nonatomic) IBOutlet UIView *view0106;
@property (strong, nonatomic) IBOutlet UIView *view0107;
@property (strong, nonatomic) IBOutlet UILabel *lable0103;
@property (strong, nonatomic) IBOutlet UILabel *lable0104;
@property (strong, nonatomic) IBOutlet UILabel *lable0105;
@property (strong, nonatomic) IBOutlet UILabel *lable0106;
@property (strong, nonatomic) IBOutlet UILabel *lable0107;


@property (strong, nonatomic) IBOutlet UIView *view0201;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageHead;
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneDefault;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneMobile;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneHome;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneCompany;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneOther;
@property (strong, nonatomic) IBOutlet UILabel *lableNikeName;
@property (strong, nonatomic) IBOutlet UILabel *lableEmail;
@end

@implementation CTM_ViewContentControllerViewController
+(id) getSingleInstance{
    @synchronized(xViewContentController){
        if(!xViewContentController){
            xViewContentController = [[CTM_ViewContentControllerViewController alloc]initWithNibName:@"CTM_ViewContentControllerViewController" bundle:nil];
        }
    }
    return xViewContentController;
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
    
    [self setCornerRadiusAndBorder2:_viewName];
    [self setCornerRadiusAndBorder2:_view01];
    [self setCornerRadiusAndBorder2:_view02];
    [self setCornerRadiusAndBorder1:_view0104];
    [self setCornerRadiusAndBorder1:_view0106];
    [self setCornerRadiusAndBorder1:_view0201];
    
    _imageHead.isIgnoreCacheFile = YES;
    
    _scrollViewBase.scrollEnabled = YES;
    CGRect r = _scrollViewBase.frame;
    r.size.height = COMMON_SCREEN_H-44;
    _scrollViewBase.contentSize = CGSizeMake(320, 648);
    _scrollViewBase.frame = r;
    _imageHead.frame = r;
    _scrollViewBase.showsHorizontalScrollIndicator = NO;
    _scrollViewBase.showsVerticalScrollIndicator = NO;
    contentSize = _scrollViewBase.contentSize;
    rectlableTitle02  = _lableTitle02.frame;
    rectview01 = _view01.frame;
    rectview02 = _view02.frame;
    _view01.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    _view02.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
}
-(void) viewWillAppear:(BOOL)animated{
    @try {
        //==>初始化显示
        _imageHead.image = nil;
        _lableName.text = @"--姓名--";
        _lablePhoneDefault.text = @"";
        _lablePhoneMobile.text = @"";
        _lablePhoneHome.text = @"";
        _lablePhoneCompany.text = @"";
        _lablePhoneOther.text = @"";
        _lableNikeName.text = @"";
        _lableEmail.text = @"";
        //<==
        //==>基本信息设置
        if([NSString isEnabled:_entityUser.dataImage]&&[_entityUser.dataImage isKindOfClass:[NSString class]]){
            NSString *path640 = [MADE_COMMON parsetAddTag:@"640" Url:_entityUser.dataImage];
            [MADE_COMMON pasetImageAddWrite110ak640:_entityUser.dataImage];
            _imageHead.image = [UIImage imageWithContentsOfFile:path640];
        }
        else if(_entityUser.dataImage&&[_entityUser.dataImage isKindOfClass:[NSData class]])_imageHead.image=[[UIImage alloc] initWithData:_entityUser.dataImage];
        _lableName.text = _entityUser.userName;
        [self checkPhoneNum:[_entityUser getTelephones]];
        //<==
        //==>拓展信息设置
        if(!_entityUser.jsonInfo)return;
        if([NSString isEnabled:[_entityUser.jsonInfo objectForKey:@"nickName"]]){
            _lableNikeName.text = [_entityUser.jsonInfo objectForKey:@"nickName"];
        }
        if([NSString isEnabled:[_entityUser.jsonInfo objectForKey:@"email"]]){
            _lableEmail.text = [_entityUser.jsonInfo objectForKey:@"email"];
        }
        //<==
    }
    @finally {
        [super viewWillAppear:animated];
    }
}
- (IBAction)clickEdite:(id)sender {
    CTM_AddContentController *c = [CTM_AddContentController getNewInstance];
    [c setEntityUser:_entityUser];
    [c setTitleName:@"编辑联系人"];
    [c setCallBackSave:false];
    [self.navigationController pushViewController:c animated:YES];
}
- (IBAction)cilckReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setCornerRadiusAndBorder1:(UIView *)view {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
-(void)setCornerRadiusAndBorder2:(UIView *)view{
//    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.8]CGColor];
}
-(void) checkPhoneNum:(NSArray*) telephones{
    [_view0103 setHidden:YES];
    [_view0104 setHidden:YES];
    [_view0105 setHidden:YES];
    [_view0106 setHidden:YES];
    [_view0107 setHidden:YES];
    int index = 0;
    for (EntityPhone *mp in telephones) {
        UIView *curView = nil;
        UILabel *curLable01 = nil;
        UILabel *curLable02 = nil;
        switch (mp.type) {
            case phone_default:
                curLable01 = _lablePhoneDefault;
                curLable02 = _lable0103;
                curView = _view0103;
                break;
            case phone_mobile:
                curLable01 = _lablePhoneMobile;
                curLable02 = _lable0104;
                curView = _view0104;
                break;
            case phone_home:
                curLable01 = _lablePhoneHome;
                curLable02 = _lable0105;
                curView = _view0105;
                break;
            case phone_company:
                curLable01 = _lablePhoneCompany;
                curLable02 = _lable0106;
                curView = _view0106;
                break;
            case phone_other:
                curLable01 = _lablePhoneOther;
                curLable02 = _lable0107;
                curView = _view0107;
                break;
            default:
                break;
        }
        if(curLable01)curLable01.text = mp.phoneNum;
        if(curLable02)curLable02.text = [NSString stringWithFormat:@"%@:",[Enum_PhoneType nameByEnum:mp.type]];
        if (curView) {
            [curView setHidden:NO];
            if(index%2){
                [super setCornerRadiusAndBorder:curView CornerRadius:0];
            }else{
                [super setCornerRadiusAndBorder:curView CornerRadius:0 BorderWidth:0 BorderColor:[[UIColor clearColor] CGColor]];
            }
            CGRect r = curView.frame;
            r.origin.y = index*60;
            curView.frame = r;
        }
        index++;
    }
    _scrollViewBase.contentSize = CGSizeMake(contentSize.width, contentSize.height-(5-index)*60);
    CGRect r = _view01.frame;
    r.size.height = rectview01.size.height-(5-index)*60;
    _view01.frame = r;
    CGRect r2 = _view02.frame;
    r2.origin.y = rectview02.origin.y-(5-index)*60;
    _view02.frame = r2;
    CGRect r3 = _lableTitle02.frame;
    r3.origin.y = rectlableTitle02.origin.y-(5-index)*60;
    _lableTitle02.frame = r3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
