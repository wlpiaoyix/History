//
//  AddInspectStoreViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "AddInspectStoreViewController.h"
#import "CLLocationManagerImpl.h"
#import "HttpApiCall.h"
#import "GTMBase64.h"
#import "NotesImageViewController.h"
#import "InspectStoreViewController.h"
#import "SwitchSelected.h"
#import "SelectFoyerTypeController.h"
#import "NotesForOrganizationController.h"
#import "ImageUtil.h"

@interface AddInspectStoreViewController (){
   double mapX;
   double mapY;
    bool flag2;
    NSMutableArray *listForImage;
    NSMutableArray *listForImageIds;
    NSMutableArray *listForAllType;
    int deletedForPicIndex;
    UIImage *AddImageObject;
    long typeId;
    long tdId;
    int updateImageCount;
    int successIamgeCount;
}

@end

@implementation AddInspectStoreViewController

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
    listForAllType = [NSMutableArray new];
    NSArray * datatype =[[InspectStoreViewController getInspectStoreMain]getListType];
    for (NSArray * ary in datatype) {
        SwitchSelected * obj = [SwitchSelected new];
         obj.key = [ary[0]longValue];
        obj.value  =ary[1];
        obj.isSelected = NO;
        [listForAllType addObject:obj];
    }
    ((SwitchSelected *)[listForAllType firstObject]).isSelected = YES;
    typeId = -1;
    tdId = 600;
    AddImageObject = [UIImage imageNamed:@"but_bg_add_images.png"];
    deletedForPicIndex = -1;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    
    [_ImageAllVIew addGestureRecognizer:longPress];
    listForImageIds = [NSMutableArray new];
    listForImage = [NSMutableArray new];
  //  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll:)];
  //  [_mainView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
    [_mainView addSubview:_OpView];
    [_mainView setContentSize:CGSizeMake(_OpView.frame.size.width, _OpView.frame.size.height)];
    [self setCornerRadiusAndBorder:_textAddr];
    [self setCornerRadiusAndBorder:_textTingdian];
    [self setCornerRadiusAndBorder:_textType];
    [self setCornerRadiusAndBorder:_textContent];
    [self setCornerRadiusAndBorder:_ImageAllVIew];
     [self setCornerRadiusAndBorder:_viewName];
    LoginUser * loginUser = [ConfigManage getLoginUser];
    _textUserName.text = loginUser.username;
    _textDate.text =[NSDate dateFormateDate:[NSDate new] FormatePattern:@"MM月dd日"];
    if(loginUser.roelId==4){
        [_textTingdian setTitle:loginUser.organizationTypeName forState:UIControlStateNormal];
        [_textTingdian setSelected:YES];
        [_textTingdian setEnabled:NO];
    }
    [self loadMap];
}

- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        if (deletedForPicIndex<=0||deletedForPicIndex>4) {
            return;
        }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"是否删除图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"删除",nil];
    [actionSheet showInView:self.view];
    }
}
- (IBAction)toucheControll:(id)sender {
    [_textContent resignFirstResponder];
}

-(void) loadMap{
    flag2 = NO;
    CLLocationManagerImpl *cmi = [CLLocationManagerImpl getInstance];
    [cmi setTargets:self];
    [cmi setTargetMethods:^id(id key, ...) {
        va_list arglist;
        va_start(arglist, key);
        AddInspectStoreViewController *vc = key;
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
     mapX = lc2D.longitude;
     mapY = lc2D.latitude;
    NSString *tempURL = [NSString stringWithFormat:@"http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=%f&y=%f", mapX, mapY];
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
            NSString *mapURL = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%@,%@&width=%d&height=%d&zoom=%d&markers=%@,%@&lable=%@",x,y,(int)_ImageMap.frame.size.width*2,(int)_ImageMap.frame.size.height*2,19,x,y,@"sdfsdf"];
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
                    NSString * addr= [([(NSDictionary*)json objectForKey:@"result"]) objectForKey:@"formatted_address"];
                    [_textAddr setTitle:addr forState:UIControlStateNormal];
                    [_textAddr setSelected:YES];
                    //                    self.imageMap.ifshowErroAlert = YES;
                    _ImageMap.isIgnoreCacheFile = YES;
                    _ImageMap.imageUrl= mapURL;//[UIImage imageWithData:[NSData dataWithContentsOfURL:u]];
                }
                
                @catch (NSException *exception) {
                    [_textAddr setTitle:@"百度地图无法得到你的位置名称" forState:UIControlStateNormal];
                    [_textAddr setSelected:NO];
                   flag2 = NO;
                }
            }];
            
            [requestx setFailedBlock:^{
                [_textAddr setTitle:@"百度地图无法得到你的位置名称" forState:UIControlStateNormal];
                [_textAddr setSelected:NO];
                  flag2 = NO;
            }];
            [requestx startAsynchronous];
        }
        @catch (NSException *exception) {
            [_textAddr setTitle:@"百度地图无法得到你的位置名称" forState:UIControlStateNormal];
            [_textAddr setSelected:NO];
            flag2 = NO;
        }
    }];
    
    [request setFailedBlock:^{
        [_textAddr setTitle:@"百度地图无法得到你的位置名称" forState:UIControlStateNormal];
        [_textAddr setSelected:NO];
         flag2 = NO;
    }];
    [request startAsynchronous];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textContent resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [listForImage removeAllObjects];
    [listForImageIds removeAllObjects];
    [_textContent resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)SendToServer:(id)sender {
   
    if (listForImage.count<=0) {
        showMessageBox(@"至少上传一张图片。");
        return;
    }
    [self showActivityIndicator];
    [_textContent resignFirstResponder];
    [self updateImageToServer];
}

-(void)updateImageToServer{
    updateImageCount = 0;
    successIamgeCount = 0;
    [listForImageIds removeAllObjects];
    NSString *urlStr=@"/upload";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallUpload:urlStr Params:nil Logo:@"notes_image_upload" OutTime:30];
    __weak ASIFormDataRequest *request = requestx;
    int i = 0;
    
    for(UIImage *temp1 in listForImage){
        ++i;
        NSString *key = [NSString stringWithFormat:@"fileName%d",i];
        NSData *dataObj = UIImageJPEGRepresentation(temp1, 0.7);
        [request setData:dataObj withFileName:[key stringByAppendingString:@".jpg"] andContentType:nil forKey:key];
    }
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        if(responseString){
            @try {
                NSArray *temp2 = [responseString JSONValueNewMy];
                if (!temp2||temp2.count==0) {
                    showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
                    [self hideActivityIndicator];
                    return;
                }
                updateImageCount = temp2.count;
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

-(void) saveUploadFile:(NSString*) fileName{
    NSDictionary *json = [[NSMutableDictionary alloc]init];
    [json setValue:fileName forKey:@"attachName"];
    [json setValue:[NSString stringWithFormat:@"%@/%@",[ConfigManage getLoginUser].userId,fileName] forKey:@"attachUrl"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/attachments" Params:json Logo:@"notes_file_save"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        @try {
            successIamgeCount++;
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *responseString = [request responseString];
            NSNumber *_id = [[responseString JSONValueNewMy] objectForKey:@"id"];
            [listForImageIds addObject:_id];
            [self plusCurrentCommit];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        
    }];
    [request setFailedBlock:^{
        successIamgeCount++;
        [self plusCurrentCommit];
    }];
    [request startAsynchronous];
}

//每上传一个文件就加一 直到上传成功的文件数等于添加数
- (void) plusCurrentCommit{
    if (successIamgeCount>0&&successIamgeCount==updateImageCount) {
        if (typeId<=0) {
            typeId = [[[[[InspectStoreViewController getInspectStoreMain]getListType]firstObject]objectAtIndex:0]longValue];
        }
            NSString *checkTime = [NSDate dateFormateDate:[NSDate new] FormatePattern:nil];
            NSString *checkIntroduce = _textContent.text;
        NSString *checkLocation =_textAddr.selected?_textAddr.titleLabel.text:@"地址不详";
            NSString *attamentsIds =@",";
            for(NSNumber *_id in listForImageIds){
                attamentsIds = [[attamentsIds stringByAppendingString:[_id stringValue]]stringByAppendingString:@","];
            }
            
            NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
            [json setValue:checkTime forKey:@"checkTime"];
            [json setValue:attamentsIds forKey:@"attamentsIds"];
            [json setValue:checkIntroduce forKey:@"checkContents"];
            [json setValue:checkLocation forKey:@"checkLocation"];
            [json setValue:[[NSString stringWithFormat:@"{\"id\":%ld}",typeId] JSONValueNewMy] forKey:@"checkType"];
        
            [json setValue:[[NSString stringWithFormat:@"{\"id\":%ld}",tdId] JSONValueNewMy] forKey:@"organization"];
              
            [json setValue:[ConfigManage getLoginUser].userObj  forKey:@"toUser"];
            ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/attendances" Params:json Logo:@"notes_add"];
            __weak ASIFormDataRequest *request = requestx;
            [request setCompletionBlock:^{
                [self hideActivityIndicator];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *responseString = [request responseString];
                @try {
                    NSDictionary *temp = [responseString JSONValueNewMy];
                    if(!temp){
                        showMessageBox(@"添加巡店失败!请检查填写数据，再次提交。");
                        return;
                    }
                    showMessageBox(@"添加巡店成功!");
                    [[InspectStoreViewController getInspectStoreMain]setChangeType:typeId];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                @catch (NSException *exception) {
                    showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
                }
                @finally {
 
                }
            }];
            [request setFailedBlock:^{
                
                [self hideActivityIndicator];
                showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
            }];
            [request startAsynchronous];
    }else if(updateImageCount==successIamgeCount){
        [self hideActivityIndicator];
         showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
    }
}


- (IBAction)ImageButtonClick:(id)sender {
    UIButton * but = sender;
     deletedForPicIndex = -1;
    //如果照片是添加
    if (but.tag==listForImage.count+1||listForImage.count==0) {
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
            UIImage * image = [UIImage imageNamed:@"test_imgae.png"];
            [self addImage:image];
            showMessageBox(@"照相机不存在");
            return;
        }
        [self presentModalViewController:camera animated:YES];
    }else if(listForImage.count>0){
     //显示照片
        NotesImageViewController *l = [[NotesImageViewController alloc]initWithNibName:@"NotesImageViewController" bundle:nil];
        NSMutableDictionary *jsonData = [[NSMutableDictionary alloc]init];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for(UIImage *temp2 in listForImage){
            NSDictionary *json = [[NSMutableDictionary alloc]init];
            [json setValue:temp2 forKey:@"imageView"];
            [temp addObject:json];
        }
        [jsonData setValue:temp forKey:@"data"];
        [l setJsonData:jsonData];　
        [l setCurrentIndexJsonData:but.tag-1];
        l.lableTitle.text = @"图片查看";
        [self.navigationController pushViewController:l animated:YES];
    }
    
}

- (IBAction)ImageButtonDown:(id)sender {
    UIButton * but = sender;
    //如果照片是添加
    if (but.tag<=listForImage.count&&listForImage.count>0) {
        deletedForPicIndex = but.tag;
    }
    
}

- (IBAction)ImageButtonUpOut:(id)sender {
     deletedForPicIndex = -1;
}
- (IBAction)SelectType:(id)sender {
    [_textContent resignFirstResponder];
      SelectFoyerTypeController *view = [[SelectFoyerTypeController alloc]initWithNibName:@"SelectFoyerTypeController" bundle:nil];
    view.catachData = listForAllType;
    view.ifSingleSelected = YES;
    view.titleName = @"展示类型选择";
    [view setRetureMethods:^(NSArray *selecteds) {
        if (selecteds.count>0) {
            SwitchSelected * obj = (SwitchSelected *)selecteds[0];
            typeId =[[NSNumber numberWithLongLong:obj.key]longValue];
            [_textType setTitle:obj.value forState:UIControlStateNormal];
            [_textType setSelected:YES];
             }
    }];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)selectTdName:(id)sender {
    [_textContent resignFirstResponder];
      NotesForOrganizationController *view = [[NotesForOrganizationController alloc]initWithNibName:@"NotesForOrganizationController" bundle:nil];
    [view setRetureMethods:^(NSDictionary *selecteds) {
        if (selecteds) {
            [_textTingdian setTitle:[selecteds objectForKey:@"shortName"] forState:UIControlStateNormal];
            tdId = [[selecteds objectForKey:@"id"]longValue];
            [_textTingdian setSelected:YES];
            
        }
    }];
    [self.navigationController pushViewController:view animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if (deletedForPicIndex>4||deletedForPicIndex<=0) {
                return;
            }
            [listForImage removeObjectAtIndex:deletedForPicIndex-1];
            int i=0;
            for (; i<listForImage.count; i++) {
                UIImage * setImage = listForImage[i];
                 UIButton * but=(UIButton *)[_ImageAllVIew viewWithTag:i+1];
                [but setImage:setImage forState:UIControlStateNormal];
                [but setHidden:NO];
            }
            UIButton * newImage=(UIButton *)[_ImageAllVIew viewWithTag:listForImage.count+1];
            [newImage setImage:AddImageObject forState:UIControlStateNormal];
            if (listForImage.count+2<=4) {
                newImage=(UIButton *)[_ImageAllVIew viewWithTag:listForImage.count+2];
                [newImage setImage:AddImageObject forState:UIControlStateNormal];
                [newImage setHidden:YES];
            }
            deletedForPicIndex = -1;
            break;
        
    }
}

-(void)addImage:(UIImage*)image{
    if (listForImage.count>=4) {
        return;
    }
    image = [ImageUtil scaleFromImage:image MaxHeight:800 MaxWidth:600];
    [listForImage addObject:image];
  UIButton * setImage=(UIButton *)[_ImageAllVIew viewWithTag:listForImage.count];
  UIButton * newImage=(UIButton *)[_ImageAllVIew viewWithTag:listForImage.count+1];
    [setImage setImage:image forState:UIControlStateNormal];
    [newImage setHidden:NO];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self addImage:image];
	}
	else
	{
		return;
	}
}
@end
