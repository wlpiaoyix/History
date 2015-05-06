//
//  SellFilterChangeViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellFilterViewController.h"

@interface SellFilterChangeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    SellFilterViewController * sellFilter;
    NSMutableArray * cellDataList;
    NSString *titlesimpleName;
}
-(void)setSellFilter:(SellFilterViewController *)filter;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *ValueForSelect;
@property (assign,nonatomic) int type;
@end

@interface DataInfoForCell : NSObject
@property (strong,nonatomic) NSNumber * idCode;
@property (strong,nonatomic) NSString * name;
@property (assign,nonatomic) bool selected;
@end