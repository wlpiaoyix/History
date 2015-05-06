//
//  CTM_Contents_Cell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_Contents_Cell.h"
#import "EntityManagerAddressBook.h"
@interface CTM_Contents_Cell()
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageHead;
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) EntityUser *user;
@end
@implementation CTM_Contents_Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setEntityUser:(EntityUser*) user{
    _imageHead.isIgnoreCacheFile = YES;
    _imageHead.image = nil;
    EntityManagerAddressBook *emab = COMMON_EMAB;
    _imageHead.image = [emab findImageHeadByRef:user.userKey];
//    _imageHead.layer.cornerRadius = _imageHead.frame.size.width/2;
//    _imageHead.layer.borderWidth = 0.5;
//    _imageHead.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    _lableName.text = user.userName;
    _user = user;
}
-(void) setContentsClickCall:(ContentsClickCall) method{
    xmethod = method;
}
- (IBAction)clickCall:(id)sender {
    if(xmethod){
        xmethod(_user);
    }
}

@end
