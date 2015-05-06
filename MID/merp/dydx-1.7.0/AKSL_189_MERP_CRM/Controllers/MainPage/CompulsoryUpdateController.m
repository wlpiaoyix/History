//
//  CompulsoryUpdateController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/28.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CompulsoryUpdateController.h"

@interface CompulsoryUpdateController ()

@end

@implementation CompulsoryUpdateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_noteString) {
        CGSize size=[_noteString sizeWithFont:_textForNote.font constrainedToSize:CGSizeMake(_textForNote.frame.size.width, 1000)];
        CGRect farme = _textForNote.frame;
        farme.size.height = size.height;
        _textForNote.frame = farme;
        _textForNote.text = _noteString;
    }
    if (_updateType>=100) {
        [_goBackBut setEnabled:NO];
        [_goupdateBut setTitle:@"必须升级" forState:UIControlStateNormal];
    }
    [self setCornerRadiusAndBorder:_goupdateBut];
    [self setCornerRadiusAndBorder:_goBackBut];
    // Do any additional setup after loading the view from its nib.
  
}


-(IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)goToUpdate:(id)sender{
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_BASE_URL(@"/app/")]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
