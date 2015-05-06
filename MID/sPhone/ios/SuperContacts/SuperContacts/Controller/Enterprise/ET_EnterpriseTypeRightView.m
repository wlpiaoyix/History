//
//  ET_EnterpriseTypeRightView.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-24.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ET_EnterpriseTypeRightView.h"
#import "EMAsyncImageView.h"
@interface ET_EnterpriseTypeRightView()
@property (strong, nonatomic) IBOutlet UILabel *lableTypeName;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imagePic;
@end;
@implementation ET_EnterpriseTypeRightView{
@protected int curtype;
@protected CallBackClickEnterpriseType2 callbackx;
}

+(id) getNewInstance{
    NSArray *temp = [[NSBundle mainBundle] loadNibNamed:@"ET_EnterpriseTypeRightView" owner:self options:nil];
    ET_EnterpriseTypeRightView *right = [temp lastObject];
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

-(void) setData:(NSString*) typeName ImageUrl:(NSString*) imageUrl Type:(int)type{
    _lableTypeName.text = typeName;
    if([NSString isEnabled:imageUrl])_imagePic.image = [UIImage imageNamed:imageUrl];
    else _imagePic.image = nil;
    curtype = type;
}
-(int) getType{
    return curtype;
}
-(void) setCallBack:(CallBackClickEnterpriseType2) callBack{
    callbackx = callBack;
}
- (IBAction)clickTypeButton:(id)sender {
    if(callbackx){
        callbackx(curtype,_lableTypeName.text);
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
