//
//  SelectCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SelectCell.h"


@implementation SelectCell{
    SwitchSelected * switchobj;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setData:(SwitchSelected *)obj{
    switchobj = obj;
    [self setSelected:obj.isSelected];
   // [_mainButton setSelected:obj.isSelected];
    _textForName.text = obj.value;
}

-(IBAction)selectButtonClick:(id)sender{
  //  switchobj.isSelected = !switchobj.isSelected;
  //  [_mainButton setSelected:switchobj.isSelected];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    switchobj.isSelected = selected;
    [_mainButton setSelected:selected];
    // Configure the view for the selected state
}

@end
