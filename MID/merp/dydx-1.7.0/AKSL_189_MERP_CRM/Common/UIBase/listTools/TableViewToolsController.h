//
//  TableViewToolsController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellTools.h"

@interface TableViewToolsController : UIViewController <UITableViewDelegate, UITableViewDataSource>
//==>只有在非自定义情况下有效
-(TableViewToolsController*) setCellBgcolors1:(UIColor*) color;
-(TableViewToolsController*) setCellBgcolors2:(UIColor*) color;
-(TableViewToolsController*) setRowHeights:(float) rowHeight;
-(TableViewToolsController*) setTextFont:(UIFont*) font;
-(TableViewToolsController*) setTextColors:(UIColor*) color;
//<==
-(TableViewToolsController*) setIsReLoadWithSelecteds:(bool) flag;
-(TableViewToolsController*) setOptSelectrows:(SEL) sel;
-(TableViewToolsController*) setDatas:(NSArray*) data;
-(TableViewToolsController*) setTargets:(id)target;
-(TableViewToolsController*) setOptRowHeights:(SEL)optRowHeight;
-(TableViewToolsController*) setOptRowNums:(SEL)optRowNum;
-(TableViewToolsController*) setOptCells:(SEL)optCell;
@end
