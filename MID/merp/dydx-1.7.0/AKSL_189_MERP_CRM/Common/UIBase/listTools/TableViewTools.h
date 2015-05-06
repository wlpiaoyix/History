//
//  TableViewTools.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-28.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellTools.h"

@interface TableViewTools : UITableView <UITableViewDelegate, UITableViewDataSource>
@property int index;
//==>只有在非自定义情况下有效
-(TableViewTools*) setCellBgcolors1:(UIColor*) color;
-(TableViewTools*) setCellBgcolors2:(UIColor*) color;
-(TableViewTools*) setRowHeights:(float) rowHeight;
-(TableViewTools*) setTextFont:(UIFont*) font;
-(TableViewTools*) setTextColors:(UIColor*) color;
//<==
-(TableViewTools*) setIsReLoadWithSelecteds:(bool) flag;
-(TableViewTools*) setOptSelectrows:(SEL) sel;
-(TableViewTools*) setDatas:(NSArray*) data;
-(TableViewTools*) setTargets:(id)target;
-(TableViewTools*) setOptRowHeights:(SEL)optRowHeight;
-(TableViewTools*) setOptRowNums:(SEL)optRowNum;
-(TableViewTools*) setOptCells:(SEL)optCell;

@end
