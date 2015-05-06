//
//  ManagerInspectListCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-31.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ManagerInspectListCell.h"
#import "NSDate+convenience.h"
@implementation ManagerInspectListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSDate *)date DateFlag:(bool) dateFlag ShopName:(NSString *)shopname Set:(NSString *)settext{
    NSDate *curd = [NSDate new];
    if(dateFlag){
        NSLog(@"%d --- %d",date.month,date.day);
        _DateMTextLabel.text = date.month>9?[NSString stringWithFormat:@"%d月",date.month]:[NSString stringWithFormat:@"0%d月",date.month];
        _DateTextLabel.text = date.day>9?[NSString stringWithFormat:@"%d",date.day]:[NSString stringWithFormat:@"0%d",date.day];
        if(curd.year==date.year&&curd.month==date.month&&curd.day==date.day){
            _DateMTextLabel.text = @"天";
            _DateTextLabel.text = @"今";
        }
    }else{
        _DateMTextLabel.text = _DateTextLabel.text = @"";
    }
    self.timeTextLabel.text = [NSDate dateFormateDate:date FormatePattern:@"HH:mm"];
    if(shopname&&shopname!=nil&&![[NSNull null] isEqual:shopname])
        _shopName.text = shopname;
    if(settext&&settext!=nil&&![[NSNull null] isEqual:settext])
        _setTextLabel.text = settext;
    
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
