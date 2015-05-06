//
//  MyScheduleDateTimeSetController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MyScheduleDateTimeSetController.h"
#import "NSDate+convenience.h"
@interface MyScheduleDateTimeSetController ()
@property (strong, nonatomic) IBOutlet UITextField *lableHour;
@property (strong, nonatomic) IBOutlet UITextField *lableMunite;
@property (strong, nonatomic) UIView *viewSetTimes;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerSetTimes;
@property int year;
@property int month;
@property int day;
@property int hour;
@property int minutes;

@end

@implementation MyScheduleDateTimeSetController

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
    VRGCalendarView * view = [[VRGCalendarView alloc]init];
    if(self.date){
        view.selectedDate = self.date;
        self.year = self.date.year;
        self.month = self.date.month;
        self.day = self.date.day;
        self.minutes = self.date.minute;
        self.hour = self.date.hour;
    }
    self.lableHour.enabled = self.lableMunite.enabled = NO;
    self.lableHour.text = [self parseIntToString:self.hour];
    self.lableMunite.text = [self parseIntToString:self.minutes];
    [view setFrame:CGRectMake(0, 42, 320, view.frame.size.height)];
    view.delegate = self;
    [view setNeedsDisplay];
    [self cornerRadius:self.viewDateTime];
    [self.view addSubview:view];
    
    self.viewSetTimes = [[UIView alloc]initWithFrame:CGRectMake(0, 0, COMMON_SCREEN_W, COMMON_SCREEN_H)];
    self.viewSetTimes.backgroundColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:0.5];
    self.viewSetTimes.opaque = NO;
    CGRect r =  self.pickerSetTimes.frame;
    r.origin.y = (self.viewSetTimes.frame.size.height-r.size.height)/2;
    r.origin.x = (self.viewSetTimes.frame.size.width-r.size.width)/2;
    self.pickerSetTimes.frame = r;
    [self.viewSetTimes addSubview:self.pickerSetTimes];
    self.pickerSetTimes.opaque = NO;
    arrayHours = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    arrayMunites = [[NSArray alloc]initWithObjects:
                @"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",
                @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                @"20",@"21",@"22",@"23", @"24", @"25", @"26", @"27", @"28", @"29",
                @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",
                @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",
                @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    [doubleTapGesture setNumberOfTapsRequired:1];
    [self.viewSetTimes addGestureRecognizer:doubleTapGesture];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    if(targetHeight!=self.viewSet.frame.origin.y){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.viewSet.frame;
            frame.origin.y = targetHeight;
            self.viewSet.frame = frame;
        }];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    self.year = date.year;
    self.month = date.month;
    self.day = date.day;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickConfirmDateTime:(id)sender {
    if(self.targets&&self.methods){
        NSString *resulte = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[self parseIntToString:self.year],
                             [self parseIntToString:self.month],
                             [self parseIntToString:self.day],
                             [self parseIntToString:self.hour],
                             [self parseIntToString:self.minutes]];
        [self.targets performSelector:self.methods withObject:resulte];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)toucheControll:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSetTime:(id)sender {
    int hour = self.lableHour.text.intValue;
    int minute = self.lableMunite.text.intValue;
    [self.pickerSetTimes selectRow:hour inComponent:0 animated:YES];
    [self.pickerSetTimes selectRow:minute inComponent:1 animated:YES];
    [self.view addSubview:self.viewSetTimes];
    
}
-(void) handleDoubleTap{
    [self.viewSetTimes removeFromSuperview];
}
-(NSString*) parseIntToString:(int) value{
    return value>9?[NSString stringWithFormat:@"%d",value]:[NSString stringWithFormat:@"0%d",value];
}
-(void) cornerRadius:(UIView*) tvt{
    tvt.layer.cornerRadius = 5;
    tvt.layer.masksToBounds = YES;
    tvt.layer.borderWidth = 0.5;
    tvt.layer.borderColor = [[UIColor colorWithRed:0.580 green:0.784 blue:0.200 alpha:1]CGColor];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UIView *v=[[UIView alloc]
               initWithFrame:CGRectMake(0,0,
                                        [self pickerView:pickerView widthForComponent:component],
                                        [self pickerView:pickerView rowHeightForComponent:component])];
	[v setOpaque:TRUE];
	[v setBackgroundColor:[UIColor whiteColor]];
	UILabel *lbl=nil;
    lbl= [[UILabel alloc]
          initWithFrame:CGRectMake(8,0,
                                   [self pickerView:pickerView widthForComponent:component]-16,
                                   [self pickerView:pickerView rowHeightForComponent:component])];
	[lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
	NSString *ret=@"";
	switch (component) {
		case 0:
			ret=[arrayHours objectAtIndex:row];
            if (row<6) {
            } else if (row<12) {
                [v setBackgroundColor:[UIColor colorWithRed:0.510 green:0.914 blue:0.286 alpha:1]];
            } else if (row<15){
                [v setBackgroundColor:[UIColor colorWithRed:0.788 green:0.118 blue:0.314 alpha:1]];
            }else if(row<21){
                [v setBackgroundColor:[UIColor colorWithRed:0.898 green:0.667 blue:0.161 alpha:1]];
            }else{
            }
			break;
		case 1:
            ret=[arrayMunites objectAtIndex:row];
			break;
	}
	[lbl setText:ret];
	[lbl setFont:[UIFont boldSystemFontOfSize:18]];
	[v addSubview:lbl];
	return v;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.lableHour.text = arrayHours[row];
            self.hour = row;
            break;
        case 1:
            self.lableMunite.text = arrayMunites[row];
            self.minutes = row;
            break;
        default:
            break;
    }
    NSLog(@"%d==%d",component,row);
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	float ret=70;
	switch (component) {
		case 0:
			ret=70;
			break;
		default:
			break;
	}
	return ret;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return arrayHours.count;
		case 1:
			return arrayMunites.count;
		default:
			return 1;
	}
}
@end
