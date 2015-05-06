//
//  AKUIWebViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "AKUIWebViewController.h"
#import "ShareUtils.h"
#import "UMSocial.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define GESTURE_STATE_START 0
#define GESTURE_STATE_TOUCH 1
#define GESTURE_STATE_END 2

@interface AKUIWebViewController (){
 
    UIActionSheet* sheet;
}

@end

@implementation AKUIWebViewController

static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

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
    if (_url) {
        NSURL *url =[NSURL URLWithString:_url];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [_WebVIew loadRequest:request];
    }
    
    if (self.title) {
        _TitleName.text = self.title;
    }
}
- (IBAction)update:(id)sender {
    if (_url) {
        NSURL *url =[NSURL URLWithString:_url];
        NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [_WebVIew loadRequest:request];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString =[[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                
                NSLog(@"touch start!");
                
                float ptX =[[components objectAtIndex:3]floatValue];
                float ptY =[[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.WebVIew stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                    _gesState = GESTURE_STATE_START;
                }else{
                    _gesState = GESTURE_STATE_TOUCH;
                }
                if (_imgURL) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                 _gesState = GESTURE_STATE_TOUCH;
                
                NSLog(@"you are move");
            }
            else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
                [_timer invalidate];
                _timer = nil;
                if (_gesState==GESTURE_STATE_START) {
                    //到放大图片
                    // 1.封装图片数据
                    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                    if (_imgURL) {
                        NSLog(@"imgurl = %@", _imgURL);
                    }
                    
                    NSString *getImageStrUrl = [self.WebVIew stringByEvaluatingJavaScriptFromString:_imgURL];
                    NSLog(@"image url=%@", getImageStrUrl);
                    
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.url = [NSURL URLWithString: getImageStrUrl ]; // 图片路径
                   UIImage * image = [UIImage imageNamed:@"activity_image_bg.png"];
                    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
                    photo.srcImageView = imageView;
                    [photos addObject:photo];
                    
                    // 2.显示相册
                    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
                    browser.photos = photos; // 设置所有的图片
                    [browser show];
                }else{
                _gesState = GESTURE_STATE_END;
                }
                NSLog(@"touch end");
            }
            
        }
       
    return NO;
}
return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //[self showActivityIndicator];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   // [self hideActivityIndicator];
    showMessageBox(@"网页错误，无法打开该链接。");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //[self hideActivityIndicator];
    [self.WebVIew stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareUrl:(id)sender {
    NSString *urlToSave = [self.WebVIew stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"img\")[0].src"];
    NSLog(@"image url=%@", urlToSave);
    UIImage* image;
    if(urlToSave&&urlToSave.length>7){
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
     image = [UIImage imageWithData:data];
    }
    if (!image) {
      image = [UIImage imageNamed:@"activity_image_bg.png"];
    }
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:[ShareUtils getShareTypeString:1 Url:_url Title:self.title]
                                     shareImage:image
                                shareToSnsNames:[ShareUtils getSharePlatforms]
                                       delegate:nil];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleLongTouch {
   
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START) {
        if (!sheet) {
            sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
            sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        }
        
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
      
        NSString *urlToSave = [self.WebVIew stringByEvaluatingJavaScriptFromString:_imgURL];
        NSLog(@"image url=%@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
                            UIImage* image = [UIImage imageWithData:data];
                                                      
                                                      //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
                                                      UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                      }
                                                      }
                                                      
                                                      - (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
        {
            if (error){
                NSLog(@"Error");
               // [self showAlert:SNS_IMAGE_HINT_SAVE_FAILE];
            }else {
                NSLog(@"OK");
               // [self showAlert:SNS_IMAGE_HINT_SAVE_SUCCE];
            }
        }
@end
