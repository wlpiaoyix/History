//
//  MonthReportedView.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MonthReportedView.h"



@implementation MonthReportedView{
 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)replaceData{
[self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rectangle = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillPath(context);
    
    CGFloat r_max = rect.size.width/2;
    CGFloat r_small = r_max/5;
    CGFloat r_bg = r_max - r_small;
    double capacity = (360/12)*_month;
    UIColor * bgColor = [UIColor colorWithRed:0.090 green:0.651 blue:0.016 alpha:1];
    [self paintpie:context start:270 capacity:capacity pointx:r_max pointy:r_max Radius:r_bg piecolor:bgColor];
    [self round:context pointx:r_max pointy:r_max Radius:r_bg-3 piecolor:[UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1]];
    [self round:context pointx:r_max pointy:r_max Radius:r_bg-3.5 piecolor:[UIColor whiteColor]];
    float cos =(r_bg-6)*cosf(radians(capacity+270));
    float sin =(r_bg-6)*sinf(radians(capacity+270));
    [self round:context pointx:r_max+cos pointy:r_max+sin Radius:r_small piecolor:bgColor];
  
    //绘制文字
    NSString * monthStr = [NSString stringWithFormat:@"%d",_month];
    NSString * numStr = [NSString stringWithFormat:@"%.0f",_numForReport];
    CGContextSetFillColorWithColor(context,
                                   [UIColor whiteColor].CGColor);
    [monthStr drawInRect:CGRectMake(r_max+cos-r_small, r_max+sin-r_small+5, r_small*2, r_small*2) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    CGContextSetFillColorWithColor(context,
                                   [UIColor grayColor].CGColor);
    
    [@"本月上报" drawInRect:CGRectMake(0, r_max-18, self.frame.size.width, 14) withFont:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    CGContextSetFillColorWithColor(context,
                                   bgColor.CGColor);
    
    [numStr drawInRect:CGRectMake(0, r_max, self.frame.size.width, 14) withFont:[UIFont systemFontOfSize:17] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}

static inline float radians(double degrees) { return degrees * PI / 180; }
-(void)round:(CGContextRef)ctx
      pointx:(double)x
      pointy:(double)y
      Radius:(CGFloat)radius
    piecolor:(UIColor *)color{
    //获得圆的位子大小
    CGRect rectForEllipse = CGRectMake(x-radius, y-radius, radius*2, radius*2);
    //设置颜色
     CGContextSetFillColorWithColor(ctx, color.CGColor);
    //移动到中心点
    CGContextMoveToPoint(ctx, x, y);
    //绘制
    CGContextAddEllipseInRect(ctx, rectForEllipse);
    //
    CGContextFillPath(ctx);
}
-(void)paintpie:(CGContextRef)ctx
          start:(double)pieStart
       capacity:(double)pieCapacity
         pointx:(double)x
         pointy:(double)y
         Radius:(CGFloat)radius
       piecolor:(UIColor *)color{
    //起始角度，0-360
    double snapshot_start = pieStart;
    //结束角度
    double snapshot_finish = pieStart+pieCapacity;
    //设置扇形填充色
     CGContextSetFillColorWithColor(ctx, color.CGColor);
    //设置圆心
    CGContextMoveToPoint(ctx, x, y);
    //以radius为半径围绕圆心画指定角度扇形，0表示逆时针
    CGContextAddArc(ctx, x, y, radius,  radians(snapshot_start), radians(snapshot_finish), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
