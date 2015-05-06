//
//  SystemSetsHeadCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsHeadCell.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "UIImage+Convenience.h"
#import "LoginViewController.h"

#import "UIViewController+MMDrawerController.h"
@implementation SystemSetsHeadCell

+(id)init{
    SystemSetsHeadCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsHeadCell" owner:self options:nil] lastObject];
    ssc.imageHeads.layer.cornerRadius = ssc.imageHeads.frame.size.height/2;
    return ssc;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updateImage:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"上传头像"
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册",@"拍照",nil];
    [actionSheet showInView:self.tareget.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0: {
            [self OpenAlunm];
        }
            break;
        case 1: {
            [self startCamera];
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
        UIImage *image = [UIImage imageNamed:@"test_imgae.png"];
        self.imageHeads.image = image;
        [self commitData:image];
        showMessageBox(@"照相机不存在");
		return;
	}
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:camera animated:YES];
	[self.tareget presentModalViewController:camera animated:YES];
}
#pragma mark  开相册
-(void)OpenAlunm{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];//创建
    picker.delegate = self;//设置为托
    picker.allowsEditing=YES;//允许编辑图片
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:picker animated:YES];
//    [[LoginViewController getMainNav] presentModalViewController:picker animated:YES];
    [self.tareget presentModalViewController:picker animated:YES];
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
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageHeads.image = image;
        [self commitData:image];
	}
	else
	{
		return;
	}
}

-(void) commitData:(UIImage*) image{
    
    CGSize rx = image.size;
    rx.width = 110;
    rx.height = 110;
    image = [image setImageSize:rx];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"userPhotos"]];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    NSString *urlStr=@"/upload";
    ASIFormDataRequest *requestx= [HttpApiCall requestCallUpload:urlStr Params:nil Logo:@"notes_image" OutTime:30];
    __weak ASIFormDataRequest *request = requestx;
    [request setFile:fullPath forKey:@"fileName1"];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        @try {
            if(responseString&&responseString!=nil&&responseString.length>2){
                NSMutableDictionary *json = [[[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy] objectForKey:@"user"];
                NSMutableDictionary *portrait = [json objectForKey:@"portrait"];
                NSArray *temp1 =  [responseString JSONValueNewMy];
                [portrait setValue:temp1[0] forKey:@"attachUrl"];
                [portrait setValue:[temp1[0] substringFromIndex:9] forKey:@"attachName"];
                [json setValue:portrait forKey:@"portrait"];
                
                __weak ASIFormDataRequest *requestx = [HttpApiCall requestCallPUT:@"/api/user" Params:json Logo:@"edit_user_sex"];
                [requestx setCompletionBlock:^{
                    [requestx setResponseEncoding:NSUTF8StringEncoding];
                    NSString *reArg = [requestx responseString];
                    @try {
                        id temp = [reArg JSONValueNewMy];
                        NSDictionary *json = [[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy];
                        [json setValue:temp forKey:@"user"];
                        [ConfigManage setConfig:HTTP_API_JSON_PERSONINFO Value:[json JSONRepresentation]];
                        [ConfigManage updateLoginUser];
                        [ConfigManage updateOrganization];
                        if(temp){
                        }else{
                        }
                    }
                    @finally {
                    }
                    
                }];
                [requestx setFailedBlock:^{
                    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message: @"服务器没有响应！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }];
                [requestx startSynchronous];
                
            }else{
                showMessageBox(@"上传失败，出现味知异常");
            }
        }
        @catch (NSException *exception) {
            showMessageBox(@"上传失败，出现味知异常");
        }
    }];
    
    [request setFailedBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        NSLog(@"%@",responseString);
        showMessageBox(@"图片上传失败，请再次上传。");
    }];
    [request startSynchronous];
    
    
}

@end
