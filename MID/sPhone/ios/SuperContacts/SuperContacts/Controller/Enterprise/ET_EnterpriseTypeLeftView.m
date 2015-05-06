//
//  ET_EnterpriseTypeLeftView.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-24.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ET_EnterpriseTypeLeftView.h"
#import "EMAsyncImageView.h"
@interface ET_EnterpriseTypeLeftView()
@property (strong, nonatomic) IBOutlet UILabel *lableTypeName;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imagePic;
@end
@implementation ET_EnterpriseTypeLeftView{
@protected int curtype;
@protected CallBackClickEnterpriseType1 callbackx;
}

+(id) getNewInstance{

    NSArray *temp = [[NSBundle mainBundle] loadNibNamed:@"ET_EnterpriseTypeLeftView" owner:self options:nil];
    ET_EnterpriseTypeLeftView *left = [temp lastObject];
    return left;
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
    if([NSString isEnabled:imageUrl])_imagePic.image = [UIImage imageNamed:imageUrl] ;
    else _imagePic.image = nil;
    curtype = type;
}
-(int) getType{
    return curtype;
}
-(void) setCallBack:(CallBackClickEnterpriseType1) callBack{
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
