//
//  UICheckViewContext.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UICheckViewContext.h"
#import "ModleCheckBox.h"
#import "UICheckBox.h"
static float height;
@interface UICheckViewContext(){
    id targetx;
    SEL actionx;
    ModleCheckType *typex;
    bool flagHiddenBt;
}
@property (strong, nonatomic) IBOutlet UILabel *lableTitle;
@property (strong, nonatomic) IBOutlet UIView *viewContext;
@end
@implementation UICheckViewContext
+(id) getNewInstance{
    UICheckViewContext *cvc = [[[NSBundle mainBundle] loadNibNamed:@"UICheckViewContext" owner:self options:nil] lastObject];
    height = 42;
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
-(void) setDatas:(ModleCheckType*) type{
    typex = type;
}
-(void) setButtonTargetHidden:(bool) flag{
    self->flagHiddenBt = flag;
}
-(void) excuViewThread{
    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(excuView) object:nil];
    [t start];
}
-(CGSize) excuView{
    //==>清除多余的视图
    _lableTitle.text = typex.text;
    NSArray *views =  _viewContext.subviews;
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    CGPoint p = CGPointMake(0, 3);
    UIImageView *lineimage;
    int viewhOffset = 42;
    for (ModleCheckBox *mcb in typex.boxes) {
        UICheckBox *cb = [UICheckBox getNewInstance];
        if(mcb.isSelfReported){
            [cb setButtonTargetHidden:NO];
            [cb setSelected:YES];
        }else{
            [cb setButtonTargetHidden:self->flagHiddenBt||mcb.isReported];
        }
        [cb addTarget:targetx action:actionx forControlEvents:UIControlEventTouchUpInside];
        CGSize s = [cb setModleCheckBox:mcb];
        CGRect r = cb.frame;
        r.origin = p;
        cb.frame = r;
        p.x += s.width;
        if(p.x>240){
            p.x =0;
            p.y += height;
            r.origin = p;
            cb.frame = r;
            [_viewContext addSubview:cb];
            p.x = s.width;
            lineimage = [UIImageView new];
            lineimage.frame = CGRectMake(0, p.y, _viewContext.frame.size.width, 1);
            UIImage *image = [UIImage imageNamed:@"line01.png"];
            lineimage.image = image;
//            viewhOffset = 0;
            [_viewContext addSubview:lineimage];
        }else{
            [_viewContext addSubview:cb];
//            viewhOffset = height;
        }
    }
    CGRect r = self.frame;
    r.size.height= p.y+viewhOffset+4;
    self.frame = r;
    r = _viewContext.frame;
    r.size.height= p.y+viewhOffset;
    _viewContext.frame = r;
//    if(lineimage)[lineimage removeFromSuperview];
    //<==
    return self.frame.size;
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
