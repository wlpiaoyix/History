//
//  UICommitFlowManager.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UICommitFlowManager.h"
#import "UIContextsFlow.h"
#import "ModleCheckBox.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "BaseViewController.h"
#import "FlowPhotoViewController.h"
#import "EMAsyncImageView.h"
@interface UICommitFlowManager(){
@private
    UIColor *colorViewTitle;
    NSDictionary *jsonData;
    CGRect rect00;
    CGRect rect01;
    CGRect rect02;
    CGRect rect03;
    CGRect rect04;
    CGRect rectbt;
    CGRect rectTemp;
    
    __weak id targetx;
    SEL actionx;
    __weak UIViewController *controller;
    bool flagHiddenBt;
    NSMutableArray *selectModle;
    NSMutableArray *selectModle2;
    NSMutableArray *selectModlex;
    NSMutableArray *selectModlex2;
    bool i;
    id syn01;
    NSString *currentPhone;
    UIImage *currentImage;
}
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIView *view02;
@property (strong, nonatomic) IBOutlet UIView *view03;
@property (strong, nonatomic) IBOutlet UIView *view04;

@property (strong, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (strong, nonatomic) IBOutlet UIButton *buttonQuery;

@property (strong, nonatomic) IBOutlet UIView *view02Title;
@property (strong, nonatomic) IBOutlet UIView *view02Context;

@property (strong, nonatomic) IBOutlet UIView *view03Title;
@property (strong, nonatomic) IBOutlet UIView *view03Context;

@property (strong, nonatomic) IBOutlet UIView *view04Title;
@property (strong, nonatomic) IBOutlet UIView *view04Context;
@property (strong, nonatomic) IBOutlet UIButton *buttonAddPhoto;

@property (strong, nonatomic) IBOutlet UIButton *buttonCommit;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonPhoneView;

@property (strong, nonatomic) IBOutlet UIView *viewPhone;
@property (strong, nonatomic) IBOutlet UILabel *lablePhone;
@property (strong, nonatomic) IBOutlet UILabel *lableJH;

@end
@implementation UICommitFlowManager
+(id) getNewInstance{
    UICommitFlowManager *cfm = [[[NSBundle mainBundle] loadNibNamed:@"UICommitFlowManager" owner:self options:nil] lastObject];
    
    cfm->colorViewTitle = [UIColor colorWithRed:0.988 green:1.000 blue:0.957 alpha:1];
    cfm->rect00= cfm.frame;
    cfm->rect01 = cfm.view01.frame;
    cfm->rect02 = cfm.view02.frame;
    cfm->rect03 = cfm.view03.frame;
    cfm->rect04 = cfm.view04.frame;
    cfm->rectbt = cfm.buttonCommit.frame;
    cfm->selectModle = [NSMutableArray new];
    cfm->selectModle2 = [NSMutableArray new];
    cfm->selectModlex = [NSMutableArray new];
    cfm->selectModlex2 = [NSMutableArray new];
    cfm.scrollEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:cfm action:@selector(toucheControll)];
    [cfm addGestureRecognizer:tapGesture];
    
    __weak typeof(cfm) tempcfm = cfm;
    cfm.delegate = tempcfm;
    cfm.showsHorizontalScrollIndicator = NO;
    cfm.showsVerticalScrollIndicator = NO;
    
    [cfm.lableJH setHidden:YES];
    [cfm.buttonAddPhoto setHidden:NO];
    [cfm.buttonAddPhoto setEnabled:NO];
    return cfm;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    @synchronized(syn01){
        if(i){
            [super willMoveToSuperview:newSuperview];
            return;
        }
        i = true;
    }
    _view02Title.backgroundColor = colorViewTitle;
    _view03Title.backgroundColor = colorViewTitle;
    _view04Title.backgroundColor = colorViewTitle;
    self.frame = rectTemp;
    [_buttonCommit addTarget:self action:@selector(clickCommit:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonAddPhoto addTarget:self action:@selector(clickAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonQuery addTarget:self action:@selector(reloadDatax:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonPhoneView addTarget:self action:@selector(clickPhontoView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonCommit setHidden:self->flagHiddenBt];
    [_buttonAddPhoto setHidden:self->flagHiddenBt];
    [_buttonAddPhoto setEnabled:NO];
    [_viewPhone setHidden:!self->flagHiddenBt];
    [super willMoveToSuperview:newSuperview];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setButtonTargetHidden:(bool) flag{
    self->flagHiddenBt = flag;
}
-(void) excuViewThread{
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(excuView) object:nil];
    [t start];
}
-(void) checkPic{
    NSArray *datax01;
    NSArray *datax02;
    if([jsonData isKindOfClass:[NSArray class]]){
        datax01 = [NSArray new];
        datax02 =  [NSArray new];
    }else{
        datax01 = [jsonData objectForKey:@"trafficPack"];
        datax02 =  [jsonData objectForKey:@"trafficApp"];
    }
    NSMutableArray *allTypes = [NSMutableArray new];
    [allTypes addObjectsFromArray:datax01];
    [allTypes addObjectsFromArray:datax02];
    NSMutableArray *allBoxes = [NSMutableArray new];
    for (ModleCheckType *mct in allTypes) {
        [allBoxes addObjectsFromArray:mct.boxes];
    }
    [allTypes removeAllObjects];
    [_lableJH setHidden:YES];
    [_buttonAddPhoto setHidden:NO];
    [_buttonAddPhoto setEnabled:NO];
    for (ModleCheckBox *box in allBoxes) {
        if(box.isReported&&box.key==14){
            [_lableJH setHidden:NO];
            [_buttonAddPhoto setHidden:YES];
            break;
        }
    }
    if ([allBoxes count]) {
        [_buttonAddPhoto setEnabled:YES];
    }
    
}
-(CGSize) excuView{
    [self checkPic];
    NSArray *datax01;
    NSArray *datax02;
    if([jsonData isKindOfClass:[NSArray class]]){
        datax01 = [NSArray new];
        datax02 =  [NSArray new];
    }else{
        datax01 = [jsonData objectForKey:@"trafficPack"];
        datax02 =  [jsonData objectForKey:@"trafficApp"];
    }
    int offset = 0;
    NSArray *viewArray = _view02Context.subviews;
    for (UIView *view in viewArray) {
        [view removeFromSuperview];
    }
    viewArray = _view03Context.subviews;
    for (UIView *view in viewArray) {
        [view removeFromSuperview];
    };
    CGRect rx = CGRectMake(rect02.origin.x, rect02.origin.y, rect02.size.width, rect02.size.height);
    _view02.frame = rx;
    if(datax01&&[datax01  count]){
         UIContextsFlow *cvc = [UIContextsFlow getNewInstance];
        [cvc setDatas:datax01];
        [cvc addEventTouchUp:self action:@selector(clickFlowPage:)];
        [cvc setButtonTargetHidden:self->flagHiddenBt];
       CGSize s = [cvc excuView];
        [_view02Context addSubview:cvc];
        CGRect r = _view02Context.frame;
        r.size = s;
        _view02Context.frame = r;
        offset = s.height;
        
        r = _view02.frame;
        r.size.height = rect02.size.height+s.height;
        _view02.frame = r;
    }
    rx = _view03.frame;
    rx.origin.y = rect03.origin.y+offset;
    rx.size = CGSizeMake(rect03.size.width, rect03.size.height);
    _view03.frame = rx;
    if(datax02&&[datax02 count]){
        UIContextsFlow *cvc = [UIContextsFlow getNewInstance];
        [cvc setDatas:datax02];
        [cvc setButtonTargetHidden:self->flagHiddenBt];
        [cvc addEventTouchUp:self action:@selector(clickFlowManager:)];
        CGSize s = [cvc excuView];
        [_view03Context addSubview:cvc];
        CGRect r = _view03Context.frame;
        r.size = s;
        _view03Context.frame = r;
        offset += s.height;
        r = _view03.frame;
        r.size.height = rect03.size.height+s.height;
        _view03.frame = r;
    }
    rx = self.frame;
    rx.size.height = rect00.size.height+offset;
    if(flagHiddenBt){
        rx.size.height -= 57;
    }
    self.contentSize = rx.size;
    rx.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    rectTemp = rx;
    
    rx = _view04.frame;
    rx.origin.y = rect04.origin.y+offset;
    _view04.frame = rx;
    
    rx = _buttonCommit.frame;
    rx.origin.y = rectbt.origin.y+offset;
    _buttonCommit.frame = rx;
    //==>
    [self setCornerRadiusAndBorder:_view01];
    [self setCornerRadiusAndBorder:_view02];
    [self setCornerRadiusAndBorder:_view03];
    [self setCornerRadiusAndBorder:_view02Title];
    [self setCornerRadiusAndBorder:_view03Title];
    //<==
    
    return rectTemp.size;
}
-(void) clickFlowPage:(ModleCheckBox*) cb{
    if(cb.isSelected){
        [selectModle addObject:cb];
        [selectModlex removeObject:cb];
    }else{
        [selectModle removeObject:cb];
        [selectModlex addObject:cb];
    }
}
-(void) clickFlowManager:(ModleCheckBox*) cb{
    if(cb.isSelected){
        [selectModle2 addObject:cb];
        [selectModlex2 removeObject:cb];
    }else{
        [selectModle2 removeObject:cb];
        [selectModlex2 addObject:cb];

    }
}
-(BOOL) toucheControll{
   return [_textFieldPhone resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self toucheControll];
}
-(void) setFrame:(CGRect)frame{
    rectTemp = frame;
    [super setFrame:frame];
}
-(void) addCommitEvent:(id)target Action:(SEL) action{
    targetx = target;
    actionx = action;
}
-(void) setController:(UIViewController*) vc{
    self->controller = vc;
}
-(void) clickCommit:(id) sender{
    NSArray *datas = [jsonData objectForKey:@"trafficPack"];
    for (ModleCheckType *types in datas) {
        for (ModleCheckBox *box in types.boxes) {
            if (box.isSelfReported) {
                [selectModle addObject:box];
            }
        }
    }
    datas = [jsonData objectForKey:@"trafficApp"];
    for (ModleCheckType *types in datas) {
        for (ModleCheckBox *box in types.boxes) {
            if (box.isSelfReported) {
                [selectModle2 addObject:box];
            }
        }
    }
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    for (ModleCheckBox *box in selectModlex2) {
        if (box.isSelfReported) {
            [selectModle2 removeObject:box];
        }
    }
    for (ModleCheckBox *box in selectModlex) {
        if (box.isSelfReported) {
            [selectModle removeObject:box];
        }
    }
    if(!([selectModle count]||[selectModle2 count])){
        showMessageBox(@"请选择数据!");
        return;
    }
    if(!currentImage){
        [self saveData:nil];
    }else{
        [self uploadFile];
    }
}
-(void) clickAddPhoto:(id) sender{
    [self startCamera];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"添加照片"
//                                  delegate:self
//                                  cancelButtonTitle: @"取消"
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"相机",@"相册",nil];
//    [actionSheet showInView:self];
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
        showMessageBox(@"照相机不存在");
		return;
	}
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:camera animated:YES];
	[self->controller presentModalViewController:camera animated:YES];
}
#pragma mark  相册
-(void)OpenAlunm{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];//创建
    picker.delegate = self;//设置为托
    picker.allowsEditing=YES;//允许编辑图片
    [self->controller  presentModalViewController:picker animated:YES];
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
        _imagePhoto.image = imageCache;
        currentImage = imageCache;
	}
	else
	{
		return;
	}
}
-(void)setCornerRadiusAndBorder:(UIView *)view{
    view.layer.cornerRadius = 5;
    //    view.layer.borderWidth = 0.5;
    //    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
-(void) reloadDatax:(id) sender{
    [self toucheControll];
    _imagePhoto.image = nil;
    currentImage = nil;
    currentPhone = _textFieldPhone.text;
    if(![NSString isEnabled:currentPhone]){
        return;
    }
    if(currentPhone.length!=11){
        showMessageBox(@"请输入正确的手机号!");
        return;
    }
    NSString *url = [NSString stringWithFormat:@"/api/traffic/reportmonth/%@",currentPhone];
    ASIFormDataRequest *reqeustx = [HttpApiCall requestCallGET:url Params:nil Logo:@"gettrafficreportmonth"];
    __weak typeof(reqeustx) request = reqeustx;
    __weak typeof(self) tempself = self;
    _textForReportStr.text= @"*";
    _textForReportStr0.text= @"";
    _textForReportStr1.text= @"";
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *jsonDatas = [reArg JSONValueNewMy];
            if(!jsonDatas){
                @throw [[NSException alloc] initWithName:@"无数据" reason:@"网络没有返回数据" userInfo:nil];
            }
           
            jsonData = [jsonDatas objectForKey:@"data"];
            if(!jsonData||![jsonData count]){
                return ;
            }
            
            jsonData = ((NSArray*)jsonData)[0];
            
            NSArray * tite = [jsonData valueForKey:@"history"];
            
            NSString * strForTite = @"*";
            int its = 0 ;
            for (NSString * str in tite) {
                if (its==0) {
                    _textForReportStr.text = [strForTite stringByAppendingString:str];
                }
                if (its==1) {
                    _textForReportStr0.text =[strForTite stringByAppendingString:str];
                }
                if (its==2) {
                    _textForReportStr1.text =[strForTite stringByAppendingString:str];
                }
               its++;
            }
            
            NSDictionary *trafficPack = [jsonData valueForKey:@"trafficPack"];
            NSArray *tempay =  [ModleCheckType initWithJSON:trafficPack];
            [jsonData setValue:tempay forKey:@"trafficPack"];
            NSArray *trafficApp = [jsonData valueForKey:@"trafficApp"];
            NSMutableArray *tempmyx = [NSMutableArray new];
            ModleCheckType *mct = [ModleCheckType new];
            for (id jsonx in trafficApp) {
                NSDictionary *tempx;
                if([jsonx isKindOfClass:[NSArray class]]){
                    if(![((NSArray*)jsonx) count]){
                        continue;
                    }
                    tempx = ((NSArray*)jsonx)[0];
                }else{
                    tempx = jsonx;
                }
                ModleCheckBox *mcb = [ModleCheckBox initWithJSON:tempx];
                [tempmyx addObject:mcb];
            }
            mct.boxes = tempmyx;
            tempay = [[NSArray alloc] initWithObjects:mct, nil];
            [jsonData setValue:tempay forKey:@"trafficApp"];
            NSString *imageUrl = [[jsonData objectForKey:@"firstDayActive"] objectForKey:@"firstDayActiveUrl"];
            if([NSString isEnabled:imageUrl]){
                imageUrl = [NSString stringWithFormat:@"/images/%@",imageUrl];
                imageUrl = API_FILE_URL(imageUrl);
                _imagePhoto.imageUrl = imageUrl;
            }
//            long long int productId =  ((NSNumber*)[[jsonData objectForKey:@"firstDayActive"] objectForKey:@"productId"]).longLongValue;
        }
        @catch (NSException *exception) {
            showMessageBox(exception.reason);
        }
        @finally {
            [tempself  excuView];
            [((BaseViewController*)self->controller) hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        [((BaseViewController*)self->controller) hideActivityIndicator];
    }];
    [((BaseViewController*)self->controller) showActivityIndicator];
    [request startAsynchronous];
}
-(void) saveData:(NSNumber*) firstActiveAttachmentId{
    NSString *phoneNum = currentPhone;
    NSString *productIds = @",";
    for (ModleCheckBox *mcb in selectModle) {
        productIds = [productIds stringByAppendingFormat:@"%lli,",mcb.key];
    }
    for (ModleCheckBox *mcb in selectModle2) {
       productIds =  [productIds stringByAppendingFormat:@"%lli,",mcb.key];
    }
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setObject:phoneNum forKey:@"phoneNum"];
    if(firstActiveAttachmentId){
        long long int productId =  ((NSNumber*)[[jsonData objectForKey:@"firstDayActive"] objectForKey:@"productId"]).longLongValue;
        productIds =  [productIds stringByAppendingFormat:@"%lli,",productId];
        [json setObject:firstActiveAttachmentId forKey:@"firstActiveAttachmentId"];
    }
    [json setObject:productIds forKey:@"productIds"];
    ASIFormDataRequest *requestx= [HttpApiCall requestCallPOST:@"/api/traffic" Params:json Logo:@"posttrafficreport"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        @try {
            NSDictionary *json = [responseString JSONValueNewMy];
            if(!json){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"网络无返回值!" userInfo:nil];
            }
            if([@"failure" isEqual:[json objectForKey:@"status"]]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有激活或数据" userInfo:nil];
            }
            if(actionx&&targetx){
                [targetx performSelector:actionx];
            }
        }
        @catch (NSException *exception) {
            showMessageBox(exception.reason);
        }
        @finally {
            [((BaseViewController*)self->controller) hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        showMessageBox(@"网络无反应!");
        [((BaseViewController*)self->controller) hideActivityIndicator];
        if(actionx&&targetx){
            [targetx performSelector:actionx];
        }
    }];
    [((BaseViewController*)self->controller) showActivityIndicator];
    [request startAsynchronous];
}
-(void) uploadFile{
    NSString *urlStr=@"/upload";
    ASIFormDataRequest *requestx= [HttpApiCall requestCallUpload:urlStr Params:nil Logo:@"notes_image" OutTime:30];
    __weak ASIFormDataRequest *request = requestx;
    __weak typeof(self) tempself = self;
    NSString *jsonkey = [NSString stringWithFormat:@"img-%lli.jpg",arc4random()/10000000000];
    NSString *key = [NSString stringWithFormat:@"fileName%d",1];
    NSData *data = UIImageJPEGRepresentation(currentImage, 1);
    [request setData:data withFileName:jsonkey andContentType:nil forKey:key];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        @try {
            NSArray *json = [responseString JSONValue];
            if(!json){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"网络无返回值!" userInfo:nil];
            }
            [tempself saveUploadFile:[[json[0] componentsSeparatedByString:@"/"] objectAtIndex:1]];
        }
        @catch (NSException *exception) {
            showMessageBox(exception.reason);
        }
        @finally {
//            [((BaseViewController*)self->controller) hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        showMessageBox(@"上传失败");
        [((BaseViewController*)self->controller) hideActivityIndicator];
    }];
    [((BaseViewController*)self->controller) showActivityIndicator];
    [request startAsynchronous];
}
-(void) saveUploadFile:(NSString*) fileName{
    NSDictionary *json = [[NSMutableDictionary alloc]init];
    [json setValue:fileName forKey:@"attachName"];
    [json setValue:[NSString stringWithFormat:@"%@/%@",[ConfigManage getLoginUser].userId,fileName] forKey:@"attachUrl"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/attachments" Params:json Logo:@"notes_file_save"];
    __weak ASIFormDataRequest *request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *responseString = [request responseString];
            NSNumber *_id = [[responseString JSONValue] objectForKey:@"id"];
            [((BaseViewController*)self->controller) hideActivityIndicator];
            [tempself saveData:_id];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        
    }];
    [request setFailedBlock:^{
        [((BaseViewController*)self->controller) hideActivityIndicator];
    }];
    [((BaseViewController*)self->controller) showActivityIndicator];
    [request startAsynchronous];
}
-(void) clickPhontoView:(id) sender{
    if(_imagePhoto.image){
        FlowPhotoViewController *c = [[FlowPhotoViewController alloc]initWithNibName:@"FlowPhotoViewController" bundle:nil];
        c.imageView = _imagePhoto.image;
        [self->controller.navigationController pushViewController:c animated:YES];
    }
}

@end
