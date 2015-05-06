//
//  AKUIChartView.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-2.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "AKUIChartView.h"


@implementation AKUIChartView

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 320;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
        chartHeight = frame.size.height;
        _viewTopMargins = 15;
        _viewLeftMargins =5;
        selectedX = 0;
        isTouch = NO;
        // Initialization code
    }
    return self;
}

-(id)initWithHeight:(CGFloat)height Top:(CGFloat)viewtop Delegate:(id)getdelegate{
    self = [super initWithFrame:CGRectMake(0, viewtop, 320, height)];
    if (self) {
        chartHeight = height;
        self.delegate = getdelegate;
        self.top = viewtop;
        self.backgroundColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:1];
        _viewTopMargins = 15;
        _viewLeftMargins =5;
        selectedX = 0;
         isTouch = NO;
    }
    return self;
}

-(void)replaceData{
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    isTouch = YES;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat drawWidth = (320-_viewLeftMargins*2)/maxDataListNum;
    selectedX = (touchPoint.x - _viewLeftMargins*2)/drawWidth;
    if (selectedX<0) {
        selectedX =0;
    }else if(selectedX>=maxDataListNum){
        selectedX = maxDataListNum;
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//isTouch = NO;
  //  [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
   // isTouch = NO;
   // [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self];
//    
//    CGFloat drawWidth = (320-_viewLeftMargins*2)/maxDataListNum;
//   NSInteger CurSelectedX = (touchPoint.x - _viewLeftMargins*2)/drawWidth;
//    if (CurSelectedX<0) {
//        CurSelectedX =0;
//    }else if(CurSelectedX>=maxDataListNum){
//        CurSelectedX = maxDataListNum;
//    }
//    
//    if (CurSelectedX!=selectedX) {
//        selectedX = CurSelectedX;
//        [self setNeedsDisplay];
//    }

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    maxDataListNum = 9;
    // Drawing code
    CGFloat drawWidth=0;
    CGFloat drawY=0;
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //字体固定
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    
    //绘制大的背景 宽度固定320  高度自定
    
    CGRect rectangle = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillPath(context);
    
   
    
    //绘制底部X轴说明
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    rectangle = CGRectMake(0, chartHeight-22, 320, 22);
    CGContextAddRect(context, rectangle);
    CGContextFillPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, chartHeight);
    CGContextAddLineToPoint(context, 320, chartHeight);
    CGContextStrokePath(context);
    
    //绘制文字
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    NSArray *xName = [delegate DataNameList];
    if(xName){
        maxDataListNum = xName.count;
        drawWidth = (320-_viewLeftMargins*2)/xName.count;
        drawY = chartHeight - 20;
        
        for(int i=0;i<xName.count;i++){
            NSString *name = [xName objectAtIndex:i];
            rectangle = CGRectMake(_viewLeftMargins+drawWidth*i, drawY, drawWidth, 20);
            [name drawInRect:rectangle withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }
    }
    drawWidth = (320-_viewLeftMargins*2)/maxDataListNum;
     //绘制水平参考线
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.855 green:0.878 blue:0.906 alpha:1].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextBeginPath(context);
    drawY = chartHeight - 22;
    while (drawY>_viewTopMargins) {
        CGContextMoveToPoint(context, _viewLeftMargins, drawY);
        CGContextAddLineToPoint(context, 320 - _viewLeftMargins, drawY);
        drawY -=30 ;
    }
    CGContextStrokePath(context);
    CGContextSetAllowsAntialiasing(context, YES);
    
    //绘制按下以后，辅助线
    if (isTouch) {
        CGContextSetLineWidth(context,drawWidth);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(context,_viewLeftMargins+drawWidth*selectedX+drawWidth/2, _top);
        CGContextAddLineToPoint(context, _viewLeftMargins+drawWidth*selectedX+drawWidth/2, chartHeight-22);
        CGContextStrokePath(context);
        if ([delegate respondsToSelector:@selector(AKUIChartView:selectedNode:)]) {
            [delegate AKUIChartView:self selectedNode:selectedX];
        }
    }
    
    //绘制数据线
    NSArray *options = nil;
    NSArray *dataForOption = nil;

    
    if ([delegate respondsToSelector:@selector(OptionsInChartView)]) {
         options = [delegate OptionsInChartView];
    }
    
    if (options) {
        //CGPoint pp;
        for (int i=0; i<options.count; i++) {
            dataForOption = [delegate DataListForOptions:i];
            if (!dataForOption)break;
 //           AKUIChartOptionInfo * info = [options objectAtIndex:i];
//            CGContextSetStrokeColorWithColor(context, info.color.CGColor);
//            CGContextBeginPath(context);
//            CGContextSetLineWidth(context, 1);
//            rectangle = CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
//           CGContextAddEllipseInRect(context, nil);
        }
    }else{
        dataForOption = [delegate DataListForOptions:0];
        if (dataForOption){
            CGFloat stepValue = (chartHeight - _viewTopMargins - 42)/[self getMaxValue:dataForOption CurrMaxValue:0];
            //绘制每个数据
            [self drawDataToView:context Data:dataForOption StepValue:stepValue DrawWidth:drawWidth Option:nil];
        }
        
    }
    
    

}
-(void)drawDataToView:(CGContextRef)context Data:(NSArray *)dataforOption StepValue:(CGFloat)stepvalue DrawWidth:(CGFloat)drawWidth Option:(AKUIChartOptionInfo *)option{
    if (option) {
        CGContextSetStrokeColorWithColor(context, option.color.CGColor);
        
    }else{
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        
    }
    CGFloat pointSize = drawWidth/4;
    NSInteger fontsize = pointSize-2;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:(fontsize<11?11:fontsize)];
    
    CGContextSetLineWidth(context, pointSize/3);
    CGPoint prep;
    for (int i = 0 ; i< dataforOption.count ; i++) {
        CGFloat value = [(NSNumber*)[dataforOption objectAtIndex:i] floatValue];
         CGPoint curp = CGPointMake(_viewLeftMargins+i*drawWidth+(drawWidth-pointSize)/2,chartHeight - 22 - value*stepvalue-pointSize);
        //绘制数字
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        NSInteger inte =[(NSNumber*)[dataforOption objectAtIndex:i] integerValue];
        [[NSString stringWithFormat:@"%d",inte] drawInRect:CGRectMake(_viewLeftMargins+i*drawWidth-15, chartHeight - 40 - value*stepvalue-pointSize, drawWidth+30, 20) withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        //绘制连线
        if(i>0){
            CGContextBeginPath(context);
           CGFloat fr = pointSize/2;
            CGContextMoveToPoint(context, curp.x+fr, curp.y+fr);
            CGContextAddLineToPoint(context, prep.x+fr, prep.y+fr);
             CGContextStrokePath(context);
            CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
            CGRect rect = CGRectMake(curp.x, curp.y, pointSize, pointSize);
            CGContextAddEllipseInRect(context, rect);
            CGContextFillPath(context);
            rect =CGRectMake(prep.x, prep.y, pointSize, pointSize);
            CGContextAddEllipseInRect(context, rect);
            CGContextFillPath(context);
        }
        //绘制圆点
         CGRect rect = CGRectMake(curp.x, curp.y, pointSize, pointSize);
        CGContextBeginPath(context);
        CGContextAddEllipseInRect(context, rect);
        CGContextStrokePath(context);
        
        prep = curp;
    }
   
}
-(CGFloat)getMaxValue:(NSArray *)findList CurrMaxValue:(CGFloat)maxvalue{
    for (int i = 0; i<findList.count; i++) {
        CGFloat value = [(NSNumber*)[findList objectAtIndex:i] floatValue];
        if (value >maxvalue) {
            maxvalue = value;
        }
    }
    if (maxvalue<=40) {
        maxvalue = 40;
    }
    return maxvalue;
}
@end
