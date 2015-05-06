//
//  MonthSellDataView.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MonthSellDataView.h"

@implementation MonthSellDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    CGFloat r_bg = rect.size.width/2;
    CGFloat r_c = r_bg/2+3;
    UIColor *bgColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1];
    double capacity = 36*_valueForPercent;
    capacity = capacity/10.0;
    float cos =r_bg*cosf(radians(capacity/2+150));
    float sin =r_bg*sinf(radians(capacity/2+150));
    
    [self round:context pointx:r_bg pointy:r_bg Radius:r_bg piecolor:[UIColor colorWithRed:1.000 green:0.925 blue:0.678 alpha:0.4]];
    [self paintpie:context start:150 capacity:capacity pointx:r_bg pointy:r_bg Radius:r_bg piecolor:[UIColor colorWithRed:1.000 green:0.925 blue:0.678 alpha:1]];
    [self round:context pointx:r_bg pointy:r_bg Radius:r_c piecolor:bgColor];
    [self round:context pointx:r_bg pointy:r_bg Radius:r_c-3 piecolor:[UIColor whiteColor]];
    
    //绘制文字
    NSString * percentStr = [NSString stringWithFormat:@"%d%%",_valueForPercent];
    NSString * numStr = [NSString stringWithFormat:@"%.2f",_numForTotal];
    CGContextSetFillColorWithColor(context,
                                   [UIColor colorWithRed:0.957 green:0.286 blue:0.000 alpha:1].CGColor);
    if(cos>=0){
        cos = r_bg+cos-r_c;
    }else{
        cos += r_bg;
    }
    [percentStr drawInRect:CGRectMake(cos, r_bg+sin+3, r_c-3,18) withFont:[UIFont systemFontOfSize:11] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    
    [numStr drawInRect:CGRectMake(0, r_bg, self.frame.size.width, 12) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    //绘制图标
    UIGraphicsPushContext( context );
    [[UIImage imageNamed:@"icon_o_traffictotal.png"] drawInRect:CGRectMake(r_bg-7, r_bg-14, 14, 14)];
    UIGraphicsPopContext();
    
}


@end
