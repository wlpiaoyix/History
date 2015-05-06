//
//  SystemSetsAboutViewCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-12-2.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsAboutViewCell.h"

@implementation SystemSetsAboutViewCell{
    BOOL isGetErweima;
}

+(id)init{
    SystemSetsAboutViewCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsAboutViewCell" owner:self options:nil] lastObject];
    return ssc;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (!isGetErweima) {
       NSString *urlImage =[[NSString stringWithFormat:@"%@:%d/images/default/download.png",HTTP_FILE_URL,APP_FILE_PORT]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
       _viewErweima.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
        isGetErweima = YES;
        _banbenhao.text = [NSString stringWithFormat:@"版本号:%@",SYSTEM_VERSION_NUMBER];
    }
    [super willMoveToSuperview:newSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
