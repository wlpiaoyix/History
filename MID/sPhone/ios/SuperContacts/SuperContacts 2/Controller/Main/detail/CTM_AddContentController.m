//
//  CTM_AddContentController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_AddContentController.h"
#import "EMAsyncImageView.h"
#import "SABFromDataBaseService.h"
#import "MADE_COMMON.h"
#import "CTM_MainController.h"
#import "CTM_RightController.h"
#import "EntityPhone.h"
#import "UIRecordPhoneView.h"
#import "Enum_PhoneType.h"
#import "UIRecordPhoneCell.h"
#import "RecordPhoneViewContext.h"
#import "UIRecordPhoneHeadView.h"
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
    int countRpvArray;
    //<==
    CallBackSave cbs;//回调
    EntityUser *userx;
//    NSMutableArray *phoneTypeArray;//临时数据
    CGRect rectMSUB;
    RecordPhoneViewContext *rpvc;
    
    bool ifReShow;//是否重新加载UI
    
    bool ifImageChange;//图片是否改变
    UIColor *colorBg;
    UIImage *imageBase;//生成的基础图片
}
@end

@implementation CTM_AddContentController
+(id) getNewInstance{
    CTM_AddContentController *xAddContentController = [[CTM_AddContentController alloc]initWithNibName:@"CTM_AddContentController" bundle:nil];
    tagctmacc = 23424;
    xAddContentController->rpvc = [RecordPhoneViewContext new];
    xAddContentController->rpvc.tag = tagctmacc;
    xAddContentController->colorBg = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
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
    
    [self setCornerRadiusAndBorder:tabbleViewContext CornerRadius:0];
    [self setCornerRadiusAndBorder:buttonAddPhoto CornerRadius:buttonAddPhoto.frame.size.width/2];
    [self setCornerRadiusAndBorder:imageHead CornerRadius:imageHead.frame.size.width/2];
    [self setCornerRadiusAndBorder:viewUserName CornerRadius:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xInputShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xInputHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    viewUserName.backgroundColor = colorBg;
    tabbleViewContext.backgroundColor = colorBg;
}
-(void) viewWillAppear:(BOOL)animated{
    @try {
        if(ifReShow){
            return;
        }
        if(!userx||!userx.userId){
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
        ifReShow = true;
        [self initRPVArray];
        [tabbleViewContext reloadData];
        if([NSString isEnabled:userx.dataImage]&&[userx.dataImage isKindOfClass:[NSString class]]){
            imageHeadBG.image= [UIImage imageWithContentsOfFile:[MADE_COMMON parsetAddTag:@"640" Url:userx.dataImage]];
            imageHead.image=[UIImage imageWithContentsOfFile:[MADE_COMMON parsetAddTag:@"110" Url:userx.dataImage]];
        }
        textfieldUserName.text = userx.userName;
    }
    @finally {
        [self toucheControll];
        [super viewWillAppear:animated];
    }
}
//==>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int countRpvArrayx = section==0?[self->rpvc countPhoneView]:[self->rpvc countProlongationView];
//    if(section==0){
//        countRpvArray = 0;
//    }
    countRpvArray = countRpvArrayx;
    return countRpvArrayx;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    int section = [indexPath section];
    __weak typeof(self) tempself = self;
    UIRecordPhoneView *rpv = section==0?[self->rpvc getPhoneViewByIndex:row]:[self->rpvc getProlongationViewByIndex:row];
    UIRecordPhoneCell *rpc  = [tableView dequeueReusableCellWithIdentifier:@"UIRecordPhoneCell"];
    [rpc addViewInContext:rpv];
    NSLog(@"%d",rpv.tag);
    [rpc setRPVCallBack:^(UIView *targetView) {
        int index = [self->rpvc countPhoneView]-1;
        if([self->rpvc isLastView:targetView.tag]&&index<4){
            [tempself addLastView];
        }else{
            [tempself delTargetView:targetView.tag];
        }
        [tabbleViewContext reloadData];
    }];
    if([indexPath section]==1){
        [rpc setButtonOptHidden:YES];
    }else{
        [rpc setButtonOptHidden:NO];
        
        if(row==countRpvArray-1&&row<4){
            [rpc setButtonOptSelected:NO];
        }else{
            [rpc setButtonOptSelected:YES];
        }
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
    return section==0?@"基本信息":@"拓展信息";
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIRecordPhoneHeadView  *rphv = [UIRecordPhoneHeadView getNewInstance];
    [super setCornerRadiusAndBorder:rphv CornerRadius:0];
    [rphv setHeadText:section==0?@"基本信息":@"拓展信息"];
    rphv.backgroundColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.780 alpha:0.8];
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
-(void) clickConfirm:(id) sender{
    if(!userx){
        userx = [EntityUser new];
    }
    userx.userName = textfieldUserName.text;
    NSMutableArray *phones = [NSMutableArray new];
    for (int i=0; i<5; i++) {
        UIRecordPhoneView *rpv = (UIRecordPhoneView*)[tabbleViewContext viewWithTag:tagctmacc+i];
        if(rpv){
            EntityPhone *p = [rpv getEntityPhone ];
            if(p)[phones addObject:rpv.getEntityPhone];
        }
    }
    userx.telephones = phones;
    UIRecordPhoneView *rpv10 = (UIRecordPhoneView*)[tabbleViewContext viewWithTag:tagctmacc+10];
    UIRecordPhoneView *rpv11 = (UIRecordPhoneView*)[tabbleViewContext viewWithTag:tagctmacc+11];
    NSMutableDictionary *json = [NSMutableDictionary new];
    if([NSString isEnabled:[rpv10 getPhoneNumber]]){
        [json setObject:[rpv10 getPhoneNumber] forKey:@"nickName"];
    }
    if([NSString isEnabled:[rpv11 getPhoneNumber]]){
        [json setObject:[rpv11 getPhoneNumber] forKey:@"email"];
    }
    userx.jsonInfo = json;
    @try {
        if(![NSString isEnabled:userx.userName]){
            COMMON_SHOWALERT(@"请输入用户名!");
            return;
        }
        if(!userx.telephones||!([userx.telephones count])){
            COMMON_SHOWALERT(@"请输入电话号码!");
            return;
        }
        EntityPhone *phone = userx.telephones[0];
        userx.defaultPhone = phone.phoneNum;
        SABFromDataBaseService *fdb = COMMON_FDBS;
        if(self->ifImageChange&&imageBase){
            if(![NSString isEnabled:userx.dataImage]){
                NSString *path = [ConfigManage getDocumentsDirectory];
                path = [NSString stringWithFormat:@"%@/%d.jpg",path,arc4random()];
                userx.dataImage = path;
            }
            [MADE_COMMON deleteImage110ak640:userx.dataImage];
            NSData *imageData = UIImageJPEGRepresentation(imageBase, 1.0f);
            [imageData writeToFile:userx.dataImage atomically:YES];
        }
        [fdb mergeEntityUser:userx];
        [MADE_COMMON pasetImageAddWrite110ak640:userx.dataImage];
        [[CTM_RightController getSingleInstance] refreshData];
        [[CTM_MainController getSingleInstance] refreshRecord];
        COMMON_SHOWALERT(@"保存成功!");
        [ConfigManage setConfigCache:@"copy" Value:[NSString stringWithFormat:@"%f",[NSDate new].timeIntervalSince1970]];
        [self clickReturn:sender];
        if(cbs){
            cbs(userx);
        }
    }
    @catch (NSException *exception) {
        COMMON_SHOWALERT(exception.reason);
    }
    
}
-(void) clickReturn:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) delTargetView:(int) targetIndex{
    [self->rpvc removePhoneViewByTag:targetIndex];
    [self->tabbleViewContext reloadData];
}
-(void) addLastView{
    [self->rpvc addNextPhoneView];
    [self->tabbleViewContext reloadData];
}
-(void) initRPVArray{
    [self->rpvc removeAllView];
    //==>phone ui
    NSMutableArray *phoneArray = [NSMutableArray new];
    [phoneArray addObjectsFromArray:[userx getTelephones]];
    NSMutableArray *tempEnums = [Enum_PhoneType enums];
    int index = 0;
    for (EntityPhone *phone in phoneArray) {
        UIRecordPhoneView *rpv = [self->rpvc addPhoneView:phone.type];
        [rpv setEntityPhone:phone];
        for (NSNumber *num in tempEnums) {
            if(phone.type==num.intValue){
                [tempEnums removeObject:num];
                break;
            }
        }
        index++;
    }
    if([tempEnums count]>0&&![phoneArray count]){
        EntityPhone *phone = [EntityPhone new];
        phone.type = ((NSNumber*)tempEnums[0]).intValue;
        phone.entityUser = userx;
        UIRecordPhoneView *rpv = [self->rpvc addPhoneView:phone.type];
        [rpv setEntityPhone:phone];
    }
    //<==
    //==>other ui
    NSString *nickName = @"";
    NSString *email = @"";
    if(userx.jsonInfo){
        if([NSString isEnabled:[userx.jsonInfo objectForKey:@"nickName"]]){
            nickName = [userx.jsonInfo objectForKey:@"nickName"];
        }
        if([NSString isEnabled:[userx.jsonInfo objectForKey:@"email"]]){
            email = [userx.jsonInfo objectForKey:@"email"];
        }
    }

    UIRecordPhoneView *rpv_o01 = [self->rpvc addProlongationView:0];
    [rpv_o01 setPhoneNumber:nickName];
    [rpv_o01 setKeyBoardType:UIKeyboardTypeNamePhonePad];
    UIRecordPhoneView *rpv_o02 = [self->rpvc addProlongationView:1];
    [rpv_o02 setPhoneNumber:email];
    [rpv_o02 setKeyBoardType:UIKeyboardTypeEmailAddress];
    //<==
}
-(void)toucheControll{
    [textfieldUserName resignFirstResponder];
    [self->rpvc starEL];
    UIRecordPhoneView * rpv = [self->rpvc hasNext];
    while (rpv) {
        [rpv resignFirstResponder];
        rpv = [self->rpvc hasNext];
    }
}
//<==
-(void) xInputShow:(NSNotification *)notification{
    if(textfieldUserName.isFirstResponder){
        return;
    }
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
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
    @try {
        SABFromDataBaseService *fdb = COMMON_FDBS;
        if(userx&&userx.userId){
            [fdb removeEntityUser:userx];
            if([NSString isEnabled:userx.dataImage])
            [MADE_COMMON deleteImage110ak640:userx.dataImage];
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
		imageBase = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize size = imageBase.size;
        if(size.width>COMMON_SCREEN_W*2){
            float bl = COMMON_SCREEN_W*2/size.width;
            float blx = COMMON_SCREEN_H*2/size.height;
            if (blx>bl) {
                bl = blx;
            }
            size = CGSizeMake(bl*size.width, bl*size.height);
            imageBase = [imageBase setImageSize:size];
        }
        size = CGSizeMake(COMMON_SCREEN_W, COMMON_SCREEN_H-44);
//        rx.size.width = COMMON_SCREEN_W;
//        rx.size.height = COMMON_SCREEN_H-44;
//        imageHeadBG.frame = rx;
        UIImage *tempImage2 = COMMON_CUTIMG(imageBase);
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
