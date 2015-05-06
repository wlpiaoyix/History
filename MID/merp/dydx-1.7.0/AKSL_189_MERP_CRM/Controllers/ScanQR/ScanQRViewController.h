//
//  ScanQRViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "BaseViewController.h"

@interface ScanQRViewController : BaseViewController<ZBarReaderDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    ZBarReaderViewController *reader;
    bool isCloseScan;
}
- (IBAction)toButtonClick:(id)sender;
- (IBAction)scanQRagin:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageScanQRLine;
@property (strong, nonatomic) IBOutlet UIView *overView;
@property (weak, nonatomic) IBOutlet UILabel *TextForScanQRView;
@property (weak, nonatomic) IBOutlet UILabel *textForScanQRMessage;
@property (weak, nonatomic) IBOutlet UILabel *textTitleAppEnUrl;
- (IBAction)goBack:(id)sender;

@end
