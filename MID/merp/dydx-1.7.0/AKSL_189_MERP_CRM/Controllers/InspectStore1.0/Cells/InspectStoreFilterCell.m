//
//  InspectStoreFilterCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/11.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreFilterCell.h"

@implementation InspectStoreFilterCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setDeleteButtonBackground:(UIColor *)color{
    _delButton.backgroundColor = color;
}
-(void)setData:(SelectorOfInspectStore *)selector{
    _textForTitle.text = selector.title;
     _textForRemit.hidden =YES;
     _textForCount.hidden = YES;
    _imgXunyixunDianzan.hidden = YES;
    _imgXunyixunPinglun.hidden = YES;
    _textzan.hidden = YES;
    _textpinglun.hidden = YES;
    switch (selector.type) {
        case 0:
            [_imageForTitle setImage:[UIImage imageNamed:@"icon_xunyixun_new.png"]];
            if(selector.countOfRemind>0){
                _textForCount.text = [NSString stringWithFormat:@"有 %d 条最新巡店",selector.countOfRemind];
                _textForRemit.text = [NSString stringWithFormat:@"%d",selector.countOfRemind];
                _textForRemit.layer.cornerRadius = 7;
                _textForRemit.hidden = NO;
                _textForCount.hidden = NO;
            }
            break;
        case 1:
            [_imageForTitle setImage:[UIImage imageNamed:@"icon_xunyixun_self.png"]];
                _imgXunyixunDianzan.hidden = NO;
                _imgXunyixunPinglun.hidden = NO;
                [_textForCount setHidden:YES];
                _textzan.text = [NSString stringWithFormat:@"有 %i 个赞",selector.countOfLike];
                _textpinglun.text = [NSString stringWithFormat:@"有 %i 条评论",selector.countOfComment];
                _textpinglun.hidden = NO;
                _textzan.hidden = NO;
            break;
        case 2:
            [_imageForTitle setImage:[UIImage imageNamed:@"icon_xunyixun_like.png"]];
            if (selector.countOfLike >0) {
                _textForCount.text = [NSString stringWithFormat:@"最高排名 %i 个点赞",selector.countOfLike];
                _textForCount.hidden = NO;
            }
            break;
        case 3:
            [_imageForTitle setImage:[UIImage imageNamed:@"icon_xunyixun_comment.png"]];
            if (selector.countOfComment >0) {
                _textForCount.text = [NSString stringWithFormat:@"最高排名 %i 条评论",selector.countOfComment];
                 _textForCount.hidden = NO;
            }
            break;
        case 4:
            [_imageForTitle setImage:[UIImage imageNamed:@"icon_xunyixun_add.png"]];
            _textForCount.text = @"自定义关注内容";
            _textForCount.hidden = NO;
             _textForRemit.hidden =YES;
            break;
        default:
            if(selector.countOfRemind>0){
                _textForCount.text = [NSString stringWithFormat:@"有 %d 条最新巡店",selector.countOfRemind];
                _textForRemit.text = [NSString stringWithFormat:@"%d",selector.countOfRemind];
                _textForRemit.layer.cornerRadius = 7;
                _textForRemit.hidden = NO;
                _textForCount.hidden = NO;
            }
            if(selector.imageUrl)
            [_imageForTitle setImageUrl:selector.imageUrl];
            else
            [_imageForTitle setImage:[UIImage imageNamed:@"icon_image_small.png"]];
            break;
    }
    if(selector.isMoveing){
        self.contentView.hidden = YES;
    }else{
        self.contentView.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
