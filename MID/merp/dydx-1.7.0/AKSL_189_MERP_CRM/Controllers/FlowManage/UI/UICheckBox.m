//
//  UICheckBox.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-20.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UICheckBox.h"
@interface UICheckBox(){
    id targetx;
    SEL actionx;
    ModleCheckBox *mcb;
    UIColor *colorDefault;
}
@property (strong, nonatomic) IBOutlet UIButton *button01;
@property (strong, nonatomic) IBOutlet UIButton *button02;
@property (strong, nonatomic) IBOutlet UILabel *lable01;

@end

@implementation UICheckBox
+(id) getNewInstance{
    UICheckBox *cb = [[[NSBundle mainBundle] loadNibNamed:@"UICheckBox" owner:self options:nil] lastObject];
    cb->colorDefault = cb.lable01.textColor;
    return cb;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    if(mcb&&[NSString isEnabled:mcb.text])
        _lable01.text = mcb.text;
    [super willMoveToSuperview:newSuperview];
}
-(void) setButtonTargetHidden:(bool) flag{
    [_button01 setHidden:flag];
    [_button02 setHidden:flag];
    if(flag){
        _lable01.textColor = [UIColor grayColor];
    }else{
        _lable01.textColor = colorDefault;
    }
}
-(void) setCheckText:(NSString*) text{
    _lable01.text = text;
}
-(bool) isSelected{
    return _button01.selected;
}
-(void) setSelected:(bool) flag{
    _button01.selected = flag;
}
-(CGSize)setModleCheckBox:(ModleCheckBox*) model{
    mcb = model;
    CGSize size=[mcb.text sizeWithFont:_lable01.font constrainedToSize:CGSizeMake(220, 1000)];
    int offsetWidth = size.width-_lable01.frame.size.width;
    if(offsetWidth>0){
        int xx = offsetWidth%40;
        int yy = offsetWidth/40;
        if (xx) {
            ++yy;
        }
        if(yy>4){
            yy=4;
        }
        offsetWidth = 40*yy;
    }else{
        offsetWidth = 0;
    }
    if(offsetWidth>0){
        CGRect r = self.frame;
        r.size.width = 80+offsetWidth;
        self.frame = r;
        r = _lable01.frame;
        r.size.width = 60+offsetWidth;
        _lable01.frame = r;
        r = _button02.frame;
        r.size.width = 80+offsetWidth;
        _button02.frame = r;
    }
    return self.frame.size;
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    targetx = target;
    actionx = action;
    [_button02 addTarget:self action:@selector(clickCheck:) forControlEvents:controlEvents];
}
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    targetx = nil;
    actionx = nil;
    [_button02 removeTarget:self action:@selector(clickCheck:) forControlEvents:controlEvents];
}
-(void) clickCheck:(id) sender{
    if(targetx&&actionx){
        _button01.selected = !_button01.selected;
        mcb.isSelected = _button01.selected;
        [targetx performSelector:actionx withObject:mcb];
    }
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
