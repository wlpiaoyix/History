//
//  ViewController.m
//  TelePhone
//
//  Created by wlpiaoyi on 14/12/31.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "TelephoneCenter.h"
#import <Common/NSString+Expand.h>

@interface ViewController ()
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UITextField *textField1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UITextField *textField2;
@property (nonatomic,strong) UITextField *textField3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 100, 40)];
    [_button1 setTitle:@"call" forState:UIControlStateNormal];
    _button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    [_button2 setTitle:@"msg" forState:UIControlStateNormal];
    
    _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(160, 50, 160, 40)];
    _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(160, 100, 160, 40)];
    _textField3 = [[UITextField alloc] initWithFrame:CGRectMake(160, 150, 160, 40)];
    _textField1.backgroundColor = _textField2.backgroundColor = _textField3.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_button1];
    [self.view addSubview:_button2];
    [self.view addSubview:_textField1];
    [self.view addSubview:_textField2];
    [self.view addSubview:_textField3];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_button1 addTarget:self action:@selector(onclick1) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(onclick2) forControlEvents:UIControlEventTouchUpInside];
}

-(void) onclick1{
    NSString *value = _textField1.text;
    [TelephoneCenter requestCallWithRecipient:value];
}
-(void) onclick2{
    NSString *value = _textField2.text;
    NSString *value2 = _textField3.text;
    if ([NSString isEnabled:value2]) {
        [TelephoneCenter requestSMSWithRecipients:[value2 componentsSeparatedByString:@","] message:value];
        
    }else{
        [TelephoneCenter requestSMSWithRecipient:value];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
