//
//  CustomerBirthdayDetailTableViewCell.m
//  FDC
//
//  Created by NewDoone on 15/1/22.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerBirthdayDetailTableViewCell.h"

@implementation CustomerBirthdayDetailTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}
-(void)setUserName:(UILabel *)userName{
    _userName=userName;
//    [self configBtnStars];
//    [self configStarsByIndex:self.starsCount];
    [self configStarsByIndex:3];
}
- (IBAction)telephoneCallAction:(id)sender {
    NSLog(@"telephoneCallAction");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
}
- (IBAction)sendMessageAction:(id)sender {
    NSLog(@"sendMessageAction");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.phoneNumber]]];
}
-(void)configBtnStars{
    for (UIButton* btn in self.btn_stars) {
        btn.imageView.image=[UIImage imageNamed:@"image_star_unselected.png"];
        [btn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)changeImage:(UIButton*)btn{
    for (UIButton* btn in self.btn_stars) {
        btn.imageView.image=[UIImage imageNamed:@"image_star_unselected.png"];
    }
    NSUInteger index=[self.btn_stars indexOfObject:btn];
    for (int i=0; i<index; i++) {
        UIButton* button=[self.btn_stars objectAtIndex:i];
        button.imageView.image=[UIImage imageNamed:@"image_star_selected.png"];
    }
}
-(void)configStarsByIndex:(NSUInteger)index{
    for (UIButton* btn in self.btn_stars) {
        btn.imageView.image=[UIImage imageNamed:@"image_star_unselected.png"];
    }
    for (int i=0; i<index; i++) {
        UIButton* button=[self.btn_stars objectAtIndex:i];
        button.imageView.image=[UIImage imageNamed:@"image_star_selected.png"];
    }

}
@end
