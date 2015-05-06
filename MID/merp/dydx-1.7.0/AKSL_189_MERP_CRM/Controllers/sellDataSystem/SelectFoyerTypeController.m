//
//  SelectFoyerTypeController.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SelectFoyerTypeController.h"
#import "DataSelectedCell.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "SwitchSelected.h"
@interface SelectFoyerTypeController ()
@property bool nibsRegistered;
@property bool isSelectedChange;
@property (strong, nonatomic) NSMutableArray *jsonData;
@property (strong, nonatomic) NSMutableArray *values;
@property (strong, nonatomic) IBOutlet UILabel *lableHeadName;
@property (strong, nonatomic) IBOutlet UITableView *tableViewData;
@property (strong, nonatomic) IBOutlet UISwitch *switchAll;
@end
@implementation SelectFoyerTypeController
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
    _jsonData = [[NSMutableArray alloc]init];
    [_switchAll setOn:NO];
    if(_ifSingleSelected){
        [_switchAll setHidden:true];
        CGRect r = _tableViewData.frame;
        CGRect r2 = _switchAll.frame;
        r.origin.y -=r2.size.height+18;
        r.size.height+= r2.size.height+18;
        _tableViewData.frame = r;
    }
    _values = [[NSMutableArray alloc]init];
    if([NSString isEnabled:_titleName])self.lableHeadName.text = _titleName;
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_jsonData removeAllObjects];
    [_jsonData addObjectsFromArray:_catachData];
    [_tableViewData reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_jsonData count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"DataSelectedCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"DataSelectedCell"];
        self.nibsRegistered = YES;
    }
    SwitchSelected *json = [_jsonData objectAtIndex:[indexPath row]];
    DataSelectedCell *tvc  = [tableView dequeueReusableCellWithIdentifier:@"DataSelectedCell"];
    tvc.lableForName.text = json.value;
    tvc.selectedSwitch.tag = [indexPath row];
    tvc.tag = 19900+[indexPath row];
    [tvc.selectedSwitch addTarget:self action:@selector(DataChangeValue:) forControlEvents:UIControlEventValueChanged];
    if(json.isSelected){
        [tvc.selectedSwitch setOn:YES animated:NO];
    }else{
       [tvc.selectedSwitch setOn:NO animated:NO];
    }
    return tvc;
}

- (IBAction)switchAllSelected:(id)sender {
    _isSelectedChange = true;
    //19900
    UISwitch *temp1 = (UISwitch*)sender;
    if(temp1.on){
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (SwitchSelected *ss in _jsonData) {
            ss.isSelected = true;
            [temp addObject:ss];
        }
        [_jsonData removeAllObjects];
        [_jsonData addObjectsFromArray:temp];
    }else{
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (SwitchSelected *ss in _jsonData) {
            ss.isSelected = false;
            [temp addObject:ss];
        }
        [_jsonData removeAllObjects];
        [_jsonData addObjectsFromArray:temp];
    }
    [_tableViewData reloadData];
}
-(void)DataChangeValue:(id)sender{
    _isSelectedChange = true;
    UISwitch * switch1 = sender;
    if(!switch1.on){
        int i = 0;
        for (SwitchSelected *ss in _jsonData) {
            if(ss.isSelected){
                i++;
            }
        }
        if(i<2&&(_catachData&&[_catachData count]>0)){
            [switch1 setOn:YES animated:YES];
            showMessageBox(@"请至少选择一条数据!");
            return;
        }
    }
    int index = 0;
    DataSelectedCell *temp2 = (DataSelectedCell*)[self.view viewWithTag:19900+index];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (SwitchSelected *ss in _jsonData) {
        @try {
            if(switch1.tag==temp2.tag-19900){
                ss.isSelected = switch1.on;
                continue;
            }
            //==>如果是單選
            if(_ifSingleSelected){
                [temp2.selectedSwitch setOn:NO];
                ss.isSelected = false;
            }
        }
        @finally {
            ++index;
            temp2 = (DataSelectedCell*)[self.view viewWithTag:19900+index];
            [temp addObject:ss];
        }
    }
    [_jsonData removeAllObjects];
    [_jsonData addObjectsFromArray:temp];
    if(_switchAll.on){[_switchAll setOn:NO animated:YES];}
}

-(void) setRetureMethods:(RetureMethod) returnMethod{
    _returnMethod = returnMethod;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (IBAction)touchBack:(id)sender {
    [_values removeAllObjects];
    for (SwitchSelected *ss in _jsonData) {
        if(ss.isSelected){
            [_values addObject:ss];
        }
    }
    if((!_values||[_values count]==0)&&(_catachData&&[_catachData count]>0)){
        showMessageBox(@"请至少选择一条数据!");
        return;
    }
    if(_returnMethod&&_isSelectedChange){
        id temp4 = _values;
        _returnMethod(temp4);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
