//
//  SystemSetsAlertCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsAlertCell.h"
@interface SystemSetsAlertCell()
@property (strong, nonatomic) IBOutlet UISwitch *swtichAlert;
@property bool isNO;
@end
@implementation SystemSetsAlertCell
+(id)init{
    SystemSetsAlertCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsAlertCell" owner:self options:nil] lastObject];
    return ssc;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setIsNo:(bool) isNo{
    [self.swtichAlert setOn:isNo animated:YES];
    self.isNO = isNo;
}

- (IBAction)valueChanges:(id)sender {
    switch ([self.indexPath row]) {
        case 0:
            if(self.isNO){
                NSLog(@"=========================声音关闭");
            }else{
                NSLog(@"=========================声音开启");
            }
            break;
        case 1:
            if(self.isNO){
                NSLog(@"=========================振动关闭");
            }else{
                NSLog(@"=========================振动开启");
            }
            break;
            
        default:
            break;
    }
}
@end
