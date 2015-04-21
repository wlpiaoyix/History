//
//  customerIndexViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/20.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "customerIndexViewController.h"
#import "MyUpComingViewController.h"
#import "CustomerBirthdayDetailViewController.h"
#import "CLTree.h"
#import "CustomerMainManager.h"
#import "LableEntity.h"


@interface customerIndexViewController ()
@property(nonatomic,strong)MCProgressBarView* finishedCount_houses;
@property(nonatomic,strong)MCProgressBarView* finishedCount_money;
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组
//注入数据
@property(nonatomic,strong) CLTreeView_LEVEL1_Model* upComingCount;
@property(nonatomic,strong)CLTreeView_LEVEL1_Model* customerCount;
@property(nonatomic,strong)CLTreeView_LEVEL1_Model* tradeDoneCount;
@property(nonatomic,strong)CLTreeView_LEVEL1_Model* financeCount;

@property(nonatomic,strong)CLTreeView_LEVEL2_Model*customerCount_2;
@property(nonatomic,strong)CLTreeView_LEVEL2_Model*tradeDoneCount_2;
@property(nonatomic,strong)CLTreeView_LEVEL2_Model*financeCount_2;



@end

@implementation customerIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self addTestData];//添加演示数据
    [self reloadDataForDisplayArray];//初始化将要显示的数据
    [self loadData];
    
}
-(void)loadData{
    UserEntity* user=[ConfigManage getLoginUser];
    self.lb_userName.text=user.userName;

    
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:01];
    [comp setDay:01];
    [comp setYear:2014];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate = [myCal dateFromComponents:comp];
    [comp setMonth:11];
    [comp setDay:01];
    [comp setYear:2014];
    NSDate *endDate = [myCal dateFromComponents:comp];
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"yyyy-mm-dd"];
    
    [manager mainForCustomerWithStartTime:startDate endTime:endDate objectId:user.objectId success:^(id data, NSDictionary *userInfo) {
        NSLog(@"user===%@",data);
        NSArray* arr=(NSArray*)data;
        
        for (LableEntity* label in arr) {
            NSArray* subs=label.subLables;
//            NSLog(@"name===%@,value===%@",label.name,label.value);
            if ([label.name isEqualToString:@"待办事宜"]) {
                self.upComingCount.sonCnt=label.value;
                
            }
            if ([label.name isEqualToString:@"客户"]) {
                self.customerCount.sonCnt=label.value;
                
                LableEntity* subLabel1=[subs objectAtIndex:0];
                self.customerCount_2.firstLb=subLabel1.name;
                self.customerCount_2.firstLbCount=subLabel1.value;
                
                LableEntity* subLabel2=[subs objectAtIndex:1];
                self.customerCount_2.secondLb=subLabel2.name;
                self.customerCount_2.secondLbCount=subLabel2.value;
                
                LableEntity* subLabel3=[subs objectAtIndex:2];
                self.customerCount_2.thirdLb=subLabel3.name;
                self.customerCount_2.thirdLbCount=subLabel3.value;
                LableEntity* subLabel4=[subs objectAtIndex:3];
                self.customerCount_2.forthLb=subLabel4.name;
                self.customerCount_2.forthLbCount=subLabel4.value;
                
            }
            if ([label.name isEqualToString:@"成交"]) {
                self.tradeDoneCount.sonCnt=label.value;
                
                LableEntity* subLabel1=[subs objectAtIndex:0];
                self.tradeDoneCount_2.firstLb=subLabel1.name;
                self.tradeDoneCount_2.firstLbCount=subLabel1.value;
                
                LableEntity* subLabel2=[subs objectAtIndex:1];
                self.tradeDoneCount_2.secondLb=subLabel2.name;
                self.tradeDoneCount_2.secondLbCount=subLabel2.value;
                
                LableEntity* subLabel3=[subs objectAtIndex:2];
                self.tradeDoneCount_2.thirdLb=subLabel3.name;
                self.tradeDoneCount_2.thirdLbCount=subLabel3.value;
                LableEntity* subLabel4=[subs objectAtIndex:3];
                self.tradeDoneCount_2.forthLb=subLabel4.name;
                self.tradeDoneCount_2.forthLbCount=subLabel4.value;

            }
            if ([label.name isEqualToString:@"款项"]) {
                self.financeCount.sonCnt=label.value;
                
                LableEntity* subLabel1=[subs objectAtIndex:0];
                self.financeCount_2.firstLb=subLabel1.name;
                self.financeCount_2.firstLbCount=subLabel1.value;
                
                LableEntity* subLabel2=[subs objectAtIndex:1];
                self.financeCount_2.secondLb=subLabel2.name;
                self.financeCount_2.secondLbCount=subLabel2.value;
                
                LableEntity* subLabel3=[subs objectAtIndex:2];
                self.financeCount_2.thirdLb=subLabel3.name;
                self.financeCount_2.thirdLbCount=subLabel3.value;
                LableEntity* subLabel4=[subs objectAtIndex:3];
                self.financeCount_2.forthLb=subLabel4.name;
                self.financeCount_2.forthLbCount=subLabel4.value;

            }
        }
        [self.tableView reloadData];
        
    } faild:^(id data, NSDictionary *userInfo) {
        
    }];
}
-(void)initView{
    self.scrollView.frame=[UIScreen mainScreen].bounds;
    CGRect frame =self.scrollView.frame;
    frame.size.height=frame.size.height-self.navigationController.toolbar.frameHeight;
    self.scrollView.frame=frame;
    if ([UIScreen mainScreen].bounds.size.height>480.0) {
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.sellPlanView.frameY+self.sellPlanView.frameHeight*2);
    }else{
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.sellPlanView.frameY+self.sellPlanView.frameHeight*2+80);
    }
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator =NO;
    self.scrollView.bounces=NO;
    //progressView
    self.finishedCount_houses=[[MCProgressBarView alloc]initWithFrame:CGRectMake(40, 40, 240, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"darkYelllow.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.finishedCount_houses.progress=0.5;
    //leftLabel
    self.finishedCount_houses.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.finishedCount_houses.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.finishedCount_houses.right_valueLabel.frame=CGRectMake(self.finishedCount_houses.frame.size.width-40, 2, 30, 16);
    self.finishedCount_houses.right_nameLabel.frame=CGRectMake(self.finishedCount_houses.frame.size.width-100, 2, 60, 16);
    
    [self.finishedCount_houses configLabelWithLeftName:@"实际完成" leftValue:@"3套" rightName:@"计划完成" rightValue:@"3套" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.finishedCount_houses];
    //==========================
    self.finishedCount_money=[[MCProgressBarView alloc]initWithFrame:CGRectMake(40, 80, 240, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"darkYelllow.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.finishedCount_money.progress=0.5;
    //leftLabel
    self.finishedCount_money.left_nameLabel.frame=CGRectMake(10, 2, 60, 16);
    self.finishedCount_money.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.finishedCount_money.right_valueLabel.frame=CGRectMake(self.finishedCount_money.frame.size.width-40, 2, 30, 16);
    self.finishedCount_money.right_nameLabel.frame=CGRectMake(self.finishedCount_money.frame.size.width-100, 2, 60, 16);
    
    [self.finishedCount_money configLabelWithLeftName:@"实际完成" leftValue:@"3万" rightName:@"计划完成" rightValue:@"3万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.finishedCount_money];

}
-(void)showUpComingWorkDetails{
    MyUpComingViewController* vc=[[MyUpComingViewController alloc]init];
    vc.totalCount=self.upComingCount.sonCnt;
    vc.title=@"待办事宜";
    [self.navigationController pushViewController:vc animated:YES];

}
-(void) addTestData{
    CLTreeViewNode *node3 = [[CLTreeViewNode alloc]init];
    node3.nodeLevel = 0;//根层cell
    node3.type = 1;//type 1的cell
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;//关闭状态
    self.upComingCount =[[CLTreeView_LEVEL1_Model alloc]init];
     self.upComingCount.name = @"待办事宜:";
     self.upComingCount.sonCnt = @"0";
     self.upComingCount.headImgPath=@"image_upcomingwork.png";
     self.upComingCount.arrowPath=@"right_arrow_blue.png";
    node3.nodeData =  self.upComingCount;
    
    CLTreeViewNode *node4 = [[CLTreeViewNode alloc]init];
    node4.nodeLevel = 0;
    node4.type = 1;
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;
    self.customerCount=[[CLTreeView_LEVEL1_Model alloc]init];
    self.customerCount.name = @"客户：";
    self.customerCount.sonCnt = @"0";
    self.customerCount.headImgPath=@"image_customer_icon.png";
    self.customerCount.arrowPath=@"button_arrow_down.png";
    node4.nodeData = self.customerCount;
    
    
    CLTreeViewNode *nodeDone = [[CLTreeViewNode alloc]init];
    nodeDone.nodeLevel = 0;
    nodeDone.type = 1;
    nodeDone.sonNodes = nil;
    nodeDone.isExpanded = FALSE;
    self.tradeDoneCount =[[CLTreeView_LEVEL1_Model alloc]init];
    self.tradeDoneCount.name = @"成交：";
    self.tradeDoneCount.sonCnt = @"0";
    self.tradeDoneCount.headImgPath=@"image_deal.png";
    self.tradeDoneCount.arrowPath=@"button_arrow_down.png";
    nodeDone.nodeData = self.tradeDoneCount;
    
    CLTreeViewNode *nodeCount = [[CLTreeViewNode alloc]init];
    nodeCount.nodeLevel = 0;
    nodeCount.type = 1;
    nodeCount.sonNodes = nil;
    nodeCount.isExpanded = FALSE;
    self.financeCount =[[CLTreeView_LEVEL1_Model alloc]init];
    self.financeCount.name = @"款项：";
    self.financeCount.sonCnt = @"0";
    self.financeCount.headImgPath=@"image_funds.png";
    self.financeCount.arrowPath=@"button_arrow_down.png";
    nodeCount.nodeData = self.financeCount;
    
    
    
    
    CLTreeViewNode *node5 = [[CLTreeViewNode alloc]init];
    node5.nodeLevel = 1;//第一层节点
    node5.type = 2;//type 2的cell
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;
    self.customerCount_2=[[CLTreeView_LEVEL2_Model alloc]init];
    self.customerCount_2.dateFrom=@"2015-01-12";
    self.customerCount_2.dateTo=@"2015-01-24";
    self.customerCount_2.firstLb=@"来电客户";
    self.customerCount_2.secondLb=@"来访客户";
    self.customerCount_2.thirdLb=@"来电转来访率";
    self.customerCount_2.forthLb=@"来访转成交率";
    self.customerCount_2.firstLbCount=@"0%";
    self.customerCount_2.secondLbCount=@"0%";
    self.customerCount_2.thirdLbCount=@"0";
    self.customerCount_2.forthLbCount=@"0";
    node5.nodeData = self.customerCount_2;
    
    CLTreeViewNode *node6 = [[CLTreeViewNode alloc]init];
    node6.nodeLevel = 1;
    node6.type = 2;
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;
    self.tradeDoneCount_2 =[[CLTreeView_LEVEL2_Model alloc]init];
    self.tradeDoneCount_2 .dateFrom=@"2015-01-12";
    self.tradeDoneCount_2 .dateTo=@"2015-01-24";
    self.tradeDoneCount_2 .firstLb=@"认购未转";
    self.tradeDoneCount_2 .secondLb=@"总签约";
    self.tradeDoneCount_2 .thirdLb=@"转签率";
    self.tradeDoneCount_2 .forthLb=@"已备案数";
    self.tradeDoneCount_2 .firstLbCount=@"0";
    self.tradeDoneCount_2 .secondLbCount=@"0";
    self.tradeDoneCount_2 .thirdLbCount=@"0%";
    self.tradeDoneCount_2 .forthLbCount=@"0%";
    node6.nodeData = self.tradeDoneCount_2 ;
    
    CLTreeViewNode *node7 = [[CLTreeViewNode alloc]init];
    node7.nodeLevel = 1;
    node7.type = 2;
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;
    self.financeCount_2 =[[CLTreeView_LEVEL2_Model alloc]init];
    self.financeCount_2.dateFrom=@"2015-01-12";
    self.financeCount_2.dateTo=@"2015-01-24";
    self.financeCount_2.firstLb=@"成交";
    self.financeCount_2.secondLb=@"成交";
    self.financeCount_2.thirdLb=@"成交";
    self.financeCount_2.forthLb=@"成交";
    self.financeCount_2.firstLbCount=@"0";
    self.financeCount_2.secondLbCount=@"0";
    self.financeCount_2.thirdLbCount=@"0%";
    self.financeCount_2.forthLbCount=@"0%";
    node7.nodeData = self.financeCount_2;
    
    
    node3.sonNodes = [NSMutableArray arrayWithObjects:nil];//插入子节点
    node4.sonNodes = [NSMutableArray arrayWithObjects:node5,nil];
    nodeDone.sonNodes=[NSMutableArray arrayWithObjects:node6, nil];
    nodeCount.sonNodes=[NSMutableArray arrayWithObjects:node7, nil];
    
    _dataArray = [NSMutableArray arrayWithObjects:node3,node4, nodeDone,nodeCount,nil];//插入到元数据数组
}

#pragma tableViewDegelate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayArray.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    else{//类型为2的cell
        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
}
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
    if(node.type == 0){
        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
    
    else if(node.type == 1){
        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
        
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL1_Cell*)cell).icon setImage:[UIImage imageNamed:nodeData.headImgPath]];
             [((CLTreeView_LEVEL1_Cell*)cell).arrowView setImage:[UIImage imageNamed:nodeData.arrowPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL1_Cell*)cell).icon setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }

        
    }
    
    else{
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL2_Cell*)cell).dateFrom.text = nodeData.dateFrom;
        ((CLTreeView_LEVEL2_Cell*)cell).dateTo.text = nodeData.dateTo;
        ((CLTreeView_LEVEL2_Cell*)cell).firstLb.text = nodeData.firstLb;
        ((CLTreeView_LEVEL2_Cell*)cell).secondLb.text = nodeData.secondLb;
        ((CLTreeView_LEVEL2_Cell*)cell).thirdLb.text = nodeData.thirdLb;
        ((CLTreeView_LEVEL2_Cell*)cell).forthLb.text = nodeData.forthLb;
        ((CLTreeView_LEVEL2_Cell*)cell).firstLbCount.text = nodeData.firstLbCount;
        ((CLTreeView_LEVEL2_Cell*)cell).secondLbCount.text = nodeData.secondLbCount;
        ((CLTreeView_LEVEL2_Cell*)cell).thirdLbCount.text = nodeData.thirdLbCount;
        ((CLTreeView_LEVEL2_Cell*)cell).forthLbCount.text = nodeData.forthLbCount;
        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
        
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
}
/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        //处理叶子节点选中，此处需要自定义
    }
    else{
        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            [self rotateArrow:cell with:M_PI_2];
        }
        else{
            [self rotateArrow:cell with:0];
        }
    }
    CLTreeView_LEVEL1_Model* model=node.nodeData;
    if ([model.name isEqualToString:@"待办事宜:"]) {
        [self showUpComingWorkDetails];
    }
    
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    if (node.type==2) {
        return 140;
    }else{
        return 50;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


@end
