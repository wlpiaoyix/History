//
//  ET_PhoneNumCell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ET_PhoneNumCell.h"
#import "EMAsyncImageView.h"
@interface ET_PhoneNumCell()
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageEnterprise;
@property (strong, nonatomic) IBOutlet UILabel *lableEnterPriseName;
@property (strong, nonatomic) IBOutlet UILabel *lableEnterpriseAddress;

@end

@implementation ET_PhoneNumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setData:(NSString*) name Address:(NSString*) address ImageUrl:(NSString*) imageUrl{
    _lableEnterPriseName.text = name;
    _lableEnterpriseAddress.text = address;
    if([NSString isEnabled:imageUrl])_imageEnterprise.imageUrl = imageUrl;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
