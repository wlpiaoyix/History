//
//  InspectStoreFilterCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/11.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorOfInspectStore.h"
#import "EMAsyncImageView.h"

@interface InspectStoreFilterCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel * textForTitle;
@property (weak,nonatomic) IBOutlet UILabel * textForCount;
@property (weak,nonatomic) IBOutlet UILabel * textForRemit;
@property (weak,nonatomic) IBOutlet EMAsyncImageView * imageForTitle;
@property (weak,nonatomic) IBOutlet UIButton * delButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgXunyixunDianzan;

@property (weak, nonatomic) IBOutlet UILabel *textzan;
@property (weak, nonatomic) IBOutlet UILabel *textpinglun;

@property (weak, nonatomic) IBOutlet UIImageView *imgXunyixunPinglun;
-(void)setData:(SelectorOfInspectStore *)selector;
-(void)setDeleteButtonBackground:(UIColor *)color;
@end
