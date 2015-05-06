//
//  SellFilterViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-13.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SellFilterViewController.h"
#import "NSString+Convenience.h"
#import "SellFilterChangeViewController.h"

@interface SellFilterViewController ()

@end

@implementation SellFilterViewController
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)commitData:(id)sender {
    if (isChange) {
        [ConfigManage setConfig:STORETYPE_INFO_SELECT_KEY Value:valueforStore];
        [ConfigManage setConfig:PRODUCTS_INFO_SELECT_KEY Value:valuefroProducts];
        [ConfigManage setConfig:DISTRICT_INFO_SELECT_KEY Value:valueforDic];
         NSString * value = _dateSelect.selectedSegmentIndex?@"/week":@"/year";
        [ConfigManage setConfig:DATE_SELECT_KEY Value:value];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString * value ;
    value =valueforDic;
    if ([value isEqualToString:@"/all"]) {
        _filterDis.text = @"全部";
    }else{
        value = [[value substringFromIndex:2]substringToIndex:value.length-3];
        NSArray * data = [value componentsSeparatedByString:@","];
       // value
        NSArray * temp = [[ConfigManage getConfig:DISTRICT_INFO_KEY] JSONValueNewMy];
        _filterDis.text = @"";
        for (int i=0; i<temp.count; i++) {
            NSDictionary *dic = [temp objectAtIndex:i];
            for (int j=0; j<data.count; j++) {
                NSNumber * ids =  [dic objectForKey:@"id"];
                if (ids && [ids intValue] == [[data objectAtIndex:j] intValue]){
                    _filterDis.text = [[_filterDis.text stringByAppendingString:[dic objectForKey:@"areasName"]]stringByAppendingString:@","];
                    break;
                }
            }
        }
    }
    
    value = valuefroProducts;
    if ([value isEqualToString:@"/all"]) {
        _filterProducts.text = @"全部";
    }else{
        value = [[value substringFromIndex:2]substringToIndex:value.length-3];
        NSArray * data = [value componentsSeparatedByString:@","];
        NSArray * temp = [[[ConfigManage getConfig:PRODUCTS_INFO_KEY] JSONValueNewMy]objectForKey:@"data"];
        _filterProducts.text = @"";
        for (int i=0; i<temp.count; i++) {
            NSDictionary *dic = [temp objectAtIndex:i];
            for (int j=0; j<data.count; j++) {
                NSNumber * ids =  [dic objectForKey:@"id"];
                if (ids && [ids intValue] == [[data objectAtIndex:j] intValue]){
                    _filterProducts.text = [[_filterProducts.text stringByAppendingString:[dic objectForKey:@"productsName"]]stringByAppendingString:@","];
                    break;
                }
            }
        }
    }

    value = valueforStore;
    if ([value isEqualToString:@"/all"]) {
        _filterStore.text = @"全部";
    }else{
        value = [[value substringFromIndex:2]substringToIndex:value.length-3];
        NSArray * data = [value componentsSeparatedByString:@","];
        NSArray * temp = [[ConfigManage getConfig:STORETYPE_INFO_KEY] JSONValueNewMy];
        _filterStore.text = @"";
        for (int i=0; i<temp.count; i++) {
            NSDictionary *dic = [temp objectAtIndex:i];
            for (int j=0; j<data.count; j++) {
                NSNumber * ids =  [dic objectForKey:@"id"];
                if (ids && [ids intValue] == [[data objectAtIndex:j] intValue]){
                    _filterStore.text = [[_filterStore.text stringByAppendingString:[dic objectForKey:@"hallTypeNames"]]stringByAppendingString:@","];
                    break;
                }
            }
        }
    }

}
- (IBAction)dateSelectChanged:(id)sender {
    isChange = YES;
}
 
-(void)setData:(NSString *)value Type:(int)type{
    isChange = YES;
    switch (type) {
        case 1:
            valueforDic = value;
            break;
            case 2:
            valuefroProducts = value;
            break;
        case 3:
            valueforStore = value;
            break;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString * value = [ConfigManage getConfig:DATE_SELECT_KEY];
    if ([value isEqualToString:@"/year"]) {
        [_dateSelect setSelectedSegmentIndex:0];
    }else if([value isEqualToString:@"/week"]){
        [_dateSelect setSelectedSegmentIndex:1];
    }
    valueforStore =[ConfigManage getConfig:STORETYPE_INFO_SELECT_KEY];
    valuefroProducts =[ConfigManage getConfig:PRODUCTS_INFO_SELECT_KEY];
    valueforDic = [ConfigManage getConfig:DISTRICT_INFO_SELECT_KEY];
    isChange = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goSelectPage:(id)sender {
    SellFilterChangeViewController * view = [[SellFilterChangeViewController alloc]initWithNibName:@"SellFilterChangeViewController" bundle:nil];
    view.type = ((UIButton *)sender).tag;
    switch (view.type) {
        case 1:
            view.ValueForSelect = valueforDic;
            break;
        case 2:
            view.ValueForSelect = valuefroProducts;
            break;
        case 3:
            view.ValueForSelect = valueforStore;
            break;
    }
    [view setSellFilter:self];
    [self.navigationController pushViewController:view animated:YES];
}
@end
