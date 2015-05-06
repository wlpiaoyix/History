//
//  CTM_RecordFromUserCell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-23.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_RecordFromUserCell.h"
#import "EntityManagerAddressBook.h"
#import "EMAsyncImageView.h"
#import "EntityPhone.h"
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
    
    EntityManagerAddressBook *emab = COMMON_EMAB;
    _imageHead.image = [emab findImageHeadByRef:userx.userKey];
//    _imageHead.layer.cornerRadius = _imageHead.frame.size.width/2;
//    _imageHead.layer.borderWidth = 0.5;
//    _imageHead.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
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
