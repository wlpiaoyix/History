//
//  UIContextsFlow.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIContextsFlow.h"
#import "ModleCheckBox.h"
#import "UICheckViewContext.h"
@interface UIContextsFlow(){
@private
    id targetx;
    SEL actionx;
    bool flagHiddenBt;
    bool flagDSelect;
    NSArray *datasx;
}
@end
@implementation UIContextsFlow
+(id) getNewInstance{
    UIContextsFlow *cvc = [[[NSBundle mainBundle] loadNibNamed:@"UIContextsFlow" owner:self options:nil] lastObject];
    return cvc;
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
    [super willMoveToSuperview:newSuperview];
}
- (void)addEventTouchUp:(id)target action:(SEL)action{
    targetx = target;
    actionx = action;
}
-(void) setDatas:(NSArray*) datas{
    datasx = datas;
}
-(void) setButtonTargetHidden:(bool) flag{
    self->flagHiddenBt = flag;
}
-(void) setButtonTargetSelect:(bool) flag{
    self->flagDSelect = flag;
}
-(void) excuViewThread{
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(excuView) object:nil];
    [t start];
}
-(CGSize) excuView{
    CGPoint p = CGPointMake(0, 0);
    for (ModleCheckType *mct in datasx) {
        UICheckViewContext *cvc = [UICheckViewContext getNewInstance];
        [cvc setDatas:mct];
        [cvc setButtonTargetHidden:self->flagHiddenBt];
        [cvc addEventTouchUp:targetx action:actionx];
        CGSize s = [cvc excuView];
        CGRect r = cvc.frame;
        r.origin = p;
        cvc.frame = r;
        p.y += s.height;
        [self addSubview:cvc];
    }
    CGRect r =  self.frame;
    r.size = CGSizeMake(r.size.width, p.y);
    self.frame = r;
    return r.size;
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
