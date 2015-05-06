//
//  UIRecordPhoneHeadView.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-28.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "UIRecordPhoneHeadView.h"
@interface UIRecordPhoneHeadView(){
    IBOutlet UILabel *lableHead;
}
@end
@implementation UIRecordPhoneHeadView
+(id) getNewInstance{
    NSArray *temp = [[NSBundle mainBundle] loadNibNamed:@"UIRecordPhoneHeadView" owner:self options:nil];
    return [temp lastObject];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setHeadText:(NSString*) title{
    lableHead.text = title;
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
