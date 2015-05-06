//
//  MyTourroundCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-29.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MyTourroundCell.h"

@implementation MyTourroundCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setTourroundData:(NSDictionary *)tourroundDic ISDate:(BOOL)isDate IsCheckType:(BOOL)isCheckType
{
    if (self.imgDefaultPic) {
        self.imgDefaultPic.image = [UIImage imageNamed:@""];
        for(EMAsyncImageView *view in [self.imgDefaultPic subviews])
        {
            [view removeFromSuperview];
        }
        self.imgDefaultPic.layer.cornerRadius = 0;
    }
    [self.lblDay setHidden:NO];
    [self.lblMonth setHidden:NO];
    [self.textCheckTypeName setHidden:NO];
    if (!isDate) {
        if (isCheckType) {
            [self.lblDay setHidden:YES];
            [self.lblMonth setHidden:YES];
            [self.textCheckTypeName setHidden:YES];
        }
        else if (!isCheckType) {
            [self.lblDay setHidden:NO];
            [self.lblMonth setHidden:NO];
            [self.textCheckTypeName setHidden:NO];
        }
    }
    self.lblCheckLocation.text = [tourroundDic objectForKey:@"orgName"];
    self.textCheckTypeName.text = [tourroundDic objectForKey:@"checkTypeName"];
    self.textOrgName.text = [tourroundDic objectForKey:@"checkContents"];
    
    if ([[tourroundDic objectForKey:@"listAttamentUrl"] count] == 1) {
        self.imgDefaultPic.imageUrl = API_IMAGE_URL_GET2([[tourroundDic objectForKey:@"listAttamentUrl"] firstObject]);
        self.imgDefaultPic.layer.cornerRadius = 0;
    }
    else if ([[tourroundDic objectForKey:@"listAttamentUrl"] count] == 2)
    {
        for (int i =0 ; i< 2; i++) {
            EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(i*39, 0, 36, 75)];
            imgView.imageUrl = API_IMAGE_URL_GET2([[tourroundDic objectForKey:@"listAttamentUrl"] objectAtIndex:i]);
            imgView.layer.cornerRadius = 0;
            [self.imgDefaultPic addSubview:imgView];
        }
    }
    else if ([[tourroundDic objectForKey:@"listAttamentUrl"] count] == 3)
    {
        EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 75)];
        imgView.imageUrl = API_IMAGE_URL_GET2([[tourroundDic objectForKey:@"listAttamentUrl"] firstObject]);
        imgView.layer.cornerRadius = 0;
        [self.imgDefaultPic addSubview:imgView];
        for (int i =0 ; i< 2; i++) {
            EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(39, i*39, 36, 36)];
            imgView.imageUrl = API_IMAGE_URL_GET2([[tourroundDic objectForKey:@"listAttamentUrl"] objectAtIndex:i+1]);
            imgView.layer.cornerRadius = 0;
            [self.imgDefaultPic addSubview:imgView];
        }
    }
    else if ([[tourroundDic objectForKey:@"listAttamentUrl"] count] >= 4)
    {
        for (int i =0 ; i< 2; i++) {
            for (int j = 0; j<2; j++) {
                if ((i*2+j) <4 ) {
                    EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(j*39, i*39, 36, 36)];
                    imgView.imageUrl = API_IMAGE_URL_GET2([[tourroundDic objectForKey:@"listAttamentUrl"] objectAtIndex:i*2+j]);
                    imgView.layer.cornerRadius = 0;
                    [self.imgDefaultPic addSubview:imgView];
                }
                else
                {
                    break;
                }
            }
        }
    }

    NSDate *date = [NSDate dateFormateString:[tourroundDic objectForKey:@"checkTime"] FormatePattern:@"yyyy-MM-dd HH:mm:ss"] ;
    NSString *month = [NSString stringWithFormat:@"%d",date.month];
    NSString *day = [NSString stringWithFormat:@"%d",date.day];
    self.lblDay.text = day;
    self.lblMonth.text = [month  stringByAppendingString:@"月"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
