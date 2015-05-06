//
//  PopUpDialogView.m
//  DXAlertView
//
//  Created by wlpiaoyi on 14-4-9.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "PopUpDialogView.h"
#import <objc/runtime.h>

#define ISO7_0Later [PopUpDialogView IOS7_0Later]?true:false
static float PopUpDialogView_buttonHight;
static float PopUpDialogView_buttonViewWidth;
@implementation PopUpDialogView{
@private
    UIView *dialogView;
    UILabel *dialogTitleLabel;
    UILabel *dialogMessageLabel;
    UIView *dialogButtonView;
    __weak id<PopUpDialogViewDelegate> delegate;
    int tagButton;
    int indexButton;
}
+(void)initialize{
    [super initialize];
    PopUpDialogView_buttonHight = 40;
    PopUpDialogView_buttonViewWidth = 260;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(bool) IOS7_0Later{
    float temp = [[UIDevice currentDevice].systemVersion floatValue];
    return temp>= 7.0?true:false;
}
+(PopUpDialogView*) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<PopUpDialogViewDelegate>)_delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    va_list _list;
    NSMutableArray *_resources = [NSMutableArray arrayWithObjects:otherButtonTitles,nil];
    va_start(_list, otherButtonTitles);
    NSString* resource;
    while ((resource = va_arg( _list, NSString *)))
    {
        [_resources addObject:resource];
    }
    va_end(_list);
    [_resources addObject:cancelButtonTitle];
    
    PopUpDialogView *pudv = [PopUpDialogView new];
    [pudv initParam];
    pudv->tagButton = (arc4random() % 9999999)*2;
    
    [pudv setHasCloseButton:YES];
    pudv->dialogView = [pudv createDialogView];
    pudv->dialogTitleLabel = [pudv createDialogTitleLabelWithTitle:title];
    pudv->dialogMessageLabel = [pudv createDialogMessageLabelWithMessage:message];
    [pudv->dialogView addSubview:pudv->dialogTitleLabel];
    [pudv->dialogView addSubview:pudv->dialogMessageLabel];
    
    pudv->dialogButtonView = [pudv createDialogButtonView:_resources];
    CGRect r  = pudv->dialogButtonView.frame;
    r.origin.y = pudv->dialogMessageLabel.frame.origin.y+pudv->dialogMessageLabel.frame.size.height;
    r.origin.x = (PopUpDialogView_buttonViewWidth-r.size.width)/2;
    pudv->dialogButtonView.frame = r;
    r = CGRectMake(0, 0, PopUpDialogView_buttonViewWidth, r.size.height+r.origin.y);
    [pudv->dialogView addSubview:pudv->dialogButtonView];
    
    pudv->dialogView.frame = r;
    [pudv addSubview:pudv->dialogView];
    
    pudv->delegate = _delegate;
    return pudv;
}
-(UIView*) createDialogView{
    UIView *_dialogView = [UIView new];
    _dialogView.backgroundColor = [UIColor whiteColor];
    [self setCornerRadiusAndBorder:_dialogView];
    return _dialogView;
}
-(UILabel*) createDialogMessageLabelWithMessage:(NSString *)message{
    UILabel *_dialogMessageLabel = [UILabel new];
    _dialogMessageLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _dialogMessageLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
    _dialogMessageLabel.numberOfLines = 0;
    _dialogMessageLabel.textAlignment = NSTextAlignmentCenter;
    
//    CGSize _size= CGSizeMake(PopUpDialogView_buttonViewWidth, self->dialogTitleLabel.frame.size.height+self->dialogTitleLabel.frame.origin.y+10);
    //==>计算文字占用的大小 ISO 7.1
    CGSize _size;
    if(ISO7_0Later){
        NSDictionary *attribute = @{NSFontAttributeName: dialogTitleLabel.font};
        _size = [message boundingRectWithSize:CGSizeMake(220, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        _size = [message sizeWithFont:dialogTitleLabel.font constrainedToSize:CGSizeMake(220, 1000)];
    }
    _size.width =  220;
    _size.height = _size.height<(self->dialogTitleLabel.frame.size.height+self->dialogTitleLabel.frame.origin.y+10)?
    //<==
    (self->dialogTitleLabel.frame.size.height+self->dialogTitleLabel.frame.origin.y+10):_size.height;
    _dialogMessageLabel.frame = CGRectMake((PopUpDialogView_buttonViewWidth-_size.width)/2, 30, _size.width, _size.height);
    _dialogMessageLabel.text = message;
    return _dialogMessageLabel;
}
-(UILabel*) createDialogTitleLabelWithTitle:(NSString *)title{
    UILabel *_dialogTitleLabel = [UILabel new];
    _dialogTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    _dialogTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
    _dialogTitleLabel.numberOfLines = 0;
    _dialogTitleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize _size= CGSizeMake(PopUpDialogView_buttonViewWidth, 30);//[message sizeWithFont:dialogTitleLabel.font constrainedToSize:CGSizeMake(220, 1000)];
    _dialogTitleLabel.frame = CGRectMake(0, 5, _size.width, _size.height);
    _dialogTitleLabel.text = title;
    return _dialogTitleLabel;
}
-(UIView*) createDialogButtonView:(NSMutableArray*) array{
    UIView *_dialogButtonView = [UIView new];
    CGSize size = CGSizeMake(PopUpDialogView_buttonViewWidth, PopUpDialogView_buttonHight);
    if ([array count]==2) {
        CGRect btnFrame = CGRectMake(0 , 0, size.width/2+1, PopUpDialogView_buttonHight);
        UIButton *btn = [self createOtherButton:array[0]];
        btn.frame = btnFrame;
        [_dialogButtonView addSubview:btn];
        btn = [self createCancelButton:array[1]];
        btnFrame.origin.x += size.width/2;
        btn.frame = btnFrame;
        [_dialogButtonView addSubview:btn];
    }else{
        CGRect btnFrame = CGRectMake(0 , 0, size.width, PopUpDialogView_buttonHight+1);
        UIButton *btn;
        NSString *cancel = [array lastObject];
        [array removeObject:cancel];
        for (NSString *buttonTitle in array) {
            btn = [self createOtherButton:buttonTitle];
            btn.frame = btnFrame;
            [_dialogButtonView addSubview:btn];
            btnFrame.origin.y += btnFrame.size.height-1;
        }
        btn = [self createCancelButton:cancel];
        btn.frame = btnFrame;
        [_dialogButtonView addSubview:btn];
        size.height+= btnFrame.origin.y;
    }
    CGRect r = _dialogButtonView.frame;
    r.size =  size;
    _dialogButtonView.frame = r;
    return _dialogButtonView;
}
-(UIButton*) createCancelButton:(NSString*) cancelTitle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.718 green:0.718 blue:0.718 alpha:1]] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1] forState:UIControlStateNormal];
    [btn setTitle:cancelTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setBorder:btn];
    btn.tag = self->tagButton+self->indexButton;
    self->indexButton++;
    return btn;
}
-(UIButton*) createOtherButton:(NSString*) otherTitle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.718 green:0.718 blue:0.718 alpha:1]] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1] forState:UIControlStateNormal];
    [btn setTitle:otherTitle forState:UIControlStateNormal];
    [self setBorder:btn];
    btn.tag = self->tagButton+self->indexButton;
    self->indexButton++;
    [btn addTarget:self action:@selector(clickOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)setCornerRadiusAndBorder:(UIView *)view{
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 0.5;
    [view setClipsToBounds:YES];
    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
-(void)setBorder:(UIView *)view{
    view.layer.borderWidth = 0.5;
    [view setClipsToBounds:YES];
    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
-(void) clickOtherButton:(UIButton*) button{
    if(self->delegate){
        __weak typeof(self) tempself = self;
        [self->delegate alertView:tempself clickedButtonAtIndex:(button.tag-self->tagButton)];
    }
}
-(void) clickCancelButton:(UIButton*) button{
    [super close];
    if(self->delegate){
        __weak typeof(self) tempself = self;
        SEL sel = @selector(alertView:clickedButtonAtIndex:);//得到方法uuid
        Method origMethod = class_getInstanceMethod([self->delegate class], sel);//找到对应类中的方法
        if(origMethod){//如果有就执行
            [self->delegate alertView:tempself clickedButtonAtIndex:(button.tag-self->tagButton)];
        }
        sel = @selector(alertViewCancel:);
        origMethod = class_getInstanceMethod([self->delegate class], sel);
        if(origMethod){
            [self->delegate alertViewCancel:tempself];
        }
    }
}
@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
