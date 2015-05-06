//
//  TableViewToolsController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "TableViewToolsController.h"

@interface TableViewToolsController ()
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

@implementation TableViewToolsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+(id) init{
    TableViewToolsController *tvt = [[TableViewToolsController alloc]initWithNibName:@"TableViewToolsController" bundle:nil];
    [tvt setRowHeights:21.0];
    [tvt setCellBgcolors1:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.1]];
    [tvt setCellBgcolors2:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.2]];
    [tvt setTextFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [tvt setTextColors:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.9]];
    return tvt;
}
-(TableViewToolsController*) setOptSelectrows:(SEL) sel{
    self.optSelectrow = sel;
    return self;
}
-(TableViewToolsController*) setIsReLoadWithSelecteds:(bool) flag{
    self.isReLoadWithSelected = flag;
    return self;
}
-(TableViewToolsController*) setTextColors:(UIColor*) color{
    self.textColor = color;
    return self;
}
-(TableViewToolsController*) setTextFont:(UIFont*) font{
    self.font = font;
    return self;
}
-(TableViewToolsController*) setCellBgcolors1:(UIColor*) color {
    self.cellBgcolor1 = color;
    return self;
}
-(TableViewToolsController*) setCellBgcolors2:(UIColor*) color {
    self.cellBgcolor2 = color;
    return self;
}
-(TableViewToolsController*) setRowHeights:(float) rowHeight{
    self.rowHeight = rowHeight;
    return self;
}
-(TableViewToolsController*) setDatas:(NSArray*) data{
    self.data = data;
    self.dataLength = self.data.count;
    self.rowNum = self.dataLength;
    return self;
}
-(TableViewToolsController*) setTargets:(id)target{
    self.target = target;
    return self;
}
-(TableViewToolsController*) setOptRowHeights:(SEL)optRowHeight{
    if(self.target){
        self.optRowHeight = optRowHeight;
    }
    return self;
}
-(TableViewToolsController*) setOptRowNums:(SEL)optRowNum{
    if(self.target){
        self.optRowNum = optRowNum;
    }
    return self;
}
-(TableViewToolsController*) setOptCells:(SEL)optCell{
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
    if(self.optSelectrow){
        [self.target performSelector:self.optSelectrow withObject:tableView withObject:indexPath];
    }
    if(self.isReLoadWithSelected){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
