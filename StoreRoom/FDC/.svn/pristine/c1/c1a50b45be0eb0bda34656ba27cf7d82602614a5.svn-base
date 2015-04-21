//
//  CustomerTrackTableViewCell.m
//  FDC
//
//  Created by NewDoone on 15/1/26.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerTrackTableViewCell.h"

@implementation CustomerTrackTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLb_userName:(UILabel *)lb_userName{
    _lb_userName=lb_userName;
    //    [self configBtnStars];
    //    [self configStarsByIndex:self.starsCount];
    [self configStarsByIndex:self.starsCount];
}
-(void)configBtnStars{
    for (UIButton* btn in self.btn_stars) {
        btn.imageView.image=[UIImage imageNamed:@"image_star_unselected.png"];
//        [btn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
        
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
