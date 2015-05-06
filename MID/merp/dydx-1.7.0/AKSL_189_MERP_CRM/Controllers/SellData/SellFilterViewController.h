//
//  SellFilterViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-13.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellFilterViewController : UIViewController{
    NSString *valueforStore;
    NSString *valuefroProducts;
    NSString *valueforDic;
    bool isChange;
}
- (IBAction)goSelectPage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *filterStore;
@property (weak, nonatomic) IBOutlet UILabel *filterProducts;
@property (weak, nonatomic) IBOutlet UILabel *filterDis;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateSelect;
-(void)setData:(NSString *)value Type:(int)type;
@end
