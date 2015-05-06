//
//  AKUIChartView.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-2.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AKChartViewHeight 200

@class AKUIChartView;
@interface AKUIChartOptionInfo : NSObject

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) UIColor *color;

@end
@protocol AKUIChartViewDelegate <NSObject>
@required
//相应类型的各个数据，也就是Y坐标数据   optionsIndex是表示你传入类型列表的位置
-(NSArray*)DataListForOptions:(NSInteger)optionsIndex;
//数据X坐标数据名字
-(NSArray*)DataNameList;
@optional
//如果需要绘制多个数据，比如一个是今年数据，一个是去年数据
-(NSArray*)OptionsInChartView;
//选中数据节点的回调函数
-(void)AKUIChartView:(AKUIChartView *)chartView selectedNode:(NSInteger)nodeIndex;
@end


@interface AKUIChartView : UIView{
    id <AKUIChartViewDelegate> delegate;
    CGFloat chartHeight;
    NSInteger maxDataListNum;
    NSInteger selectedX;
    bool isTouch;
}

@property (nonatomic,retain) id <AKUIChartViewDelegate> delegate;
@property (assign,nonatomic) float viewLeftMargins;
@property (assign,nonatomic) float viewTopMargins;
@property (assign,nonatomic) float top;

-(void)replaceData;
-(id)initWithHeight:(CGFloat)height Top:(CGFloat)viewtop Delegate:(id)getdelegate;
@end

