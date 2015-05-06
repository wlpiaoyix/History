//
//  ScanQRViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ScanQRViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "HttpApiCall.h"

@interface ScanQRViewController ()

@end

@implementation ScanQRViewController

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
    _textTitleAppEnUrl.text = TITLE_APP_EN;
    isCloseScan = YES;
    [self toZbarReaderView];

}

-(void)toZbarReaderView{
    
    
    _TextForScanQRView.text = @"扫瞄登陆Web";
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    ZBarImageScanner *scanner = reader.scanner;
    reader.cameraOverlayView = _overView;
    reader.showsZBarControls = NO;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
     //[self.mm_drawerController.navigationController pushViewController:reader animated:YES];
     [self presentModalViewController:reader animated:YES];
    isCloseScan = NO;
    [self beginScanQrLien];
}

-(void)beginScanQrLien{
    if(isCloseScan){
        //[self.mm_drawerController.navigationController popViewControllerAnimated:YES];
        [reader dismissModalViewControllerAnimated:YES];
        //[reader removeFromParentViewController];
        reader = nil;
        return;
    }
    _imageScanQRLine.frame = CGRectMake(21, 80, 272, 26);
    [UIView animateWithDuration:2 animations:^{
        _imageScanQRLine.frame = CGRectMake(21, 325, 272, 26);
    } completion:^(BOOL finished){
        [self beginScanQrLien];
    }];
   
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    if ([info count]>2) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for(ZBarSymbol *sym in results) {
            int q = sym.quality;
            if(quality < q) {
                quality = q;
                bestResult = sym;
            }
        }
        [self performSelector: @selector(presentResult:) withObject: bestResult afterDelay: .001];
    }else {
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        [self performSelector: @selector(presentResult:) withObject: symbol afterDelay: .001];
    }
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        _textForScanQRMessage.text = tempStr;
        
        [self toServerLogin:tempStr];
        //api/user/qr/{qr}
    }
    isCloseScan = YES;
}

-(void)toServerLogin:(NSString *)qr{
    if (![qr hasPrefix:@"akqr"]) {
        return;
    }
    NSString *url =[@"/api/user/qr/" stringByAppendingString:qr];// [NSString stringWithFormat:@"/api/products/1/10"];
     ASIFormDataRequest *requestx = [HttpApiCall requestCallPUT:url Params:nil Logo:@"LOGIN_BY_QR"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            if([reArg isEqualToString:@"\"ok\""]){
            _textForScanQRMessage.text = @"登录成功";
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    isCloseScan = YES;
   // [self.mm_drawerController.navigationController popViewControllerAnimated:NO];
 
}
- (IBAction)toButtonClick:(id)sender {
   // [self topButtonClick:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanQRagin:(id)sender {
    [self toZbarReaderView];
}
@end
