//
//  CTM_ViewContentController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 3/20/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import "CTM_ViewContentController.h"
#import "EntityManagerAddressBook.h"
#import "CTM_AddContentController.h"
#import "UIRecordPhoneViewCell.h"
#import "EMAsyncImageView.h"
#import "EntityUser.h"
#import "EntityPhone.h"
#import "Enum_PhoneType.h"
#import "UIRecordPhoneHeadView.h"
@interface CTM_ViewContentController (){
    IBOutlet UIButton *buttonReturn;
    IBOutlet UIButton *buttonEdit;
    
    IBOutlet EMAsyncImageView *imageBg;
    IBOutlet UILabel *lableName;
    IBOutlet UITableView *tableViewDetail;

@private
    EntityUser *userx;
    EntityManagerAddressBook *emab;
    NSMutableArray *arrayDatas;
}

@end

@implementation CTM_ViewContentController
+(id) getNewInstance{
    CTM_ViewContentController *vcc = [[CTM_ViewContentController alloc] initWithNibName:@"CTM_ViewContentController" bundle:nil];
    vcc->emab = COMMON_EMAB;
    vcc->arrayDatas = [NSMutableArray new];
    return vcc;
}
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
    if(userx&&userx.userKey){
        UINib *nib = [UINib nibWithNibName:@"UIRecordPhoneViewCell" bundle:nil];
        [tableViewDetail registerNib:nib forCellReuseIdentifier:@"UIRecordPhoneViewCell"];
        tableViewDetail.showsHorizontalScrollIndicator = NO;
        tableViewDetail.showsVerticalScrollIndicator = NO;
        tableViewDetail.delegate = self;
        tableViewDetail.dataSource = self;
        
        imageBg.image = [emab findImageBgByRef:userx.userKey];
        lableName.text = [NSString isEnabled:userx.userName]?userx.userName:@"未知";
        [buttonEdit addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
        [buttonReturn addTarget:self action:@selector(clickRetrun:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//==>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int countRpvArrayx = [((NSArray*)arrayDatas[section]) count];
    return countRpvArrayx;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    int section = [indexPath section];
    UIRecordPhoneViewCell *rpc  = [tableView dequeueReusableCellWithIdentifier:@"UIRecordPhoneViewCell"];
    NSString *title = @"";
    NSString *context = @"";
    bool isCall = false;
    switch (section) {
        case 0:
        {
            EntityPhone *ep = ((NSArray*)(arrayDatas[0]))[row];
            title = [Enum_PhoneType nameByEnum:ep.type.intValue];
            context = ep.phoneNum;
            isCall = true;
        }
            break;
        default:
        {
            NSDictionary *json = ((NSArray*)(arrayDatas[[arrayDatas count]-1]))[row];
            title = [json objectForKey:@"lable"];
            context = [json objectForKey:@"value"];
        }
            break;
    }
    [rpc setTitle:title Name:context flag:isCall];
    return rpc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [arrayDatas count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section==0?@"联系方式":@"个人信息";
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIRecordPhoneHeadView  *rphv = [UIRecordPhoneHeadView getNewInstance];
    [self setCornerRadiusAndBorder:rphv CornerRadius:0];
    [rphv setHeadText:section==0?@"联系方式":@"个人信息"];
    rphv.backgroundColor = [UIColor colorWithRed:0.114 green:0.463 blue:0.784 alpha:0.7];
    return rphv;
}
//<==


-(void)setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius{
    [self setCornerRadiusAndBorder:view CornerRadius:cornerRadius BorderWidth:0.5 BorderColor:[[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor]];
}
-(void)setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius BorderWidth:(float) borderWidth BorderColor:(CGColorRef) borderColor{
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    [view setClipsToBounds:YES];
    if(borderColor)view.layer.borderColor = borderColor;
}

-(void) clickRetrun:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) clickEdit:(id) sender{
    CTM_AddContentController *acc = [CTM_AddContentController getNewInstance];
    [acc setEntityUser:userx];
    [self.navigationController pushViewController:acc animated:NO];
}
-(void) setEntityUser:(id) user{
    self->userx = user;
    if(!userx.telephones) userx.telephones = [NSMutableArray new];
    [arrayDatas addObject:userx.telephones];
    if(userx.jsonInfo)[arrayDatas addObject:userx.jsonInfo];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
