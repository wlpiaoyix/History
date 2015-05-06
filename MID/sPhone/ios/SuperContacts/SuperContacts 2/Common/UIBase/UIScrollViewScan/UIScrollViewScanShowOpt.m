//
//  UIScrollViewScanShowOpt.m
//  ST-ME
//
//  Created by wlpiaoyi on 12/18/13.
//  Copyright (c) 2013 wlpiaoyi. All rights reserved.
//

#import "UIScrollViewScanShowOpt.h"
#import "UIImageZoomShowOpt.h"
static NSString *UIScrollViewScanShowOpt_JSON_image = @"image";
static NSString *UIScrollViewScanShowOpt_JSON_url = @"url";
@interface UIScrollViewScanShowOpt()
@property (strong, nonatomic) NSMutableArray *datas;//图片数据
@property unsigned int count;//数据总数
@property unsigned int index;//当前浏览位置
@property unsigned int baseTag;//scrollView中的view tag
@property CGRect rects;//所在位置
@property bool initFlag;//是否初始化完成
@property CGPoint dragPoint;//拖动起始坐标
@property (unsafe_unretained, nonatomic) id target;
@property (unsafe_unretained, nonatomic) SEL dragMethod;
@end

@implementation UIScrollViewScanShowOpt
-(id) init{
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
/**
 设置image数组
 */
-(void) setViewImages:(NSArray*) images
{
    self.count = [images count];
    self.datas = [[NSMutableArray alloc]init];
    for (UIImage *image in images) {
        NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
        [json setValue:image forKey:UIScrollViewScanShowOpt_JSON_image];
        [self.datas addObject:json];
    }
    [self checkSelfRect];
    [self setImageViews];
}
/**
 设置data数组
 */
-(void) setViewData:(NSArray*) datas
{
    self.count = [datas count];
    self.datas = [[NSMutableArray alloc]init];
    for (NSData *_data in datas) {
        NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
        [json setValue:[[UIImage alloc] initWithData:_data] forKey:UIScrollViewScanShowOpt_JSON_image];
        [self.datas addObject:json];
    }
    [self checkSelfRect];
    [self setImageViews];
}
/**
 设置url数组
 */
-(void)setViewURL:(NSArray *) urls
{
    self.count = [urls count];
    self.datas = [[NSMutableArray alloc]init];
    for (NSString *url in urls) {
        NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
        [json setValue:url forKey:UIScrollViewScanShowOpt_JSON_url];
        [self.datas addObject:json];
    }
    [self checkSelfRect];
    [self setImageViews];
}
-(void) setImageViews{
    unsigned int  curIndex = 0;
    for (NSDictionary *json in self.datas) {
        UIImageZoomShowOpt  *zoomScrollView = [[UIImageZoomShowOpt alloc]init];
        CGRect frame = self.rects;
        [zoomScrollView _setPXMSZoomOpt:PXMSZoomOptMake(self.rects.size.width, self.rects.size.height, 2.5)];
        frame.origin.x = frame.size.width * curIndex;
        frame.origin.y = 0;
        zoomScrollView.frame = frame;
        zoomScrollView.tag = self.baseTag+curIndex;
        [self addSubview:zoomScrollView];
        [zoomScrollView release];
        curIndex++;
    }
    [self checkImageData:self.index];
}
- (void)didAddSubview:(UIView *)subview;
{
    if(!self.initFlag){
        self.initFlag = YES;
        CGPoint p = CGPointMake(self.index*self.rects.size.width, 0);
        [self setContentOffset:p animated:YES];
    }
    [super didAddSubview:subview];
}
/**
 设置大小和位置
 */
-(void) checkSelfRect
{
    if(self.rects.origin.x==0&&self.rects.origin.y==0&&self.rects.size.width==0&&self.rects.size.height==0){
        self.rects = CGRectMake(0, 0, COMMON_SCREEN_W, COMMON_SCREEN_H);
    }
    CGRect r = self.rects;
    self.frame = r;
    r.size.width = r.size.width* self.count;
    [self setContentSize:r.size];
}
/**
 设置默认值
 */
-(void) setDefaultValue{
    __unsafe_unretained typeof(self) temself = self;
    self.delegate = temself;
    self.pagingEnabled = YES;
    if(!IOS7_OR_LATER)self.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.baseTag = arc4random() % 50000 + 200000;
    self.backgroundColor =  [UIColor blackColor];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(!IOS7_OR_LATER)return;
    CGSize z = scrollView.contentSize;
    unsigned int tempIndex = targetContentOffset->x/(z.width/self.count);
    if (tempIndex==self.index) {
        return;
    }
    self.index = tempIndex;
    [self checkImageData:self.index];
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if(IOS7_OR_LATER)return;
    NSLog(@"====%f",scale);
}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.dragPoint= scrollView.contentOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(IOS7_OR_LATER) return;
//    CGSize z = scrollView.contentSize;
//    unsigned int index = self.dragPoint.x/(z.width/self.count);
    CGPoint p = scrollView.contentOffset;
    float tempx = p.x-self.dragPoint.x;
    float tempy = p.y -self.dragPoint.y;
    NSLog(@"drag point x:%f y:%f",tempx,tempy);
}
-(void) _setRects:(CGRect) rects{
    self.rects = rects;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(IOS7_OR_LATER) return;
    CGSize z = scrollView.contentSize;
    unsigned int tempIndex = self.contentOffset.x/(z.width/self.count);
    if(self.index!=tempIndex)
    {
        [self checkImageData:tempIndex];
        self.index = tempIndex;
    }
}
-(void) checkImageData:(unsigned int) index{
    UIImageZoomShowOpt *uxso = (UIImageZoomShowOpt*)[self viewWithTag:(self.baseTag+index)];
    UIImageZoomShowOpt *uxso1 = (UIImageZoomShowOpt*)[self viewWithTag:(self.baseTag+index-1)];
    UIImageZoomShowOpt *uxso2 = (UIImageZoomShowOpt*)[self viewWithTag:(self.baseTag+index+1)];
    if(uxso1){
        CGRect zoom = CGRectMake(0, 0, uxso1->pXMSZoomOpt.w*uxso1->pXMSZoomOpt.n, uxso1->pXMSZoomOpt.h*uxso1->pXMSZoomOpt.n);
        [uxso1 zoomToRect:zoom animated:YES];
    }
    if(uxso2){
        CGRect zoom = CGRectMake(0, 0, uxso2->pXMSZoomOpt.w*uxso2->pXMSZoomOpt.n, uxso2->pXMSZoomOpt.h*uxso2->pXMSZoomOpt.n);
        [uxso2 zoomToRect:zoom animated:YES];
    }
    
    CGRect zoom = CGRectMake(0, 0, uxso->pXMSZoomOpt.w*uxso->pXMSZoomOpt.n, uxso->pXMSZoomOpt.h*uxso->pXMSZoomOpt.n);
    [uxso zoomToRect:zoom animated:YES];
    UIImage *image = [self checkImage:self.datas[index]];
    NSString *url = [self checkURL:self.datas[index]];
    if (image) {
        [uxso _setUIImageForImageView:image];
    }else{
        [uxso _setUIImageForImageURL:url];
    }
    if(self.target&&self.dragMethod){
        [self.target performSelectorInBackground:self.dragMethod withObject:[[NSNumber alloc] initWithInteger:index]];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%d ==sdfsdfsd",scrollView.tag);
}

-(UIImage*) checkImage:(NSDictionary*) json
{
    UIImage *image = [json objectForKey:@"image"];
    if(!image){
        return nil;
    }
    return image;
}
-(NSString*) checkURL:(NSDictionary*) json
{
    NSString *url = [json objectForKey:@"url"];
    if(!url){
        return nil;
    }
    return url;
}
-(oneway void) release{
    [super release];
}
-(void) dealloc{
    [super dealloc];
}
@end
