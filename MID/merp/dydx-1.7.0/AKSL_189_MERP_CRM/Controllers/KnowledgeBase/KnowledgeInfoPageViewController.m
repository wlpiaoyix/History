//
//  KnowledgeInfoPageViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "KnowledgeInfoPageViewController.h"

@interface KnowledgeInfoPageViewController ()

@end

@implementation KnowledgeInfoPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGSize size=[_textConent.text sizeWithFont:_textConent.font constrainedToSize:CGSizeMake(_textConent.frame.size.width, 4000)];
   
        _textConent.frame = CGRectMake(_textConent.frame.origin.x, _textConent.frame.origin.y, _textConent.frame.size.width, size.height+20);
        CGFloat heightMax = _textConent.frame.origin.y+_textConent.frame.size.height;
        _ScrollView.contentSize = CGSizeMake(_ScrollView.frame.size.width,MAX(_ScrollView.frame.size.height+10, heightMax));
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_data) {
        _textTitle.text = [_data objectForKey:@"digest"];
        _textConent.text = [_data objectForKey:@"contents"];
        _textDate.text = [_data objectForKey:@"createTime"];
        _imageContent.imageUrl = API_IMAGE_URL_GET2([_data objectForKey:@"digestPicattachUrl"]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
