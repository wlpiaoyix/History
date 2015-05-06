//
//  TableViewTools.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-28.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "TableViewTools.h"
@interface TableViewTools()
@property UIColor *cellBgcolor1;
@property UIColor *cellBgcolor2;
@property UIFont *font;
@property UIColor *textColor;
@property bool isReLoadWithSelected;
@property float rowHeight;
@property int rowNum;
@property SEL optRowNum;
@property SEL optCell;
@property SEL optRowHeight;
@property SEL optSelectrow;
@property id target;
@property (readwrite,nonatomic) NSArray *data;
@property int dataLength;
@end
@implementation TableViewTools 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

+(id) init{
    TableViewTools *tvt = [[TableViewTools alloc] initWithFrame:CGRectZero];
    //[[[NSBundle mainBundle] loadNibNamed:@"TableViewTools" owner:self options:nil] lastObject];
    [tvt setRowHeights:21.0];
    if (IOS7_OR_LATER ) {
        tvt.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        tvt.separatorColor = [UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7];
        UIEdgeInsets ei = tvt.separatorInset;
        ei.left = 0;
        [tvt setSeparatorInset:ei];
    }
    [tvt setCellBgcolors1:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.1]];
    [tvt setCellBgcolors2:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.2]];
    [tvt setTextFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [tvt setTextColors:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.9]];
    tvt.allowsSelection =YES;
//    CGRect frame = tvt.frame;
//    frame.size.height = 34*2+42;
//    tvt.frame = frame;
    tvt.delegate = tvt;
    tvt.dataSource = tvt;
    return tvt;
}
-(TableViewTools*) setOptSelectrows:(SEL) sel{
    self.optSelectrow = sel;
    return self;
}
-(TableViewTools*) setIsReLoadWithSelecteds:(bool) flag{
    self.isReLoadWithSelected = flag;
    return self;
}
-(TableViewTools*) setTextColors:(UIColor*) color{
    self.textColor = color;
    return self;
}
-(TableViewTools*) setTextFont:(UIFont*) font{
    self.font = font;
    return self;
}
-(TableViewTools*) setCellBgcolors1:(UIColor*) color {
    self.cellBgcolor1 = color;
    return self;
}
-(TableViewTools*) setCellBgcolors2:(UIColor*) color {
    self.cellBgcolor2 = color;
    return self;
}
-(TableViewTools*) setRowHeights:(float) rowHeight{
    self.rowHeight = rowHeight;
    return self;
}
-(TableViewTools*) setDatas:(NSArray*) data{
    self.data = data;
    self.dataLength = self.data.count;
    self.rowNum = self.dataLength;
    return self;
}
-(TableViewTools*) setTargets:(id)target{
    self.target = target;
    return self;
}
-(TableViewTools*) setOptRowHeights:(SEL)optRowHeight{
    if(self.target){
        self.optRowHeight = optRowHeight;
    }
    return self;
}
-(TableViewTools*) setOptRowNums:(SEL)optRowNum{
    if(self.target){
        self.optRowNum = optRowNum;
    }
    return self;
}
-(TableViewTools*) setOptCells:(SEL)optCell{
    if(self.target){
        self.optCell = optCell;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.optRowNum){
        NSNumber *rowNums = [self.target performSelector:self.optRowNum withObject:tableView withObject:[[NSNumber alloc] initWithInt:section]];
        return [rowNums intValue];
    }
    
    return self.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.optCell){
        UITableViewCell *tvc = [self.target performSelector:self.optCell withObject:tableView withObject:indexPath];
        return tvc;
    }else{
        TableViewCellTools *tvc  = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        if(tvc==nil){
            tvc = [TableViewCellTools init];
        }
        int indexRow = [indexPath row];
        tvc.lableText.text = [(NSDictionary*)self.data[indexRow] objectForKey:@"text"];
        tvc.lableText.font = self.font;
        tvc.lableText.textColor = self.textColor;
        tvc.backgroundColor = indexRow%2==0?self.cellBgcolor1:self.cellBgcolor2;
        return tvc;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.optRowHeight){
        NSNumber *rowHeight = [self.target performSelector:self.optRowHeight withObject:tableView withObject:indexPath];
        return [rowHeight floatValue];
    }
    return self.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.optSelectrow){
        [self.target performSelector:self.optSelectrow withObject:tableView withObject:indexPath];
    }
    if(self.isReLoadWithSelected){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
