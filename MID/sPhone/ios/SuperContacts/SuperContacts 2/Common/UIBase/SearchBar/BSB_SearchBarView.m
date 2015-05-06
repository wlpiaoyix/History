//
//  BSB_SearchBarView.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BSB_SearchBarView.h"
@interface BSB_SearchBarView()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *buttonClear;
@property (strong, nonatomic) IBOutlet UIButton *buttonSearch;

@end
@implementation BSB_SearchBarView{
@private CallBackClickSearchBarSearch callbackSearch;
@private CallBackClickSearchBarClear callbackClear;
}

+(id) getNewInstance{
    NSArray *temp = [[NSBundle mainBundle] loadNibNamed:@"BSB_SearchBarView" owner:self options:nil];
    BSB_SearchBarView *right = [temp lastObject];
    return right;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) didMoveToSuperview{
    [_buttonClear addTarget:self action:@selector(clickClearValue:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSearch addTarget:self action:@selector(clickSearchValue:) forControlEvents:UIControlEventTouchUpInside];
    _textField.delegate = self;
    [super didMoveToSuperview];
}
-(void) clickClearValue:(id) sender{
    _textField.text = @"";
    if(callbackClear){
        callbackClear();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSearchValue:_textField];
    return YES;
}
-(void) clickSearchValue:(id) sender{
    [_textField resignFirstResponder];
    if(callbackSearch){
        callbackSearch(_textField.text);
    }
}

-(void) setCallBackSearch:(CallBackClickSearchBarSearch) search{
    callbackSearch = search;
}
-(void) setcallBackClear:(CallBackClickSearchBarClear) clear{
    callbackClear = clear;
}
-(UITextField*) getTextField{
    return _textField;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
