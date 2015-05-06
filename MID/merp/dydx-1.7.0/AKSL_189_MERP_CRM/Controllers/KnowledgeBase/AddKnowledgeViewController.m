//
//  AddKnowledgeViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zuxia on 14-3-24.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "AddKnowledgeViewController.h"
#import "NotesImageViewController.h"
#import "MessageListViewController.h"
#import "ConfigManage.h"
#import "HttpApiCall.h"
#import "KnowledgeBaseViewController.h"
#import "SelectFoyerTypeController.h"
#import "SwitchSelected.h"
#import "ImageUtil.h"

@interface AddKnowledgeViewController ()
{
    NSMutableArray *imgArray;
    UIImage *img;
    int deleteIndex;
    UIImage *addImg;
    
    int updateImageCount;
    int successIamgeCount;
    NSMutableArray *imgIdArray;
    
    NSMutableArray *listForAllType;
    long addtypeId;
    
}

@end

@implementation AddKnowledgeViewController

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
    imgArray = [NSMutableArray new];
    imgIdArray = [NSMutableArray new];
    self.textContent.delegate = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    deleteIndex = -1;
    addImg = [UIImage imageNamed:@"but_bg_add_images.png"];
    [self.view addGestureRecognizer:longPress];
    [self setCornerRadiusAndBorder:[self imgView]];
    [self setCornerRadiusAndBorder:[self textContent]];
    [self setCornerRadiusAndBorder:[self textTitle]];
    [self setCornerRadiusAndBorder:[self typeId]];
    
    listForAllType = [NSMutableArray new];
        SwitchSelected * obj1 = [SwitchSelected new];
        obj1.key = 102;
        obj1.value  = @"本周重点";
        obj1.isSelected = NO;
        [listForAllType addObject:obj1];
    
    SwitchSelected * obj2 = [SwitchSelected new];
    obj2.key = 1028;
    obj2.value  = @"业务知识";
    obj2.isSelected = NO;
    [listForAllType addObject:obj2];
    
    SwitchSelected * obj3 = [SwitchSelected new];
    obj3.key = 1027;
    obj3.value  = @"销售政策";
    obj3.isSelected = NO;
    [listForAllType addObject:obj3];
    
    SwitchSelected * obj4 = [SwitchSelected new];
    obj4.key = 1029;
    obj4.value  = @"流量经营";
    obj4.isSelected = NO;
    [listForAllType addObject:obj4];
    
    ((SwitchSelected *)[listForAllType firstObject]).isSelected = YES;
    addtypeId = -1;

}
-(void)handleLongPress:(UILongPressGestureRecognizer *)pressGesture
{
    if(pressGesture.state == UIGestureRecognizerStateBegan)
    {
        if(deleteIndex<=0 || deleteIndex>4)
        {
            return;
        }
        UIActionSheet *acion = [[UIActionSheet alloc] initWithTitle:@"是否删除照片"
                                      delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        [acion showInView:self.view];
        
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(deleteIndex <=0 || deleteIndex >4)
        {
            return;
        }

        [imgArray removeObjectAtIndex:deleteIndex-1];

        int i=0;
        for (; i<[imgArray count]; i++) {
            UIImage * setImage = imgArray[i];
            
            UIButton * but=(UIButton *)[self.imgView viewWithTag:i+1];
            [but setImage:setImage forState:UIControlStateNormal];
            [but setImage:setImage forState:UIControlStateSelected];
            [but setHidden:NO];
        }
        UIButton * newImage=(UIButton *)[self.imgView viewWithTag:imgArray.count+1];
        [newImage setBackgroundImage:nil forState:UIControlStateNormal];
        [newImage setImage:addImg forState:UIControlStateNormal];
        [newImage setImage:addImg forState:UIControlStateSelected];
        if (imgArray.count+2<=4) {
            newImage=(UIButton *)[self.imgView viewWithTag:imgArray.count+2];
            [newImage setImage:addImg forState:UIControlStateNormal];
            [newImage setHidden:YES];
        }

        deleteIndex = -1;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addImgs:(id)sender {
    UIButton *btton = sender;
    deleteIndex = -1;
    if(btton.tag  == imgArray.count+1 || [imgArray count] ==0 )
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            img = [UIImage imageNamed:@"test_imgae.png"];
            [imgArray addObject:img];
            [self imgbutton:img];
            showMessageBox(@"当前无照相机");
            return;
        }
        [self presentViewController:picker animated:YES completion:Nil];
    }
    
    else if (imgArray.count >0)
    {
        NotesImageViewController *l = [[NotesImageViewController alloc]initWithNibName:@"NotesImageViewController" bundle:nil];
        NSMutableDictionary *jsonData = [[NSMutableDictionary alloc]init];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for(UIImage *temp2 in imgArray){
            NSDictionary *json = [[NSMutableDictionary alloc]init];
            [json setValue:temp2 forKey:@"imageView"];
            [temp addObject:json];
        }
        [jsonData setValue:temp forKey:@"data"];
        [l setJsonData:jsonData];
        [l setCurrentIndexJsonData:btton.tag-1];
        l.lableTitle.text = @"图片查看";
        [self.navigationController pushViewController:l animated:YES];
        
    }
}
-(void)imgbutton:(UIImage *)image
{
    image = [ImageUtil scaleFromImage:image MaxHeight:800 MaxWidth:600];
    [imgArray addObject:image];
    
    UIButton *button = (UIButton *)[self.imgView viewWithTag:imgArray.count];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateSelected];
    UIButton *newButton = (UIButton *)[self.imgView viewWithTag:imgArray.count+1];
    /*
     如果只允许用户上传一张照片，此处为YES，允许多张则为NO
     */
    [newButton setHidden:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self imgbutton:image];
	}
	else
	{
		return;
	}
}
- (IBAction)imgDown:(id)sender {
    UIButton *button = sender;
    if (button.tag <=[imgArray count] && [imgArray count]>0) {
        deleteIndex = button.tag;
    }
    
}

- (IBAction)imgUpOut:(id)sender {
    deleteIndex = -1;
}

- (IBAction)add:(id)sender {
//    MessageListViewController *messageList = [[MessageListViewController alloc] init];
//    [self.navigationController pushViewController:messageList animated:YES];
    if (imgArray.count <1) {
        showMessageBox(@"至少添加一张图片！");
        return;
    }
    
    [self showActivityIndicator];
    [self addKnowledgeImg];
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
   // [self.view bringSubviewToFront:self.openView];
    
    //CGRect rx = [ UIScreen mainScreen ].bounds;
    [UIView beginAnimations:@"move_m" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    
    CGRect newFrame = CGRectMake(0.0, -80.0, 320, 525);
    self.views.frame = newFrame;
    if ([self.textContent.text isEqualToString:@"内容："]) {
        self.textContent.text = @"";
    }
    [UIView commitAnimations];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textContent resignFirstResponder];
    [self.textTitle resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //[self.view bringSubviewToFront:self.openView];
    //CGRect rx = [ UIScreen mainScreen ].bounds;
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];

    CGRect newFrame = CGRectMake(0.0, 44 ,320, 525);
    self.views.frame = newFrame;
    [UIView commitAnimations];
}

-(void)addKnowledgeImg
{
    updateImageCount = 0;
    successIamgeCount = 0;
    [imgIdArray removeAllObjects];
    NSString *urlStr = @"/upload";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallUpload:urlStr Params:nil Logo:@"img_upload" OutTime:30];
    __weak ASIFormDataRequest *request = requestx;
    int i = 0;
    for (UIImage *temp1 in imgArray) {
        ++i;
        NSString *key = [NSString stringWithFormat:@"fileName%d",i];
        NSData *dataObj = UIImageJPEGRepresentation(temp1, 0.7);
        [request setData:dataObj withFileName:[key stringByAppendingString:@".jpg"] andContentType:nil forKey:key];
    }
    [request setCompletionBlock:^
    {
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        if (responseString) {
            NSArray *temp2 = [responseString JSONValueNewMy];
            if(!temp2 || temp2.count == 0)
            {
                showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
                [self hideActivityIndicator];
                return;
            }
            updateImageCount = temp2.count;
            for (NSString *temp3 in temp2) {
                NSString *temp4 = [temp3 componentsSeparatedByString:@"/"][1];
                [self saveUploadFile:temp4];
            }
        }
    }];
    [request setFailedBlock:^
    {
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
-(void)saveUploadFile :(NSString *)fileName
{
    NSMutableDictionary *imgDic = [[NSMutableDictionary alloc] init];
    [imgDic setValue:fileName forKey:@"attachName"];
    [imgDic setValue:[NSString stringWithFormat:@"%@/%@",[ConfigManage getLoginUser].userId,fileName] forKey:@"attachUrl"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/attachments" Params:imgDic Logo:@"notes_file"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^
    {
        successIamgeCount++;
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        NSMutableDictionary * dicRes = [responseString JSONValueNewMy];
        [dicRes removeObjectForKey:@"id"];
        if (!dicRes) {
            return;
        }
        [imgIdArray addObject:dicRes];
        [self addKnowledge];
    }];
    [request setFailedBlock:^
    {
        successIamgeCount++;
        [self addKnowledge];
    }];
    [request startAsynchronous];
}

- (IBAction)typeId:(id)sender {
    
    SelectFoyerTypeController *view = [[SelectFoyerTypeController alloc]initWithNibName:@"SelectFoyerTypeController" bundle:nil];
    view.catachData = listForAllType;
    view.ifSingleSelected = YES;
    view.titleName = @"展示类型选择";
    [view setRetureMethods:^(NSArray *selecteds) {
        if (selecteds.count>0) {
            SwitchSelected * obj = (SwitchSelected *)selecteds[0];
            addtypeId =[[NSNumber numberWithLongLong:obj.key]longValue];
            [self.typeId setTitle:obj.value forState:UIControlStateNormal];
            [self.typeId setSelected:YES];
        }
    }];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)addKnowledge
{
    /*
     POST /api/publicinfo
     /upload
     
     "names":"标题",
     "contents": "学一学内容",
     "digestPic":{"id":1},
     "digest":"摘要",
     "infoType": {"id":70},
     本周重点：102
     */
    if(successIamgeCount > 0 && successIamgeCount == updateImageCount)
    {
  
        NSMutableDictionary *public = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *idDic = [[NSMutableDictionary alloc] init];
        
        if (addtypeId == -1) {
            [idDic setObject:[NSNumber numberWithInteger:102] forKey:@"id"];
        }
        else
        {
            NSNumber *typeId = [NSNumber numberWithInteger:addtypeId];
            [idDic setObject:typeId forKey:@"id"];
        }
        
        [public setObject:idDic forKey:@"infoType"];
        [public setObject:[imgIdArray lastObject] forKey:@"digestPic"];
        [public setValue:self.textContent.text forKey:@"contents"];
        [public setValue:self.textTitle.text forKey:@"names"];
        [public setValue:self.textContent.text forKey:@"digest"];
        ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/publicinfo" Params:public Logo:@"addKnowleage"];
        __weak ASIFormDataRequest *request = requestx;
        [request setCompletionBlock:^
         {
             [self hideActivityIndicator];
             [request setResponseEncoding:NSUTF8StringEncoding];
             NSString *responseString = [request responseString];
             NSDictionary *temp = [responseString JSONValueNewMy];

             if(temp)
             {
                 showMessageBox(@"添加学一学成功！");
             }
             else
             {
                 showMessageBox(@"添加失败");
                 return;
             }
             [KnowledgeBaseViewController getKnowledgeBase];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }];
        [request setFailedBlock:^
         {
             [self hideActivityIndicator];
             showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
         }];
        [request startAsynchronous];
        
    }else if (updateImageCount == successIamgeCount)
    {
        [self hideActivityIndicator];
        showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
    }
}
@end
