//
//  NotesAddViewController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-7.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NotesAddViewController.h"
#import "NSDate+convenience.h"
#import "ConfigManage.h"
#import "ASIFormDataRequest.h"
#import "Common.h"
#import "NSDate+convenience.h"
#import "HttpApiCall.h"
#import "CLLocationManagerImpl.h"
#import "GTMBase64.h"
#import "NotesImageViewController.h"
#import "UIImage+Convenience.h"

@interface NotesAddViewController ()
@property (retain, nonatomic) IBOutlet UILabel *lableUserName;
@property (retain, nonatomic) IBOutlet UILabel *lableUploadTime;
@property float ory;
@property bool flag;
@property bool flag2;
@property bool flag3;
@property bool flag4;

@property long long currentDateInt;
@property int currentAddInt;
@property int currentAddInt2;
@property int currentCommitInt;
@property NSMutableArray *imageViews;

@property NSDate *touchTimes;
@property int alertViewUseIndex;
@property int alertVIewUseImageTag;
@property NSMutableArray *imageIds;

@property bool  ifdeletePic;//长按删除图片的标识符

@property NSLock *lock;
@end

@implementation NotesAddViewController

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
    //==>初始化数据
    self.lock = [[NSLock alloc]init];
    self.imageIds = [[NSMutableArray alloc]init];
    self.srcollViewmain.contentSize = self.srcollViewmain.frame.size;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll:)];
    [self.srcollViewmain addGestureRecognizer:tapGesture];
    self.srcollViewmain.delegate = self;
    self.viewAddress.backgroundColor = [UIColor colorWithRed:0.953 green:0.980 blue:0.937 alpha:1];
    self.viewAddImage.backgroundColor = [UIColor colorWithRed:0.965 green:0.973 blue:0.980 alpha:1];
    NSDate *d = [NSDate new];
    NSString *uploadTime = [NSString stringWithFormat:@"%d月%d日",d.month,d.day];
    self.lableUserName.text = [self.jsonData objectForKey:@"fullName"];;
    self.lableUploadTime.text = uploadTime;
    self.currentDateInt = [[NSDate dateFormateDate:d FormatePattern:@"yyyyMMddHHmmss"] longLongValue];
    self.srcollViewmain.showsVerticalScrollIndicator = false;
    self.srcollViewmain.showsHorizontalScrollIndicator = false;
    self.textViewIntroduce.delegate = self;
    //<==
    //==>初始化图像
    [self cornerRadius:self.viewAddImage];
    [self cornerRadius:self.viewAddress];
    [self cornerRadius:self.viewHead];
    [self cornerRadius:self.textViewIntroduce];
    //<==
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self loadMap];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void) loadMap{
    self.flag2 = NO;
    CLLocationManagerImpl *cmi = [CLLocationManagerImpl getInstance];
    [cmi setTargets:self];
    [cmi setTargetMethods:^id(id key, ...) {
        va_list arglist;
        va_start(arglist, key);
        NotesAddViewController *vc = key;
        CLLocationManager *manager = va_arg(arglist, CLLocationManager*);
        CLLocation *newLocation = va_arg(arglist, CLLocation*);
        CLLocation *oldLocation = va_arg(arglist, CLLocation*);
        va_end(arglist);
        [vc locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        return  false;
    }];
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLLocationCoordinate2D lc2D = newLocation.coordinate;
    self.mapX = lc2D.longitude;
    self.mapY = lc2D.latitude;
    NSString *tempURL = [NSString stringWithFormat:@"http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=%f&y=%f",self.mapX,self.mapY];
    NSURL *url = [NSURL URLWithString:tempURL] ;
    ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *request = requestx;
    [request setRequestMethod:@"GET"];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        @try {
            NSDictionary *json = [responseString JSONValueNewMy];
            NSString *x = [json objectForKey:@"x"];
            NSString *y = [json objectForKey:@"y"];
            NSData * data =  [GTMBase64 decodeString:x];
            x =  [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            data  = [GTMBase64 decodeString:y];
            y =[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSString *mapURL = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%@,%@&width=%d&height=%d&zoom=%d&markers=%@,%@&lable=%@",x,y,(int)self.imageMap.frame.size.width*2,(int)self.imageMap.frame.size.height*2,19,x,y,@"sdfsdf"];
            NSString *mapURL2 = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?location=%@,%@&output=json&ak=%@",y,x,BAIDU_AK];
            NSURL *url = [NSURL URLWithString:mapURL2] ;
            __weak ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:url];
            
            [requestx setRequestMethod:@"GET"];
            [request setTimeOutSeconds:60];
            [requestx setResponseEncoding:NSUTF8StringEncoding];
            [requestx setCompletionBlock:^{
                [requestx setResponseEncoding:NSUTF8StringEncoding];
                NSString *responseString = [requestx responseString];
                @try {
                    NSDictionary *json = [responseString JSONValueNewMy];
                    self.lableMap.text = [([(NSDictionary*)json objectForKey:@"result"]) objectForKey:@"formatted_address"];
//                    self.imageMap.ifshowErroAlert = YES;
                    self.imageMap.isIgnoreCacheFile = YES;
                    self.imageMap.imageUrl= mapURL;//[UIImage imageWithData:[NSData dataWithContentsOfURL:u]];
                }
                
                @catch (NSException *exception) {
                    self.lableMap.text = @"百度地图无法得到你的位置名称";
                    self.flag2 = NO;
                }
            }];
            
            [requestx setFailedBlock:^{
                self.lableMap.text = @"百度地图无法得到你的位置名称";
                self.flag2 = NO;
            }];
            [requestx startAsynchronous];
        }
        @catch (NSException *exception) {
            self.lableMap.text = @"百度地图无法得到你的位置名称";
            self.flag2 = NO;
        }
    }];
    
    [request setFailedBlock:^{
        self.lableMap.text = @"百度地图无法得到你的位置名称";
        self.flag2 = NO;
    }];
    [request startAsynchronous];
}
// 当scroll view 滚动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 [self.textViewIntroduce resignFirstResponder];
}
- (IBAction)toucheControll:(id)sender {
    if(self.flag){self.flag3 = YES;}
    [self.textViewIntroduce resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) cornerRadius:(UIView*) tvt{
    tvt.layer.cornerRadius = 5;
    tvt.layer.masksToBounds = YES;
    tvt.layer.borderWidth = 0.5;
    tvt.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}

-(void)intputshow:(NSNotification *)notification{
    if(self.flag){
        return;
    }
    self.flag = true;
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect r = self.viewLocations.frame;
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if(self.ory == 0) self.ory = r.origin.y;
        if(keyBoardFrame.origin.y<self.textViewIntroduce.frame.origin.y+self.textViewIntroduce.frame.size.height+42+60){
            r.origin.y = keyBoardFrame.origin.y-self.textViewIntroduce.frame.origin.y-self.textViewIntroduce.frame.size.height-42-60;
            self.viewLocations.frame = r;
        }
    }];
}

-(void)intputhide:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect r = self.viewLocations.frame;
        r.origin.y = self.ory;
        self.viewLocations.frame = r;
        self.flag = false;
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(IOS7_OR_LATER)
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    else
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark  照相
- (IBAction)addPicture:(id)sender {
    if(self.flag){
        [self.textViewIntroduce resignFirstResponder];
        return;
    }
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
        UIImage *image = [UIImage imageNamed:@"test_imgae.png"];
        [self imagePickerController:image];
        showMessageBox(@"照相机不存在");
		return;
	}
	[self presentModalViewController:camera animated:YES];
}

#pragma mark ImagePickerControllerDelegate 确认选择图片并上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self imagePickerController:image];
	}
	else
	{
		return;
	}
}
//这样做主要是为了方便测试
- (void)imagePickerController:(UIImage*) image
{
    [self addPhotoImage:image];
    UIImageView *iv = (UIImageView*)[self.viewAddImage viewWithTag:66501+self.currentAddInt];
    UIButton *b = (UIButton*)[self.viewAddImage viewWithTag:66511+self.currentAddInt];
    [b addTarget:self action:@selector(toucheDown:) forControlEvents:UIControlEventTouchDown];
    [b addTarget:self action:@selector(toucheUpInside:) forControlEvents:UIControlEventTouchUpInside];
    iv.image = image;
    id temp = [self.viewAddImage viewWithTag:66501+self.currentAddInt+1];
    if(temp){
        self.buttonUpload.frame =  ((UIImageView*)temp).frame;
    }else{
        CGRect r = self.buttonUpload.frame;
        r.origin.x = 320;
        self.buttonUpload.frame = r;
    }
    ++self.currentAddInt;
    [self.lableTag1 setHidden:YES];
}

-(void) deletePic:(NSArray*) array{
    for (int i=0; i<1.8; i++) {
        [NSThread sleepForTimeInterval:0.1f];
        if(!self.ifdeletePic){
            return;
        }
    }
    int index = ((UIButton*)(array[0])).tag-(((UIButton*)(array[0])).tag/10)*10;
    if(index-1>[self.imageViews count]){
        return;
    }
    self.alertViewUseIndex = index;
    self.alertVIewUseImageTag = ((UIButton*)(array[0])).tag - 10;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"是否删除图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"删除",nil];
    [actionSheet showInView:self.view];
//    [self deletePhotes:self.alertViewUseIndex ImageTag:self.alertVIewUseImageTag];
//    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除图片吗？" delegate:((NotesAddViewController*)(array[1])) cancelButtonTitle:@"是" otherButtonTitles:@"否",nil]show];
    self.ifdeletePic = NO;
}
-(void) toucheDown:(UIButton*) b{
    self.ifdeletePic = YES;
    self.touchTimes = [NSDate new];
    NSThread *t = [[NSThread alloc]initWithTarget:self selector:@selector(deletePic:) object:[[NSArray alloc] initWithObjects:b,self, nil]];
    [t start];
}
-(void) toucheUpInside:(UIButton*) b{
    if(self.flag3){
        self.flag3 = NO;
        return;
    }
    double x =[self.touchTimes timeIntervalSinceNow];
    int index = b.tag-(b.tag/10)*10;
    if(x>-1){
        self.ifdeletePic = NO;
        [self viewPhotes:index-1];
    }else if(x>-2){
        self.ifdeletePic = NO;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self deletePhotes:self.alertViewUseIndex ImageTag:self.alertVIewUseImageTag];
            break;
            
        default:
            break;
    }
}
-(void) deletePhotes:(int) index ImageTag:(int) imageTag{
    UIImageView *temp = (UIImageView*)[self.viewAddImage viewWithTag:imageTag];
    [self.imageViews removeObjectAtIndex:index-1];
    temp.image = NO;
    UIImageView *tempNext;
    for(int i=index+1;i<=4;i++){
        tempNext = (UIImageView*)[self.viewAddImage viewWithTag:temp.tag+1];
        if(!tempNext){
            tempNext = (UIImageView*)[self.viewAddImage viewWithTag:temp.tag-1];
            break;
        }
        if(!tempNext.image){
            temp.image = tempNext.image;
            tempNext = temp;
            break;
        }
        temp.image = tempNext.image;
        temp = tempNext;
    }
    if(tempNext){
        tempNext.image = NO;
        UIButton *bNexst = (UIButton*)[self.viewAddImage viewWithTag:tempNext.tag+10];
        [bNexst removeTarget:self action:@selector(toucheDown:) forControlEvents:UIControlEventTouchDown];
        self.buttonUpload.frame = tempNext.frame;
    }else{
        UIButton *bNexst = (UIButton*)[self.viewAddImage viewWithTag:temp.tag+10];
        [bNexst removeTarget:self action:@selector(toucheDown:) forControlEvents:UIControlEventTouchDown];
        self.buttonUpload.frame = temp.frame;
    }
    --self.currentAddInt;

}
-(void) viewPhotes:(int) index{
    [self toucheControll:nil];
    NotesImageViewController *l = [[NotesImageViewController alloc]initWithNibName:@"NotesImageViewController" bundle:nil];
    NSMutableDictionary *jsonData = [[NSMutableDictionary alloc]init];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for(NSArray *temp2 in self.imageViews){
        NSDictionary *json = [[NSMutableDictionary alloc]init];
        [json setValue:temp2[0] forKey:@"imageView"];
        [temp addObject:json];
    }
    [jsonData setValue:temp forKey:@"data"];
    [l setJsonData:jsonData];
    [l setCurrentIndexJsonData:index];
    l.lableTitle.text = @"图片查看";
    [self.navigationController pushViewController:l animated:YES];
}
-(void) addPhotoImage:(UIImage*) imagetView{
    if(!self.imageViews){
        self.imageViews = [[NSMutableArray alloc]init];
    }
//    UIImage *i = [imagetView cutImageCenter:CGSizeMake(200, 300)];
//    
//    NSString *tt = [ConfigManage saveJPEGImageForUpdate:i FileName:@"adsfadsf.jpg"];
//    NSLog(tt);
    CGSize rx = imagetView.size;
    CGSize r = [[UIScreen mainScreen] applicationFrame].size;
    if(rx.width>r.width){
        r.height = rx.height*r.width/rx.width;
    }else if(rx.height>r.height){
        r.width = r.height/rx.height*rx.width;
    }else{
        r = rx;
    }
    r.width *=2;
    r.height *=2;
    imagetView = [imagetView setImageSize:r];
    self.currentAddInt2++;
    NSData *imageData = UIImageJPEGRepresentation(imagetView, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"notesPhotos%d",self.currentAddInt2]]];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    [self.imageViews addObject:[[NSArray alloc]initWithObjects:[UIImage imageWithContentsOfFile:fullPath],fullPath,nil ]];
}
-(void) saveUploadFile:(NSString*) fileName{
    NSDictionary *json = [[NSMutableDictionary alloc]init];
    [json setValue:fileName forKey:@"attachName"];
    [json setValue:[NSString stringWithFormat:@"%@/%@",[ConfigManage getLoginUser].userId,fileName] forKey:@"attachUrl"];
   ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/attachments" Params:json Logo:@"notes_file_save"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *responseString = [request responseString];
            NSNumber *_id = [[responseString JSONValueNewMy] objectForKey:@"id"];
            [self.imageIds addObject:_id];
            [self plusCurrentCommit];
        }
        @catch (NSException *exception) {
            showMessageBox(@"图片信息保存失败！");
            [self hideActivityIndicator];
        }
        @finally {
        }

    }];
    [request setFailedBlock:^{
        showMessageBox(@"图片信息保存失败！");
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
- (void)updateToServer{
    
    NSString *urlStr=@"/upload";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallUpload:urlStr Params:nil Logo:@"notes_image_upload" OutTime:30];
    __weak ASIFormDataRequest *request = requestx;
    int i = 0;
    NSString *fullpaths;
    NSFileManager *f = [NSFileManager defaultManager];
    for(NSArray *temp1 in self.imageViews){
        ++i;
        fullpaths = temp1[1];
        NSString *fullpath = temp1[1];
        NSString *key = [NSString stringWithFormat:@"fileName%d",i];
        if(![f fileExistsAtPath:fullpath]){
            @throw [[NSException alloc]initWithName:@"文件读取错误" reason:@"上传的文件不存在！" userInfo:nil];
        }
        [request setFile:fullpath forKey:key];
    }
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        if(responseString){
            @try {
                NSArray *temp2 = [responseString JSONValueNewMy];
                for (NSString *temp3 in temp2) {
                    NSString *temp4 = [temp3 componentsSeparatedByString:@"/"][1];
                    [self saveUploadFile:temp4];
                };
            }
            @catch (NSException *exception) {
                showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
                [self hideActivityIndicator];
            }
        }
    }];
    [request setFailedBlock:^{
        showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
//每上传一个文件就加一 直到上传成功的文件数等于添加数
- (void) plusCurrentCommit{
    @try {
        [self.lock lock];
        self.currentCommitInt++;
        if(self.currentCommitInt==self.currentAddInt){
            NSString *checkTime = [NSDate dateFormateDate:[NSDate new] FormatePattern:nil];
            NSString *checkIntroduce = self.textViewIntroduce.text;
            NSString *checkLocation = self.lableMap.text;
            NSNumber *organizationID = [self.jsonData objectForKey:@"id"];
            NSString *attamentsIds =@",";
            for(NSNumber *_id in self.imageIds){
                attamentsIds = [[attamentsIds stringByAppendingString:[_id stringValue]]stringByAppendingString:@","];
            }
            
            NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
            [json setValue:checkTime forKey:@"checkTime"];
            [json setValue:attamentsIds forKey:@"attamentsIds"];
            [json setValue:checkIntroduce forKey:@"checkContents"];
            [json setValue:checkLocation forKey:@"checkLocation"];
            [json setValue:[@"{\"id\":77}" JSONValueNewMy] forKey:@"checkType"];
            [json setValue:[[NSString stringWithFormat:@"{\"id\":%@}",organizationID] JSONValueNewMy] forKey:@"organization"];
            [json setValue:[[NSString stringWithFormat:@"{\"id\":%lli}",[ConfigManage getLoginUser].userkey] JSONValueNewMy]  forKey:@"toUser"];
            ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/attendances" Params:json Logo:@"notes_add"];
            __weak ASIFormDataRequest *request = requestx;
            [request setCompletionBlock:^{
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *responseString = [request responseString];
                @try {
                    NSDictionary *temp = [responseString JSONValueNewMy];
                    if(temp){
                    }
                }
                @catch (NSException *exception) {
                }
                @finally {
                    [self hideActivityIndicator];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            [request setFailedBlock:^{
                showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
            }];
            [self showActivityIndicator];
            [request startAsynchronous];
            [self.imageIds removeAllObjects];
            [self hideActivityIndicator];
        }
    }
    @finally {
        [self.lock unlock];
    }
}
//提交数据
- (IBAction)commitInfo:(id)sender {
    NSString *checkIntroduce = self.textViewIntroduce.text;
    if(!checkIntroduce||checkIntroduce==nil||[@"" isEqual:checkIntroduce]){
        showMessageBox(@"请输入巡店内容！");
        return;
    }
    if([self.imageViews count]==0){
        showMessageBox(@"请先拍照！");
        return;
    }
    [self showActivityIndicator];
    self.currentCommitInt = 0;
    [self updateToServer];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(self.flag4){
        return YES;
    }
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
    self.flag4 = YES;
    return YES;
}
- (IBAction)cleckReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
