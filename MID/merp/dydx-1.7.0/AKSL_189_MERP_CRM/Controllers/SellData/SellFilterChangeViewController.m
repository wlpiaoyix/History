//
//  SellFilterChangeViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SellFilterChangeViewController.h"
#import "DataSelectedCell.h"

@interface SellFilterChangeViewController ()

@end
@implementation DataInfoForCell

@end
@implementation SellFilterChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setSellFilter:(SellFilterViewController *)filter{
    sellFilter = filter;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    cellDataList = [NSMutableArray new];
    NSString *value;
    NSString *name;
    switch (_type) {
        case 1:
            _titleText.text = @"选择区域";
            value = DISTRICT_INFO_KEY;
            name = @"areasName";
            titlesimpleName = @"区域";
            break;
        case 2:
            _titleText.text =@"选择产品";
            value = PRODUCTS_INFO_KEY;
            name = @"productsName";
             titlesimpleName = @"产品";
            break;
        case 3:
            _titleText.text = @"选择厅店类型";
            value = STORETYPE_INFO_KEY;
            name = @"hallTypeNames";
            titlesimpleName =@"厅店类型";
            break;
    }
    NSArray * data;
    if (![_ValueForSelect isEqualToString:@"/all"]) {
        _ValueForSelect = [[_ValueForSelect substringFromIndex:2]substringToIndex:_ValueForSelect.length-3];
         data = [_ValueForSelect componentsSeparatedByString:@","];
    }
        // value
    NSArray * temp ;//= [[ConfigManage getConfig:value] JSONValue];
    if (_type == 2) {
        temp = [[[ConfigManage getConfig:value] JSONValueNewMy] objectForKey:@"data"];
    }else{
        temp = [[ConfigManage getConfig:value] JSONValueNewMy];
    }
        for (int i=0; i<temp.count; i++) {
            DataInfoForCell * cell = [DataInfoForCell new];
            NSDictionary *dic = [temp objectAtIndex:i];
            cell.idCode = [dic objectForKey:@"id"];
            cell.name = [dic objectForKey:name];
            cell.selected = NO;
            if(data){
            for (int j=0; j<data.count; j++) {
                NSNumber * ids = cell.idCode;
                if (ids && [ids intValue] == [[data objectAtIndex:j] intValue]){
                    cell.selected = YES;
                    break;
                }
            }
            }else{
            cell.selected = YES;
            }
            [cellDataList addObject:cell];
        }
    

    UINib *nib = [UINib nibWithNibName:@"DataSelectedCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"DataSelectedCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if(cellDataList)
       return cellDataList.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataSelectedCell"];
    if(cell){
        DataInfoForCell *info = (DataInfoForCell *)[cellDataList objectAtIndex:indexPath.row];
        cell.lableForName.text =info.name;
        [cell.selectedSwitch setOn:info.selected animated:NO];
        cell.selectedSwitch.tag = [info.idCode intValue];
        [cell.selectedSwitch addTarget:self action:@selector(DataChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
    
}
-(void)DataChangeValue:(id)sender{
   UISwitch * switch1 = sender;
    int idcode = switch1.tag;
    NSString * returnValue = @"/,";
    for (int i=0; i<cellDataList.count; i++) {
         DataInfoForCell *info = (DataInfoForCell *)[cellDataList objectAtIndex:i];
        if (idcode == [info.idCode intValue]) {
            info.selected = switch1.on;
        }
        if(info.selected)
        returnValue =[NSString stringWithFormat:@"%@%d,",returnValue,[info.idCode intValue]];
    }
    if ([returnValue isEqualToString:@"/,"]) {
        NSString * msg = [NSString stringWithFormat:@"必须选择一个或多个%@",titlesimpleName];
        showMessageBox(msg);
        [switch1 setOn:YES animated:NO];
        for (int i=0; i<cellDataList.count; i++) {
            DataInfoForCell *info = (DataInfoForCell *)[cellDataList objectAtIndex:i];
            if (idcode == [info.idCode intValue]) {
                info.selected = YES;
            }
        }
    }else{
    [sellFilter setData:returnValue Type:_type];
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
