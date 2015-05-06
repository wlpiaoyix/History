//
//  UIFlowUploadCell.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIFlowUploadCell.h"
@interface UIFlowUploadCell(){
}
@property (strong, nonatomic) IBOutlet UILabel *lablePhone;
@property (strong, nonatomic) IBOutlet UIImageView *image01;
@property (strong, nonatomic) IBOutlet UIImageView *image02;
@property (strong, nonatomic) IBOutlet UIImageView *image03;
@property (strong, nonatomic) IBOutlet UIImageView *image04;
@property (strong, nonatomic) IBOutlet UILabel *lableNum;
@property (strong, nonatomic) IBOutlet UILabel *lableDate;

@end
@implementation UIFlowUploadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSDictionary *)dataDic{
    
    _lablePhone.text  = [dataDic valueForKey:@"phoneNum"];
    _lableNum.text = [NSString stringWithFormat:@"%ld",[[dataDic valueForKey:@"payment"]longValue]];
    _lableDate.text = [[[dataDic valueForKey:@"reportTime"]substringFromIndex:5]substringToIndex:11];
    
    NSString * imageUrl = [[dataDic valueForKey:@"isActive"]intValue]==0?@"flowmanage_type03.png":@"flowmanage_type12.png";
    [_image01 setImage:[UIImage imageNamed:imageUrl]];
    imageUrl = [[dataDic valueForKey:@"isApp"]intValue]==0?@"flowmanage_type02.png":@"flowmanage_type11.png";
    [_image02 setImage:[UIImage imageNamed:imageUrl]];
    imageUrl = [[dataDic valueForKey:@"isPack"]intValue]==0?@"flowmanage_type01.png":@"flowmanage_type10.png";
    [_image03 setImage:[UIImage imageNamed:imageUrl]];
    
}
@end
