//
//  LaunchViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController<UIScrollViewDelegate>{
    NSInteger selectPage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UIButton *ToLongin;
- (IBAction)clickBackground:(id)sender;

@end
