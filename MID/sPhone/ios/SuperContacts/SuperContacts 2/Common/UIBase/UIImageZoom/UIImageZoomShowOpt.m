//
//  UIImageZoomShowOpt.m
//  ST-ME
//
//  Created by wlpiaoyi on 12/18/13.
//  Copyright (c) 2013 wlpiaoyi. All rights reserved.
//

#import "UIImageZoomShowOpt.h"

@interface UIImageZoomShowOpt (Utility)
@property (strong, nonatomic) NSDate *lastClickDate;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end
@implementation UIImageZoomShowOpt
-(id) init{
    pXMSZoomOpt = PXMSZoomOptMakeN(2.5);
    self = [super init];
    self.pagingEnabled = NO;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __unsafe_unretained typeof(self) temself = self;
        self.delegate = temself;
        self.frame = CGRectMake(0, 0, pXMSZoomOpt.w, pXMSZoomOpt.h);
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    [self initImageView];
    [super willMoveToSuperview:newSuperview];
}
- (void)initImageView
{
    imageView = [[EMAsyncImageView alloc]init];
//    imageView.isIgnoreCacheFile = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // The imageView can be zoomed largest size
    imageView.frame = CGRectMake(0, 0, pXMSZoomOpt.w * pXMSZoomOpt.n, pXMSZoomOpt.h* pXMSZoomOpt.n);
    imageView.sizeEstimate = self.frame.size;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView release];
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
}


#pragma mark - Zoom methods
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = self.zoomScale * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

-(void) _setPXMSZoomOpt:(PXMSZoomOpt) opt{
    pXMSZoomOpt = opt;
}
-(void) _setUIImageView:(EMAsyncImageView*) imvw{
    imageView = imvw;
}

-(void) _setUIImageForImageView:(UIImage*) im{
    imageView.image = im;
}
-(void) _setUIImageForImageURL:(NSString*) url{
    imageView.imageUrl = url;
}
-(void) drawRect:(CGRect)rect{
    [super drawRect:rect];
}
-(oneway void) release{
    [super release];
}
#pragma mark - View cycle
- (void)dealloc
{
    [super dealloc];
}


@end
