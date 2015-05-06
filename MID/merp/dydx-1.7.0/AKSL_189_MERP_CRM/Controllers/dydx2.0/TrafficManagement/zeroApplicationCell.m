//
//  zeroApplicationCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-1.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "zeroApplicationCell.h"

@implementation zeroApplicationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)setdata:(NSDictionary *)dataDic
{
    self.lblUserName.text = [dataDic objectForKey:@"userName"];
    self.lblArea.text = [dataDic objectForKey:@"area"];
    self.lblBureau.text = [dataDic objectForKey:@"bureau"];
    self.lblHall.text = [dataDic objectForKey:@"hall"];
    self.heardImg.imageUrl =API_IMAGE_URL_GET2([[dataDic objectForKey:@"portrait"] objectForKey:@"url"]);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
