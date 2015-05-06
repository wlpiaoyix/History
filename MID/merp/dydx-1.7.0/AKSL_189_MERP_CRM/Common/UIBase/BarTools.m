//
//  BarTools.m
//  test02
//
//  Created by qqpiaoyi on 13-10-18.
//  Copyright (c) 2013年 qqpiaoyi. All rights reserved.
//

#import "BarTools.h"
#import "DrawCircle.h"
@interface BarTools()
@property (strong,nonatomic)NSArray *barColor;
@property int width;
@property int height;
@property NSDictionary *json;

@property int topH;
@property int bottomH;
@property int maxL;
@property int maxV;
@end
@implementation BarTools
/**
 {
 topInfo:{
 title:tille,
 value:10
 date:2013-01-16
 }
 viewInfo:{
 maxValue:100;
 data:[
 {id:1,value:20,info:xx},
 {id:1,value:50,info:xx},
 {id:1,value:80,info:xx},
 {id:1,value:60,info:xx}
 ]
 }
 }
 */
-(BarTools*) setBarColors:(NSArray*) colors{
    self.barColor= colors;
    return self;
}
+(BarTools*) inits:(NSDictionary*) json x:(int) x y:(int) y w:(int) w h:(int) h{
    BarTools *bt = [[BarTools alloc]initWithFrame:CGRectMake(x,y,w,h)];
    if(!bt.barColor){
        bt.barColor = [[NSArray alloc]initWithObjects:[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor redColor], nil];
    }
    
    //默认是320px的宽度
    if(w==0) w = 320;
    if(h==0) h = 200;
    bt.width = w;
    bt.height = h;
    //实例化一个UIView 左上角为坐标原点
    [bt setFrame:CGRectMake(x,y,w,h)];
    bt.backgroundColor = [UIColor whiteColor];
    bt.json = json;
    [bt addSubview:[bt createTopView:[bt.json objectForKey:@"topInfo"]]];
    [bt addSubview:[bt createCenterView:[bt.json objectForKey:@"viewInfo"]]];
    return bt;
}
-(void) createDy{
    NSArray *data = [[self.json objectForKey:@"viewInfo"] objectForKey:@"data"];//数据
    [UIView animateWithDuration:1 animations:^{
        int i = 100;
        int k = 0;
        while (YES) {
            UILabel *l = (UILabel*)[self viewWithTag:i];
            if(l==nil)break;
            NSDictionary *d =[data objectAtIndex:k];
            int value = [(NSNumber*)[d objectForKey:@"value"] intValue];
            int h = (self.maxL-self.bottomH-self.topH)*((value*1.0)/(self.maxV*1.0));
            if(h<0)h=0;
            h= self.topH+h+self.bottomH;
            CGRect r =  l.frame;
            r.origin.y = self.topH+(h-self.topH-self.bottomH);
            r.size.height = 0;
            l.frame = r;
            i++;
            k++;
        }
        i=100;
        k = 0;
        while (YES) {
            UILabel *l = (UILabel*)[self viewWithTag:i];
            if(l==nil)break;
            NSDictionary *d =[data objectAtIndex:k];
            int value = [(NSNumber*)[d objectForKey:@"value"] intValue];
            int h = (self.maxL-self.bottomH-self.topH)*((value*1.0)/(self.maxV*1.0));
            if(h<0)h=0;
            h= self.topH+h+self.bottomH;
            CGRect r =  l.frame;
            r.origin.y = r.origin.y-(h-self.topH-self.bottomH);
            r.size.height = h-self.topH-self.bottomH;
            l.frame = r;
            i++;
            k++;
        }
    }];
    
}
/**
 topInfo:{
 title:tille,
 value:10
 date:2013-01-16
 }
 */
-(UIView*) createTopView:(id) params{
    NSDictionary *json = (NSDictionary*)params;
    
    NSString *title = [json objectForKey:@"title"];
    int value = [(NSNumber*)[json objectForKey:@"value"] integerValue];
    NSString *date = [json objectForKey:@"date"];
    
    UIView *mainV = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.width,22)];
    [mainV setFrame:CGRectMake(0,0,self.width,22)];
    mainV.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 42, 21)];
    [mainV addSubview:leftTopLabel];
    leftTopLabel.backgroundColor = [UIColor whiteColor];
    leftTopLabel.font = [UIFont systemFontOfSize:14];
    leftTopLabel.textColor = [UIColor grayColor];
    //leftTopLabel.shadowColor = [UIColor yellowColor];
    leftTopLabel.textAlignment = NSTextAlignmentCenter;
    leftTopLabel.lineBreakMode = NSLineBreakByCharWrapping;
    leftTopLabel.numberOfLines = 2;
    leftTopLabel.text = title;
    
    UILabel *leftTopLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, 42, 21)];
    [mainV addSubview:leftTopLabel2];
    leftTopLabel2.backgroundColor = [UIColor redColor];
    leftTopLabel2.font = [UIFont systemFontOfSize:16];
    leftTopLabel2.textColor = [UIColor whiteColor];
    //leftTopLabel2.shadowColor = [UIColor yellowColor];
    leftTopLabel2.textAlignment = NSTextAlignmentCenter;
    leftTopLabel2.lineBreakMode = NSLineBreakByCharWrapping;
    leftTopLabel2.numberOfLines = 2;
    leftTopLabel2.text = [NSString stringWithFormat:@"%d",value];
    
    UILabel *rightTopLable1 = [[UILabel alloc] initWithFrame:CGRectMake(self.width-89, 0, 89, 18)];
    [mainV addSubview:rightTopLable1];
    rightTopLable1.backgroundColor = [UIColor whiteColor];
    rightTopLable1.font = [UIFont systemFontOfSize:12];
    rightTopLable1.textColor = [UIColor grayColor];
    //rightTopLable1.shadowColor = [UIColor yellowColor];
    rightTopLable1.textAlignment = NSTextAlignmentCenter;
    rightTopLable1.lineBreakMode = NSLineBreakByCharWrapping;
    rightTopLable1.numberOfLines = 2;
    rightTopLable1.text = date;
    
    UILabel *rightTopLable2 = [[UILabel alloc] initWithFrame:CGRectMake(self.width-89, 18, 89, 3)];
    [mainV addSubview:rightTopLable2];
    rightTopLable2.backgroundColor = [UIColor grayColor];
    rightTopLable2.text = @"";
    
    UILabel *rightBottonLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, self.width, 1)];
    [mainV addSubview:rightBottonLable1];
    rightBottonLable1.backgroundColor = [UIColor grayColor];
    rightBottonLable1.text = @"";
    //[leftTopLabel1 release];
    //[leftTopLabel2 release];
    //[rightBottonLable1 release];
    return mainV;
}
/**
 viewInfo:{
 maxValue:100;
 data:[
 {id:1,value:20,info:xx},
 {id:1,value:50,info:xx},
 {id:1,value:80,info:xx},
 {id:1,value:60,info:xx}
 ]
 */
-(UIView*) createCenterView:(id) params{
    NSDictionary *json = (NSDictionary*)params;
    self.maxV = [(NSNumber*)[json objectForKey:@"maxValue"] integerValue];//最大数值
    NSArray *data = [json objectForKey:@"data"];//数据
    self.maxL = self.height - 22;//最大长度
    int maxW = self.width;//最大宽度
    int maxB = [data count] ;//柱状图数
    self.bottomH = 42;//底部高度
    self.topH =21;//顶部高度
    
    int barW = maxW/(maxB*2);//柱状图宽度
    
    UIView *mainV = [[UIView alloc] initWithFrame:CGRectMake(0,22,maxW,self.maxL)];
    //[mainV setFrame:CGRectMake(0,22,maxW,maxL)];
    for (int i=0;i<maxB;i++) {
        NSDictionary *d =[data objectAtIndex:i];
        int value = [(NSNumber*)[d objectForKey:@"value"] intValue];
        NSString *info = (NSString*)[d objectForKey:@"info"];
        int x;
        if(i==0){
            x = barW/2;
        }else{
            x = barW/2 + i*(barW*2);
        }
        int h = (self.maxL-self.bottomH-self.topH)*((value*1.0)/(self.maxV*1.0));
        if(h<0)h=0;
        h= self.topH+h+self.bottomH;
        int y = self.maxL - h;
        //[DrawCircle drawLine:mainV.frame Startx:0 Starty:y Endx:320 Endy:y Bound:2 ColorRef:[UIColor blackColor].CGColor];
        //==>柱状图VIew
        UIView *barVw = [[UIView alloc] initWithFrame:CGRectMake(x, y, barW*2, h)];
        [barVw setBackgroundColor:[UIColor whiteColor]];
        [mainV addSubview:barVw];
        //<==柱状图VIew
        //==>加柱状图
        UILabel *munLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, barW, self.topH)];
        munLable.backgroundColor = [UIColor whiteColor];
        munLable.textAlignment = UITextAlignmentCenter;
        UIFont *f = [UIFont fontWithName:munLable.font.fontName size:12];
        munLable.font = f;
        munLable.text = [NSString stringWithFormat:@"%d", value];
        [barVw addSubview:munLable];
        UILabel *barLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topH, barW, h-self.topH-self.bottomH)];
        barLable.tag = 100+i;
        [barVw addSubview:barLable];
        barLable.backgroundColor = self.barColor[[self checkColorIndex:self.maxV CurValue:value ]];
        barLable.text = @"";
        
        UILabel *infoLable = [[UILabel alloc] initWithFrame:CGRectMake(0, h-self.bottomH, barW, self.bottomH)];
        infoLable.lineBreakMode = UILineBreakModeWordWrap;
        infoLable.backgroundColor = [UIColor whiteColor];
        infoLable.textAlignment = UITextAlignmentCenter;
        infoLable.numberOfLines = 0;
        infoLable.text = info;
        f = [UIFont fontWithName:infoLable.font.fontName size:12];
        infoLable.font = f;
        [barVw addSubview:infoLable];
        //<==加柱状图
        //[barVw release];
        //[munLable release];
        //[barVw release];
        //[infoLable release];
    }
    UILabel *bottonLable = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.maxL-self.bottomH-1), maxW, 1)];
    [mainV addSubview:bottonLable];
    bottonLable.backgroundColor = [UIColor grayColor];
    bottonLable.text = @"";
    [mainV setBackgroundColor:[UIColor whiteColor]];
    //[bottonLable release];
    return mainV;
}
-(int) checkColorIndex:(int) maxValue CurValue:(int) curValue{
    int colorsL = [self.barColor count];
    int averageValue =  maxValue/colorsL;
    int temp = 0;
    int temp2 = 0;
    while (temp<=curValue) {
        temp+= averageValue;
        if(temp>curValue){
            if(temp2==colorsL) return temp2-1;
            return temp2;
        }
        temp2++;
    }
    return 0;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}
@end
