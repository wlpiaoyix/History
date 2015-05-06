//
//  UIScrollViewScanShowOpt.h
//  ST-ME
//
//  Created by wlpiaoyi on 12/18/13.
//  Copyright (c) 2013 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 图片浏览
 author:wlpiaoyi
 */
@interface UIScrollViewScanShowOpt : UIScrollView<UIScrollViewDelegate>
{
    //@protected unsigned viewNumber;//一共有多少张图片
}
/**
 设置image数组
 */
-(void) setViewImages:(NSArray*) images;
/**
 设置data数组
 */
-(void) setViewData:(NSArray*) datas;
/**
 设置url数组
 */
-(void)setViewURL:(NSArray *) urls;
/**
 设置位置和大小
 */
-(void) _setRects:(CGRect) rects;
/**
 设置当前浏览index
 */
-(void) setIndex:(unsigned int)index;
@end
