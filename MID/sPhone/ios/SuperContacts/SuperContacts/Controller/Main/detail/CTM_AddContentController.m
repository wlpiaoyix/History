//
//  CTM_AddContentController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_AddContentController.h"
#import "EMAsyncImageView.h"
#import "SABFromLocationContentService.h"
#import "CTM_MainController.h"
#import "CTM_RightController.h"
#import "EntityManagerAddressBook.h"
#import "EntityPhone.h"
#import "UIRecordPhoneView.h"
#import "Enum_PhoneType.h"
#import "UIRecordPhoneCell.h"
#import "RecordPhoneViewContext.h"
#import "UIRecordPhoneHeadView.h"
#import "UIBoxView.h"
#import "PopUpDialogView.h"
static int tagctmacc;
@interface CTM_AddContentController (){
    //=>head
    IBOutlet UILabel *lableTitle;
    IBOutlet UIButton *buttonReturn;
    IBOutlet UIButton *buttonConfirm;
    //<==
    //==>operate
    IBOutlet EMAsyncImageView *imageHead;
    IBOutlet EMAsyncImageView *imageHeadBG;
    IBOutlet UIView *viewAddPhoto;
    IBOutlet UIButton *buttonAddPhoto;
    IBOutlet UIView *viewUserName;
    IBOutlet UITextField *textfieldUserName;
    IBOutlet UIView *viewContext;
    IBOutlet UITableView *tabbleViewContext;
    IBOutlet UIButton *buttonDel;
    //<==
@private
    //==>data
//    int countRpvArray;
    //<==
    CallBackSave cbs;//回调
    EntityUser *userx;
//    NSMutableArray *phoneTypeArray;//临时数据
    CGRect rectMSUB;
    RecordPhoneViewContext *rpvc;
    
    bool ifReShow;//是否重新加载UI
    
    bool ifImageChange;//图片是否改变
    UIColor *colorBg;
    NSData *dataBase;//生成的基础图片
    UIBoxView *boxView;
    bool flag01;
    id synFlag01;
    bool flag02;
    
    
    CGRect r1x;
    CGRect r2x;
    CGRect r3x;
}
@end

@implementation CTM_AddContentController
+(id) getNewInstance{
    CTM_AddContentController *xAddContentController = [[CTM_AddContentController alloc]initWithNibName:@"CTM_AddContentController" bundle:nil];
    tagctmacc = 23424;
    xAddContentController->rpvc = [RecordPhoneViewContext new];
    xAddContentController->boxView = [UIBoxView getNewInstance];
    xAddContentController->colorBg = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    xAddContentController->boxView.frame = CGRectMake(0, 0, COMMON_SCREEN_W, COMMON_SCREEN_H);
    return xAddContentController;
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
    
    UINib *nib = [UINib nibWithNibName:@"UIRecordPhoneCell" bundle:nil];
    [tabbleViewContext registerNib:nib forCellReuseIdentifier:@"UIRecordPhoneCell"];
    tabbleViewContext.showsHorizontalScrollIndicator = NO;
    tabbleViewContext.showsVerticalScrollIndicator = NO;
    tabbleViewContext.delegate = self;
    tabbleViewContext.dataSource = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self->buttonReturn addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self->buttonConfirm addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self->buttonDel addTarget:self action:@selector(clickDelData:) forControlEvents:UIControlEventTouchUpInside];
    [self->buttonAddPhoto addTarget:self action:@selector(clickAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setCornerRadiusAndBorder:tabbleViewContext CornerRadius:0];
    [self setCornerRadiusAndBorder:buttonAddPhoto CornerRadius:buttonAddPhoto.frame.size.width/2];
    [self setCornerRadiusAndBorder:imageHead CornerRadius:imageHead.frame.size.width/2];
    [self setCornerRadiusAndBorder:viewUserName CornerRadius:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xInputShow2:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xInputShow:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xInputHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    viewUserName.backgroundColor = colorBg;
//    tabbleViewContext.backgroundColor = colorBg;
}
-(void) viewWillAppear:(BOOL)animated{
    @try {
        if(ifReShow){
            return;
        }
        if(!userx||!userx.userKey){
            [buttonDel setHidden:YES];
            CGRect r = viewContext.frame;
            r.size.height+= +buttonDel.frame.size.height+20;
            viewContext.frame = r;
            lableTitle.text = @"新增通信录";
        }else{
            [buttonDel setHidden:NO];
            lableTitle.text = @"修改通信录";
        }
        rectMSUB = viewContext.frame;
        [self initRPVArray];
        [tabbleViewContext reloadData];
        EntityManagerAddressBook *emab = COMMON_EMAB;
        imageHeadBG.image = [emab findImageBgByRef:userx.userKey];
        imageHead.image = [emab findImageHeadByRef:userx.userKey];
        textfieldUserName.text = userx.userName;
    }
    @finally {
        [self toucheControll];
        [super viewWillAppear:animated];
        if(r1x.size.height==0){
            r1x = viewAddPhoto.frame;
            r2x = viewUserName.frame;
            r3x = tabbleViewContext.frame;
        }
        if(ifReShow){
            return;
        }
        [self startDonghua];
        ifReShow = true;
    }
}
-(void) startDonghua{
    CGRect r1 = CGRectMake(r1x.origin.x, r1x.origin.y, r1x.size.width, r1x.size.height);
    CGRect r2 = CGRectMake(r2x.origin.x, r2x.origin.y, r2x.size.width, r2x.size.height);
    CGRect r3 = CGRectMake(r3x.origin.x, r3x.origin.y, r3x.size.width, r3x.size.height);
    r1.origin.y = 0-r1.size.height;
    r2.origin.y = 0-r2.size.height;
    r3.size.width -= 300;
    r3.origin.x +=150;
    viewAddPhoto.frame = r1;
    viewUserName.frame = r2;
    tabbleViewContext.frame = r3;
    [UIView animateWithDuration:0.5 animations:^{
        viewAddPhoto.frame = r1x;
        viewUserName.frame = r2x;
        tabbleViewContext.frame = r3x;
    }];
}
//==>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int countRpvArrayx = section==0?[self->rpvc countPhoneView]:[self->rpvc countExpandView];
    return countRpvArrayx;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)[indexPath row];
    int section = (int)[indexPath section];
    UIRecordPhoneView *rpv = section==0?[self->rpvc getPhoneView:row]:[self->rpvc getExpandView:row];
    [rpv removeFromSuperview];
    
    UIRecordPhoneCell *rpc  = [tableView dequeueReusableCellWithIdentifier:@"UIRecordPhoneCell"];
    [rpc addViewInContext:rpv];
    int count = section==0?[self->rpvc countPhoneView]-1:[self->rpvc countExpandView]-1;
    int total = section==0?[self->rpvc totalPhoneView]-1:[self->rpvc totalExpandView]-1;
    [rpc setRPVCallBack:^(UIView *targetView) {
        if(count<total&&row==count){
            if(section==0){
                [self->rpvc createPhoneView];
            }else{
                [self->rpvc createExpandView];
            }
        }else{
            if(section==0){
                [self->rpvc removePhoneView:(UIRecordPhoneView*)targetView];
            }else{
                [self->rpvc removeExpandView:(UIRecordPhoneView*)targetView];
            }
        }
        [tabbleViewContext reloadData];
    }];
    [rpc setButtonOptHidden:NO];
    if(row==count&&row<total){
        [rpc setButtonOptSelected:NO];
    }else{
        [rpc setButtonOptSelected:YES];
    }
    if([indexPath section]==0){
        [rpv setCallBackClickLable:^(id rpv) {
            [self toucheControll];
        }];
    }else{
        [rpv setCallBackClickLable:^(id rpv) {
            CGRect r = boxView.frame;
            r.size = CGSizeMake(COMMON_SCREEN_W, COMMON_SCREEN_H);
            boxView.frame = r;
            [[self.view viewWithTag:335621] addSubview:boxView];
            [boxView setTextValue:[((UIRecordPhoneView*)rpv) getLableValue]];
            [boxView setCallBack:^(NSString *value) {
                if([NSString isEnabled:value]){
                    if(![value hasSuffix:@":"]){
                        value = [value stringByAppendingString:@":"];
                    }
                    [((UIRecordPhoneView*)rpv) setTypeName:value];
                }
            }];
        }];
    }
    return rpc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section==0?@"联系方式":@"个人信息";
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIRecordPhoneHeadView  *rphv = [UIRecordPhoneHeadView getNewInstance];
    [super setCornerRadiusAndBorder:rphv CornerRadius:0];
    [rphv setHeadText:section==0?@"联系方式":@"个人信息"];
    rphv.backgroundColor =  [UIColor colorWithRed:0.114 green:0.463 blue:0.784 alpha:0.7];
    return rphv;
}
//<==
//==>
-(void) setEntityUser:(EntityUser*) user{
    self->userx = user ;
}
-(void) setTitleName:(NSString *)titleName{
    self.title = titleName;
}
-(void) setCallBackSave:(CallBackSave) callCackSave{
    self->cbs = callCackSave;
}
-(void) onthreadConfirm{    if(!userx){
    userx = [EntityUser new];
}
    if(ifImageChange)userx.dataImage = dataBase;
    else userx.dataImage = nil;
    userx.userName = textfieldUserName.text;
    NSMutableArray *phones = [NSMutableArray new];
    NSMutableArray *expands = [NSMutableArray new];
    for (int i=0;i<[self->rpvc countPhoneView];i++) {
        UIRecordPhoneView *rpv = [self->rpvc getPhoneView:i];
        EntityPhone *ep =  [rpv getEntityPhone];
        if([NSString isEnabled:ep.phoneNum])[phones addObject:[rpv getEntityPhone]];
    }
    for (int i=0;i<[self->rpvc countExpandView];i++) {
        UIRecordPhoneView *rpv = [self->rpvc getExpandView:i];
        NSString *value = [rpv getPhoneNumber];
        NSString *lable = [rpv getLableValue];
        if([NSString isEnabled:value]&&[NSString isEnabled:lable]){
            NSMutableDictionary *json = [NSMutableDictionary new];
            [json setObject:value forKey:@"value"];
            [json setObject:lable forKey:@"lable"];
            [expands addObject:json];
        }
    }
    userx.telephones = phones;
    userx.jsonInfo = (NSMutableDictionary*)expands;
    @try {
        if(![NSString isEnabled:userx.userName]){
            COMMON_SHOWALERT(@"请输入用户名!");
            return;
        }
        if(!userx.telephones||!([userx.telephones count])){
            COMMON_SHOWALERT(@"请输入电话号码!");
            return;
        }
        SABFromLocationContentService *flcs = COMMON_FLCS;
        if(self->ifImageChange&&dataBase){
            userx.dataImage = dataBase;
        }
        [flcs merge:userx];
        [[CTM_RightController getSingleInstance] refreshData];
        [[CTM_MainController getSingleInstance] refreshRecord];
        [ConfigManage setConfigCache:@"copy" Value:[NSString stringWithFormat:@"%@",[[NSDate new] dateFormateDate:@"yyyy-MM-dd"]]];
        if(cbs){
            cbs(userx);
        }
    }
    @catch (NSException *exception) {
        COMMON_SHOWALERT(exception.reason);
    }
    @finally {
    }
}
-(void) clickConfirm:(id) sender{
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(onthreadConfirm) object:nil];
    [t start];
    [self clickReturn:nil];
}
-(void) clickReturn:(id) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) initRPVArray{
    //==>phone ui
    if(!userx){
        userx = [EntityUser new];
    }
    [self->rpvc initPhoneView:userx.telephones];
    if(!userx.telephones&&![userx.telephones count]){
        [self->rpvc createPhoneView];
    }
    //<==
    //==>other ui
    [self->rpvc initExpandView:(NSArray*)userx.jsonInfo];
    for (int i=0;i<[self->rpvc countExpandView]-1;i++) {
        UIRecordPhoneView *rpv = [self->rpvc getExpandView:i];
        [rpv setKeyBoardType:UIKeyboardTypeNamePhonePad];
    }
    if(![userx.jsonInfo count]){
        [self->rpvc createExpandView];
    }
    //<==
}
-(void)toucheControll{
    [textfieldUserName resignFirstResponder];
    for (int i=0;i<[self->rpvc countPhoneView];i++) {
        UIRecordPhoneView *rpv = [self->rpvc getPhoneView:i];
        [rpv resignFirstResponder];
    }
    for (int i=0;i<[self->rpvc countExpandView];i++) {
        UIRecordPhoneView *rpv = [self->rpvc getExpandView:i];
        [rpv resignFirstResponder];
    }
}
//<==
-(void) xInputShow:(NSNotification *)notification{
    if(textfieldUserName.isFirstResponder){
        flag01 = false;
        return;
    }
    @synchronized(synFlag01){
        if(flag01)return;
        flag01 = true;
    }
    //    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect rx = [self.view viewWithTag:335621].frame;
        rx.origin.y = 44-rectMSUB.origin.y;
        [self.view viewWithTag:335621].frame = rx;
        CGRect r = viewContext.frame;
        if(rectMSUB.size.height>COMMON_SCREEN_H-44-keyBoardFrame.size.height){
            r.size.height = COMMON_SCREEN_H-44-keyBoardFrame.size.height;
        }
        viewContext.frame = r;
    }];
}
-(void) xInputShow2:(NSNotification *)notification{
    if(textfieldUserName.isFirstResponder){
        return;
    }
    @synchronized(synFlag01){
        flag01 = true;
    }
//    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect rx = [self.view viewWithTag:335621].frame;
        rx.origin.y = 44-rectMSUB.origin.y;
        [self.view viewWithTag:335621].frame = rx;
        CGRect r = viewContext.frame;
        if(rectMSUB.size.height>COMMON_SCREEN_H-44-keyBoardFrame.size.height){
            r.size.height = COMMON_SCREEN_H-44-keyBoardFrame.size.height;
        }
        viewContext.frame = r;
    }];
}
-(void) xInputHidden:(NSNotification *)notification{
    flag01 = false;
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect rx = [self.view viewWithTag:335621].frame;
        rx.origin.y = 44;
        [self.view viewWithTag:335621].frame = rx;
        viewContext.frame = rectMSUB;
    }];
}
-(void) clickAddPhoto:(id) sender{
    COMMON_SHOWSHEET(@"设置头像", self.view, self, @"照相机",@"相册");
}
-(void) clickDelData:(id) sender{
    COMMON_SHOWMSGDELEGATE(@"确定删除当前联系人?", self, @"是",@"否",nil);
}
- (void)alertView:(PopUpDialogView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            @try {
                SABFromLocationContentService *flcs = COMMON_FLCS;
                if(userx&&userx.userKey){
                    [flcs remove:userx];
                    COMMON_SHOWALERT(@"删除成功!");
                    [[CTM_RightController getSingleInstance] refreshData];
                    [[CTM_MainController getSingleInstance] refreshRecord];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    COMMON_SHOWMSG(@"删除失败", @"无效用户!");
                }
            }
            @catch (NSException *exception) {
                COMMON_SHOWALERT(exception.reason);
            }
            @finally {
                [alertView close];
            }
        }
            break;
        default:
        {
        }
            break;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: {
            [self startCamera];
        }
            break;
        case 1: {
            [self OpenAlunm];
        }
            break;
        default:
            break;
    }
}
#pragma mark  照相
- (void)startCamera {
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
	//isCamera = TRUE;
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else
	{
        COMMON_SHOWALERT(@"照相机不存在");
		return;
	}
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:camera animated:YES];
	[self presentModalViewController:camera animated:YES];
}
#pragma mark  开相册
-(void)OpenAlunm{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];//创建
    picker.delegate = self;//设置为托
    picker.allowsEditing=YES;//允许编辑图片
    [self presentModalViewController:picker animated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark ImagePickerControllerDelegate 确认选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize size = image.size;
        if(size.width>COMMON_SCREEN_W*2){
            float bl = COMMON_SCREEN_W*2/size.width;
            float blx = COMMON_SCREEN_H*2/size.height;
            if (blx>bl) {
                bl = blx;
            }
            size = CGSizeMake(bl*size.width, bl*size.height);
            image = [image setImageSize:size];
        }
        dataBase = UIImageJPEGRepresentation(image, 1.0f);
        size = CGSizeMake(COMMON_SCREEN_W, COMMON_SCREEN_H-44);
        UIImage *tempImage2 = COMMON_CUTIMG(image);
        imageHeadBG.image = tempImage2;
        UIImage *tempImage3  = [tempImage2 setImageSize:CGSizeMake(110, 110*size.height/size.width)];
        imageHead.image = [tempImage3 cutImage:CGRectMake(0, (tempImage3.size.height-110)/2, 110, 110)];
        ifImageChange = true;
	}
	else
	{
		return;
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
