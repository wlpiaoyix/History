//
//  ManagerIndexViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/13.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ManagerIndexViewController.h"
#import "AdminManager.h"
#import "ConfigManage+Expand.h"
#import "UserEntity.h"
#import "LoginController.h"

@interface ManagerIndexViewController ()

@end

@implementation ManagerIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
}
-(void)initView{
    UserEntity* user=[ConfigManage getLoginUser];
    self.userName.text=user.userName;
    
    self.title=@"首页";
    self.scrollView.frame=[UIScreen mainScreen].bounds;
    CGRect frame =self.scrollView.frame;
    frame.size.height=frame.size.height-self.navigationController.toolbar.frameHeight;
    self.scrollView.frame=frame;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator =NO;
    self.scrollView.bounces=NO;
    
    //initProView
    self.phoneInView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(8, 247, 292, 20) backgroundImage:[[UIImage imageNamed:@"darkBlue.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.phoneInView.progress=0.0;
    //leftLabel
    self.phoneInView.left_nameLabel.frame=CGRectMake(10, 2, 30, 16);
    self.phoneInView.left_valueLabel.frame=CGRectMake(44, 2, 30, 16);
    //rightLabel
    self.phoneInView.right_valueLabel.frame=CGRectMake(self.phoneInView.frame.size.width-40, 2, 30, 16);
    self.phoneInView.right_nameLabel.frame=CGRectMake(self.phoneInView.frame.size.width-70, 2, 30, 16);

    [self.phoneInView configLabelWithLeftName:@"来电:" leftValue:@"0个" rightName:@"来访:" rightValue:@"0个" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    
    [self.scrollView addSubview:self.phoneInView];
    //=======
    self.sureBuyView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(8, 281, 292, 20) backgroundImage:[[UIImage imageNamed:@"darkBlue.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    self.sureBuyView.progress=0;
    //leftLabel
    self.sureBuyView.left_nameLabel.frame=CGRectMake(10, 2, 30, 16);
    self.sureBuyView.left_valueLabel.frame=CGRectMake(44, 2, 30, 16);
    //rightLabel
    self.sureBuyView.right_valueLabel.frame=CGRectMake(self.sureBuyView.frame.size.width-40, 2, 30, 16);
    self.sureBuyView.right_nameLabel.frame=CGRectMake(self.sureBuyView.frame.size.width-70, 2, 30, 16);
    
    [self.sureBuyView configLabelWithLeftName:@"认购:" leftValue:@"0套" rightName:@"签约:" rightValue:@"0套" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    
    [self.scrollView addSubview:self.sureBuyView];
    //======
    self.sureBuyCountView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(8, 315, 292, 20) backgroundImage:[[UIImage imageNamed:@"darkBlue.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    self.sureBuyCountView.progress=0;
    //leftLabel
    self.sureBuyCountView.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.sureBuyCountView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.sureBuyCountView.right_valueLabel.frame=CGRectMake(self.sureBuyCountView.frame.size.width-40, 2, 60, 16);
    self.sureBuyCountView.right_nameLabel.frame=CGRectMake(self.sureBuyCountView.frame.size.width-100, 2, 60, 16);
    
    [self.sureBuyCountView configLabelWithLeftName:@"认购金额:" leftValue:@"0万" rightName:@"签约金额:" rightValue:@"0万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:self.sureBuyCountView];
    //=======
    self.accountView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(8, 349, 292, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    self.accountView.progress=0;
    //leftLabel
    self.accountView.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.accountView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.accountView.right_valueLabel.frame=CGRectMake(self.accountView.frame.size.width-40, 2, 60, 16);
    self.accountView.right_nameLabel.frame=CGRectMake(self.accountView.frame.size.width-80, 2, 40, 16);
    
    [self.accountView configLabelWithLeftName:@"实收款:" leftValue:@"0万" rightName:@"应收款:" rightValue:@"0万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor blackColor]];
    [self.scrollView addSubview:self.accountView];
    //view
    self.mostSellView.frame=CGRectMake(8, self.accountView.frame.origin.y+40, [UIScreen mainScreen].bounds.size.width-16, 235);
    self.sellPlanView.frame=CGRectMake(8, self.mostSellView.frame.origin.y+self.mostSellView.frame.size.height+20, [UIScreen mainScreen].bounds.size.width-16, 180);
    //PlanProView
    self.forthSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(78, 54, 200, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"darkYelllow.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.forthSeasonView.progress=0.7;
    //leftLabel
    self.forthSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.forthSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.forthSeasonView.right_valueLabel.frame=CGRectMake(self.forthSeasonView.frame.size.width-40, 2, 60, 16);
    self.forthSeasonView.right_nameLabel.frame=CGRectMake(self.forthSeasonView.frame.size.width-70, 2, 30, 16);
    
    [self.forthSeasonView configLabelWithLeftName:@"实际完成:" leftValue:@"2万" rightName:@"计划:" rightValue:@"10万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.forthSeasonView];
    //=====
    self.thirdSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(78, 91, 200, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.thirdSeasonView.progress=0.2;
    //leftLabel
    self.thirdSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.thirdSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.thirdSeasonView.right_valueLabel.frame=CGRectMake(self.thirdSeasonView.frame.size.width-40, 2, 60, 16);
    self.thirdSeasonView.right_nameLabel.frame=CGRectMake(self.thirdSeasonView.frame.size.width-70, 2, 30, 16);
    
    [self.thirdSeasonView configLabelWithLeftName:@"实际完成:" leftValue:@"2万" rightName:@"计划:" rightValue:@"10万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.thirdSeasonView];
    //=====
    self.secondSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(78, 130, 200, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.secondSeasonView.progress=0.4;
    //leftLabel
    self.secondSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.secondSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.secondSeasonView.right_valueLabel.frame=CGRectMake(self.secondSeasonView.frame.size.width-40, 2, 60, 16);
    self.secondSeasonView.right_nameLabel.frame=CGRectMake(self.secondSeasonView.frame.size.width-70, 2, 30, 16);
    
    [self.secondSeasonView configLabelWithLeftName:@"实际完成:" leftValue:@"2万" rightName:@"计划:" rightValue:@"10万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.secondSeasonView];
    //config ScrollView ContentSize
    self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.sellPlanView.frameY+self.sellPlanView.frameHeight+80);
    
}
-(void)loadData{
    AdminManager* manager=[[AdminManager alloc]init];
    UserEntity* user=[ConfigManage getLoginUser];
    [manager queryManagerMainInfoWithObjectId:user.objectId startTime:@"2012-01-20" endTime:@"2015-02-20" success:^(id data, NSDictionary *userInfo) {
//        NSLog(@"data===%@",data);
        NSArray* datas=(NSArray*)data;
        NSDictionary* customer=[datas objectAtIndex:0];
        NSArray* customers=[customer objectForKey:@"LstArry"];
        // 来电  来访
        NSDictionary* phoneComeIn=[customers objectAtIndex:0];
        NSDictionary* interView=[customers objectAtIndex:1];
        [self.phoneInView configLabelWithLeftName:@"来电:" leftValue:[NSString stringWithFormat:@"%@个",[phoneComeIn objectForKey:@"ZD_ZDVAL"]] rightName:@"来访:" rightValue:[NSString stringWithFormat:@"%@个",[interView objectForKey:@"ZD_ZDVAL"]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
        if ([[interView objectForKey:@"ZD_ZDVAL"] isEqualToString:@"0"]) {
            self.phoneInView.progress=0.0;
        }else{
            CGFloat progress;
            progress= [[interView objectForKey:@"ZD_ZDVAL"] integerValue]/[[phoneComeIn objectForKey:@"ZD_ZDVAL"] integerValue];
            self.phoneInView.progress=progress;
        }
        
        //认购 签约
        NSDictionary* sureBuy=[customers objectAtIndex:2];
        NSDictionary* sign=[customers objectAtIndex:3];
        
        [self.sureBuyView configLabelWithLeftName:@"认购:" leftValue:[NSString stringWithFormat:@"%@套",[sureBuy objectForKey:@"ZD_ZDVAL"]] rightName:@"签约:" rightValue:[NSString stringWithFormat:@"%@套",[sign objectForKey:@"ZD_ZDVAL"]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
        if ([[sign objectForKey:@"ZD_ZDVAL"] isEqualToString:@"0"]) {
            self.sureBuyView.progress=0.0;
        }else{
            CGFloat progress;
            progress= [[sign objectForKey:@"ZD_ZDVAL"] integerValue]/[[sureBuy objectForKey:@"ZD_ZDVAL"] integerValue];
            self.sureBuyView.progress=progress;
        }
        
        //认购签约 金额
        NSDictionary* sureBuyCount=[customers objectAtIndex:4];
        NSDictionary* signCount=[customers objectAtIndex:5];
        [self.sureBuyCountView configLabelWithLeftName:@"认购金额:" leftValue:[NSString stringWithFormat:@"%@万",[sureBuyCount objectForKey:@"ZD_ZDVAL"]] rightName:@"签约金额:" rightValue:[NSString stringWithFormat:@"%@万",[signCount objectForKey:@"ZD_ZDVAL"]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
        
        
        if ([[signCount objectForKey:@"ZD_ZDVAL"] isEqualToString:@"0"]) {
            self.sureBuyCountView.progress=0.0;
        }else{
            CGFloat progress;
            progress= [[signCount objectForKey:@"ZD_ZDVAL"] integerValue]/[[sureBuyCount objectForKey:@"ZD_ZDVAL"] integerValue];
            self.sureBuyCountView.progress=progress;
        }
        //实收  应收
        NSDictionary* realCount=[customers objectAtIndex:6];
        NSDictionary* shouldCount=[customers objectAtIndex:7];
        [self.accountView configLabelWithLeftName:@"实收款:" leftValue:[NSString stringWithFormat:@"%@万",[realCount objectForKey:@"ZD_ZDVAL"]] rightName:@"应收款:" rightValue:[NSString stringWithFormat:@"%@万",[shouldCount objectForKey:@"ZD_ZDVAL"]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor blackColor]];
        
        if ([[shouldCount objectForKey:@"ZD_ZDVAL"] isEqualToString:@"0"]) {
            self.accountView.progress=0.0;
        }else{
            CGFloat progress;
            progress= [[shouldCount objectForKey:@"ZD_ZDVAL"] integerValue]/[[realCount objectForKey:@"ZD_ZDVAL"] integerValue];
            self.accountView.progress=progress;
        }
        //畅销户型  空数据暂时1！！！！！！！！！
//        NSDictionary* house=[datas objectAtIndex:1];
//        NSLog(@"house==%@",house);
//        NSLog(@"name==%@",[house objectForKey:@"ZD_ZDMC"]);
        //计划
        NSDictionary* plan=[datas objectAtIndex:3];
        NSArray* plans=[plan objectForKey:@"LstArry"];
        //四季度
        NSDictionary* four=[plans objectAtIndex:3];
        NSString* value_four=[four objectForKey:@"ZD_ZDVAL"];
        NSArray* values_four=[value_four componentsSeparatedByString:@"|"];
        [self.forthSeasonView configLabelWithLeftName:@"实际完成:" leftValue:[NSString stringWithFormat:@"%@万",[values_four firstObject]] rightName:@"计划:" rightValue:[NSString stringWithFormat:@"%@万",[values_four lastObject]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
        if ([[values_four lastObject] isEqualToString:@"0"]) {
             self.forthSeasonView.progress=0;
        }else{
            CGFloat progress;
            progress=[[values_four firstObject] integerValue]/[[values_four lastObject]integerValue];
            self.forthSeasonView.progress=progress;
        }
        //三季度
        NSDictionary* three=[plans objectAtIndex:2];
        NSString* value_three=[three objectForKey:@"ZD_ZDVAL"];
        NSArray* values_three=[value_three componentsSeparatedByString:@"|"];
        [self.thirdSeasonView configLabelWithLeftName:@"实际完成:" leftValue:[NSString stringWithFormat:@"%@万",[values_three firstObject]] rightName:@"计划:" rightValue:[NSString stringWithFormat:@"%@万",[values_three lastObject]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
        if ([[values_three lastObject] isEqualToString:@"0"]) {
            self.thirdSeasonView.progress=0;
        }else{
            CGFloat progress;
            progress=[[values_three firstObject] integerValue]/[[values_three lastObject]integerValue];
            self.thirdSeasonView.progress=progress;
        }
        //二季度
        NSDictionary* two=[plans objectAtIndex:1];
        NSString* value_two=[two objectForKey:@"ZD_ZDVAL"];
        NSArray* values_two=[value_two componentsSeparatedByString:@"|"];
        [self.secondSeasonView configLabelWithLeftName:@"实际完成:" leftValue:[NSString stringWithFormat:@"%@万",[values_two firstObject]] rightName:@"计划:" rightValue:[NSString stringWithFormat:@"%@万",[values_two lastObject]] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
        if ([[values_two lastObject] isEqualToString:@"0"]) {
            self.secondSeasonView.progress=0;
        }else{
            CGFloat progress;
            progress=[[values_two firstObject] integerValue]/[[values_two lastObject]integerValue];
            self.secondSeasonView.progress=progress;
        }

       
        
    } faild:^(id data, NSDictionary *userInfo) {
        
    }];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
