//
//  UIImageZoomShowOpt.h
//  ST-ME
//
//  Created by wlpiaoyi on 12/18/13.
//  Copyright (c) 2013 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
/**
 图片操作
 author:wlpiaoyi
 */
@interface UIImageZoomShowOpt : UIScrollView<UIScrollViewDelegate>
{
    @private  BOOL isZoomImages;
    @protected EMAsyncImageView *imageView;//要查看的图片
    @public PXMSZoomOpt pXMSZoomOpt;//查看器大小和图片的最大放大倍数
}
-(void) _setPXMSZoomOpt:(PXMSZoomOpt) opt;
-(void) _setUIImageView:(EMAsyncImageView*) imvw;
-(void) _setUIImageForImageView:(UIImage*) im;
-(void) _setUIImageForImageURL:(NSString*) url;

@end
