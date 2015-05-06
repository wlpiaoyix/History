//
//  SysSetPersonInfoController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-3.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SysSetPersonInfoController.h"
#import "EMAsyncImageView.h"
#import "ModleUser.h"
#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"
@interface SysSetPersonInfoController (){
@private
    int sheetIndex;
    int randomTag;//当前Controller对应的tag随机数
    id ysyn;//同步使用的对象
    bool isHasShowKeyBoard;//键盘是否已显示出来
    CGRect frameScrollView;//scrollView初始化时对应的Frame
    ModleUser *user;
    NSString *fullPath;
    bool ischangeImage;//是否有改变图片
    //==>下载图片参数
    id	 sync;
    NSURLConnection	*connection;
    NSMutableData *imageData;
    bool finished;
    //<==
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) IBOutlet UIView *viewName;
@property (strong, nonatomic) IBOutlet UIView *viewSex;
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIView *view02;
@property (strong, nonatomic) IBOutlet UIView *view03;
@property (strong, nonatomic) IBOutlet UIView *view0102;
@property (strong, nonatomic) IBOutlet UIView *view0103;
@property (strong, nonatomic) IBOutlet UIView *view0201;
@property (strong, nonatomic) IBOutlet UIView *view0202;
@property (strong, nonatomic) IBOutlet UIView *view0301;
@property (strong, nonatomic) IBOutlet UIView *view0302;

@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageHead;

@property (strong, nonatomic) IBOutlet UIView *viewAddHead;

@property (strong, nonatomic) IBOutlet UILabel *lableSex;
@property (strong, nonatomic) IBOutlet UILabel *lablePhone;

@property (strong, nonatomic) IBOutlet UITextField *textFieldName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldQQ;
@property (strong, nonatomic) IBOutlet UITextField *textFieldWx;
@property (strong, nonatomic) IBOutlet UITextField *textFieldQB;
@property (strong, nonatomic) IBOutlet UITextField *textFieldYX;
@property (strong, nonatomic) IBOutlet UITextField *textFieldJTZZ;
@property (strong, nonatomic) IBOutlet UITextField *textFieldGSDZ;

@end

@implementation SysSetPersonInfoController

+(id) getNewInstance{
    SysSetPersonInfoController *xPersonInfoController = [[SysSetPersonInfoController alloc]initWithNibName:@"SysSetPersonInfoController" bundle:nil];
    xPersonInfoController->target = xPersonInfoController;
    xPersonInfoController->methodIntputhidden=@selector(xInputHidden:);
    xPersonInfoController->methodIntputshow=@selector(xInputShow:);
    return xPersonInfoController;
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
    randomTag =  (long long int)arc4random() % 1000000;
    [super viewDidLoad];
    [super setKeyboardNotification];
    [self checkView];
    frameScrollView = CGRectMake(_scrollViewMain.frame.origin.x, _scrollViewMain.frame.origin.y, _scrollViewMain.frame.size.width, _scrollViewMain.frame.size.height);
}
-(void) checkView{
    float sizey = COMMON_SCREEN_H-44;
    _scrollViewMain.frame = CGRectMake(0,44, COMMON_SCREEN_W, sizey);
    _scrollViewMain.scrollEnabled = YES;
    _scrollViewMain.contentSize = CGSizeMake(COMMON_SCREEN_W, 544);
    _scrollViewMain.showsHorizontalScrollIndicator = NO;
    _scrollViewMain.showsVerticalScrollIndicator = NO;
    
    [super setCornerRadiusAndBorder:_viewAddHead  CornerRadius:_viewAddHead.frame.size.width/2];
    [super setCornerRadiusAndBorder:_viewName CornerRadius:0];
    [super setCornerRadiusAndBorder:_viewSex CornerRadius:0];
    [super setCornerRadiusAndBorder:_view01 CornerRadius:0];
    [super setCornerRadiusAndBorder:_view02 CornerRadius:0];
    [super setCornerRadiusAndBorder:_view03 CornerRadius:0];
    [super setCornerRadiusAndBorder:_view0102 CornerRadius:0];
    [super setCornerRadiusAndBorder:_view0202 CornerRadius:0];
    [super setCornerRadiusAndBorder:_view0302 CornerRadius:0];
    
    _view01.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    _view02.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    _view03.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll)];
    [self.view addGestureRecognizer:tapGesture];
    __weak typeof(self) tempself = self;
    _textFieldName.delegate = tempself;
    _textFieldQQ.delegate = tempself;
    _textFieldWx.delegate = tempself;
    _textFieldQB.delegate = tempself;
    _textFieldYX.delegate = tempself;
    _textFieldJTZZ.delegate = tempself;
    _textFieldGSDZ.delegate = tempself;
    
    _textFieldName.tag = randomTag+1;
    _textFieldQQ.tag =  randomTag+2;
    _textFieldWx.tag =  randomTag+3;
    _textFieldQB.tag =  randomTag+4;
    _textFieldYX.tag =  randomTag+5;
    _textFieldJTZZ.tag =  randomTag+6;
    _textFieldGSDZ.tag =  randomTag+7;
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(checkUser) object:nil];
    [t start];
    
}
-(void) viewWillAppear:(BOOL)animated{
    ischangeImage = NO;
    [super viewWillAppear:animated];
}

- (IBAction)clickSex:(id)sender {
    sheetIndex = 0;
    COMMON_SHOWSHEET(@"性别", self.view, self, @"男",@"女");
}
- (IBAction)clickAddHead:(id)sender {
    sheetIndex = 1;
    COMMON_SHOWSHEET(@"添加照片", self.view, self, @"相机",@"相册");
}
- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) uploadImage{
    ASIFormDataRequest *requestx = [HttpApiCall requestCallUpload:@"/upload" Params:nil Logo:@"uploaduserheadimage" OutTime:30];
    [requestx setFile:fullPath forKey:@"fileName01"];
    __weak typeof(requestx) request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            NSArray *json = [result JSONValue];
            if([json count]){
                NSArray *temp = [json[0] componentsSeparatedByString:@"/"];
                [tempself saveUploadFile:temp[1]];
            }else{
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
            [tempself hideActivityIndicator];
        }
        @finally {
        }
    }];
    [request setFailedBlock:^{
        [tempself hideActivityIndicator];
    }];
    [request startAsynchronous];
}
-(void) saveUploadFile:(NSString*) fileName{
    NSDictionary *json = [[NSMutableDictionary alloc]init];
    [json setValue:[[NSNumber alloc] initWithInt:0] forKey:@"status"];
    [json setValue:fileName forKey:@"attachName"];
    [json setValue:[NSString stringWithFormat:@"%@/%@",user.phoneNum,fileName] forKey:@"attachUrl"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/attachments" Params:json Logo:@"user_file_save"];
    __weak ASIFormDataRequest *request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *responseString = [request responseString];
            NSDictionary *json = [responseString JSONValue];
            if(!json){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"无效json数据" userInfo:nil];
            }
            NSString *docPath = [self getDocPath];
            if([[NSFileManager defaultManager] fileExistsAtPath:docPath]){
                [[NSFileManager defaultManager] removeItemAtPath:docPath error:NULL];
            }
            user.defaultPicUrl = [json valueForKey:@"attachUrl"];
            [self updateUser];
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(@"图片信息保存失败！");
            [tempself hideActivityIndicator];
        }
        @finally {
        }
    }];
    [request setFailedBlock:^{
        COMMON_SHOWALERT(@"图片信息保存失败！");
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
-(void) updateUser{
    [self clickCacheUser:nil];
    if(![NSString isEnabled:user.phoneNum]){
        COMMON_SHOWALERT(@"电话号码为空");
        return;
    }
    if(![NSString isEnabled:user.name]){
        COMMON_SHOWALERT(@"姓名为空!");
        return;
    }
    NSMutableDictionary *json = [ConfigManage getConfigCache:CMCK_ACCONTINFO ].JSONValue;
    if(!json){
        COMMON_SHOWALERT(@"无效用户信息!");
        return;
    }
    [json setValue:user.name forKey:@"name"];
    [json setValue:user.phoneNum forKey:@"phoneNum"];
    [json setValue:user.sex forKey:@"sex"];
    [json setValue:user.qq forKey:@"qq"];
    [json setValue:user.weixin forKey:@"weixin"];
    [json setValue:user.weibo forKey:@"weibo"];
    [json setValue:user.defaultPicUrl forKey:@"defaultPicUrl"];
    [json setValue:user.email forKey:@"email"];
    [json setValue:user.homeAddress forKey:@"homeAddress"];
    [json setValue:user.companyAddress forKey:@"companyAddress"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPUT:@"/user/user" Params:json Logo:@"putuser"];
    if(!requestx){
        return;
    }
    __weak typeof(requestx) request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            id json = [result JSONValue];
            if(!json){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            [ConfigManage clearCacheUser];
            
            if(fullPath){
                UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
                NSString *docPath =  [self getDocPath];
                NSData* imageDataX =UIImageJPEGRepresentation(image, 1.0f);
                [imageDataX writeToFile:docPath atomically:YES];
            }
            
            COMMON_SHOWALERT(@"操作成功!");
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
        }
        @finally {
            [tempself hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        [tempself hideActivityIndicator];
    }];
    [request startAsynchronous];
    [self showActivityIndicator];
}
- (IBAction)clickConfirm:(id)sender{
    [super showActivityIndicator];
    if(fullPath){
        [self uploadImage];
    }else{
        [self updateUser];
    }
}
- (IBAction)clickCacheUser:(id)sender {
    user.phoneNum =_lablePhone.text;
    user.name = _textFieldName.text;
    user.sex = _lableSex.text;
    user.qq = _textFieldQQ.text;
    user.weixin = _textFieldWx.text;
    user.weibo = _textFieldQB.text;
    user.email = _textFieldYX.text;
    user.homeAddress = _textFieldJTZZ.text;
    user.companyAddress = _textFieldGSDZ.text;
    [ConfigManage setCacheUser:user];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) toucheControll{
    [_textFieldName resignFirstResponder];
    [_textFieldQQ resignFirstResponder];
    [_textFieldWx resignFirstResponder];
    [_textFieldQB resignFirstResponder];
    [_textFieldYX resignFirstResponder];
    [_textFieldJTZZ resignFirstResponder];
    [_textFieldGSDZ resignFirstResponder];
}
-(void) xInputHidden:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    @synchronized(ysyn){
        __weak typeof(self) tempself = self;
        [UIView animateWithDuration:animationTime animations:^{
            tempself.scrollViewMain.scrollEnabled = YES;
            tempself.scrollViewMain.frame = CGRectMake(frameScrollView.origin.x, frameScrollView.origin.y, frameScrollView.size.width, frameScrollView.size.height);
        }];
        isHasShowKeyBoard = false;
    }
}
-(void) xInputShow:(NSNotification *)notification{
//    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"asdf");
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    float heightKeyBorad = 246.0f;
    float yOffset = _scrollViewMain.contentOffset.y;
    float yView = textField.frame.origin.y+textField.frame.size.height;
    if(textField.tag == randomTag+1){
    }else if(randomTag+2==textField.tag){
        yView += _view0102.frame.origin.y+_view01.frame.origin.y;
    }else if(textField.tag==randomTag+3){
        yView += _view0103.frame.origin.y+_view01.frame.origin.y;
    }else if(randomTag+4==textField.tag){
        yView += _view0201.frame.origin.y+_view02.frame.origin.y;
    }else if(randomTag+5==textField.tag){
        yView += _view0202.frame.origin.y+_view02.frame.origin.y;
    }else if(randomTag+6==textField.tag){
        yView += _view0301.frame.origin.y+_view03.frame.origin.y;
    }else if(randomTag+7==textField.tag){
        yView += _view0302.frame.origin.y+_view03.frame.origin.y;
    }
    @synchronized(ysyn){
        float tempy = heightKeyBorad-(COMMON_SCREEN_H-44-yView+yOffset);
        CGRect r = _scrollViewMain.frame;
        r.size = CGSizeMake(frameScrollView.size.width, COMMON_SCREEN_H-44-heightKeyBorad);
        _scrollViewMain.frame = r;
        if((COMMON_SCREEN_H-44-yView+yOffset)<heightKeyBorad){
            [_scrollViewMain setContentOffset:CGPointMake(0, tempy) animated:YES];
        }
        _scrollViewMain.scrollEnabled = YES;
        isHasShowKeyBoard = true;
    };
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (sheetIndex) {
        case 0:{
            switch (buttonIndex) {
                case 0: {
                    _lableSex.text = @"男";
                }
                    break;
                case 1: {
                    _lableSex.text = @"女";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
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
#pragma mark  相册
-(void)OpenAlunm{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];//创建
    picker.delegate = self;//设置为托
    picker.allowsEditing=YES;//允许编辑图片
    [self presentModalViewController:picker animated:YES];
}
#pragma mark ImagePickerControllerDelegate 确认选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *imageCache = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(writeImagFile:) object:imageCache];
        [t start];
        _imageHead.image = COMMON_CUTIMG(imageCache);
//        float w = COMMON_SCREEN_W;
//        float h = COMMON_SCREEN_H-44;
//        CGRect rx = _imageHead.frame;
//        rx.size.width = w;
//        rx.size.height = h;
//        _imageHead.frame = rx;
	}
	else
	{
		return;
	}
}
-(void) writeImagFile:(UIImage*) image{
    NSData *imageDatat = UIImageJPEGRepresentation(image, 1);
    // 获取沙盒目录
    fullPath = [[ConfigManage getTempDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",user.phoneNum]];
    // 将图片写入文件
    [imageDatat writeToFile:fullPath atomically:NO];
}

-(void) checkUser{
    if(user){
        _lablePhone.text = user.phoneNum;
        _textFieldName.text = user.name;
        _lableSex.text = [NSString isEnabled:user.sex]?user.sex:@"男";
        _textFieldQQ.text = user.qq;
        _textFieldWx.text = user.weixin;
        _textFieldQB.text = user.weibo;
        _textFieldYX.text = user.email;
        _textFieldJTZZ.text = user.homeAddress;
        _textFieldGSDZ.text = user.companyAddress;
        
        NSFileManager *f = [NSFileManager defaultManager];
        NSString *docPath = [self getDocPath];;
        if(![f fileExistsAtPath:docPath]){
            if([NSString isEnabled:user.defaultPicUrl]){
                [self setUserImage:COMMON_GET_IMAGE_URL(user.defaultPicUrl)];
            }
        }else{
            NSString *tempUrl = [ConfigManage getTempDirectory];
            NSArray *temp2 = [user.defaultPicUrl componentsSeparatedByString:@"/"];
            NSString *fileName2 = temp2[[temp2 count]-1];
            temp2 = [fileName2 componentsSeparatedByString:@"."];
            fileName2 = [NSString stringWithFormat:@"%@-320.%@",temp2[0],temp2[1]];
            NSString *tempPath = [NSString stringWithFormat:@"%@/%@",tempUrl,fileName2];
            if(![f fileExistsAtPath:tempPath]){
                UIImage *image01 = [UIImage imageWithContentsOfFile:docPath];
                image01 = COMMON_CUTIMG(image01);
                NSData *imageData01 = UIImageJPEGRepresentation(image01, 1);
                [imageData01 writeToFile:tempPath atomically:TRUE];
            }
            _imageHead.image = [UIImage imageWithContentsOfFile:tempPath];
        }
    }
}
-(void) setUserImage:(NSString*) imageUrl{
	NSURL *url = [NSURL URLWithString:imageUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    if(connection){
        [connection cancel];
    }
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    finished = NO;
    while (!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    @synchronized(sync){
        if (!imageData) imageData = [NSMutableData data];
        [imageData appendData:incrementalData];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    finished = YES;
    NSString *docUrl = [ConfigManage getDocumentsDirectory];
    NSArray *tempArray = [user.defaultPicUrl componentsSeparatedByString:@"/"];
    NSString *fileName = tempArray[[tempArray count]-1];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docUrl,fileName];
    [imageData writeToFile:filePath atomically:TRUE];
    
    NSString *tempPath;
    UIImage *image = COMMON_CUTIMG([[UIImage alloc]initWithData:imageData]);
    NSData *imageData01 = UIImageJPEGRepresentation(image, 1);
    NSArray *temp2 = [fileName componentsSeparatedByString:@"."];
    fileName = [NSString stringWithFormat:@"%@-320.%@",temp2[0],temp2[1]];
    tempPath = [[[ConfigManage getTempDirectory] stringByAppendingString:@"/"]
                stringByAppendingString:fileName];
    [imageData01 writeToFile:tempPath atomically:TRUE];
    _imageHead.image = [UIImage imageWithData:imageData01];
	imageData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    finished = YES;
}
-(NSString*) getDocPath{
    if(![NSString isEnabled:user.defaultPicUrl]){
        return @"";
    }
    NSString *docUrl = [ConfigManage getDocumentsDirectory];
    NSArray *tempArray = [user.defaultPicUrl componentsSeparatedByString:@"/"];
    NSString *fileName = tempArray[[tempArray count]-1];
    return [NSString stringWithFormat:@"%@/%@",docUrl,fileName];
}
-(void) setUserx:(ModleUser*) userx{
    user = userx;
}
- (void)didReceiveMemoryWarning
{
    [connection cancel];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
