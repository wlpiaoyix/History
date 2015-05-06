//
//  CTM_RecordFromUserCell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-23.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_RecordFromUserCell.h"
#import "EMAsyncImageView.h"
#import "EntityPhone.h"
#import "MADE_COMMON.h"
@interface CTM_RecordFromUserCell()
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageHead;
@property (strong, nonatomic) IBOutlet UILabel *lableUserName;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneNum;
@end;
@implementation CTM_RecordFromUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setEntityUser:(EntityUser *)user{
    userx = user;
    _imageHead.isIgnoreCacheFile = YES;
    _imageHead.image = nil;
    _lablePhoneNum.text = @"";
    _lableUserName.text = @"";
    if(userx.dataImage){
        if([userx.dataImage isKindOfClass:[NSData class]]){
            UIImage *image = [[UIImage alloc] initWithData:userx.dataImage];
            _imageHead.image = image;
        }else if([userx.dataImage isKindOfClass:[NSString class]]&&[NSString isEnabled:userx.dataImage]){
            _imageHead.image = [UIImage imageWithContentsOfFile:[MADE_COMMON parsetAddTag:@"110" Url:(NSString*)user.dataImage]];
        }
        _imageHead.layer.cornerRadius = _imageHead.frame.size.width/2;
        _imageHead.layer.borderWidth = 0.5;
        _imageHead.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    }
    _lableUserName.text = userx.userName;
    _lablePhoneNum.text = ((EntityPhone*)[[userx getTelephones] objectAtIndex:0]).phoneNum;
}
-(void) setExcueClickButton:(RFUCExcueClickButton) method{
    methodx = method;
}
- (IBAction)clickButton:(id)sender {
    if(methodx){
        methodx(userx);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
