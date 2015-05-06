//
//  NewInspectCameraPage.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/12.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewInspectCameraPage : UIViewController
@property (retain,nonatomic) IBOutlet UIView * imagesView;
@property (retain,nonatomic) IBOutlet UILabel * textForCountOfImages;
@property (retain,nonatomic) IBOutlet UIView * cameraView;


-(void)setImages:(NSMutableArray *)listIamge isFrsat:(BOOL)isfrsat;
-(IBAction)deleteImages:(id)sender;
@end
