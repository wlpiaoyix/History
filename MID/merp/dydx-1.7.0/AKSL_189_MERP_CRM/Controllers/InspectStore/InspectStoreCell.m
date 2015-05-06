//
//  InspectStoreCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreCell.h"
#import "CommentInfoCell.h"
#import "LikeCommentTableViewCell.h"
#import "HttpApiCall.h"

@implementation InspectStoreCell{
    InspectStoreViewController * inspectCurrView;
    InspectStoreInfo * SelectData;
    int CurrSelectComment;
    long currInspectId;
    int index;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self removeCommentAtIndex];
            break;
        
    }
    
    }
-(void)removeCommentAtIndex{
     CommentInfo * comm = SelectData.listForPingjia[CurrSelectComment] ;
    NSString *url = [NSString stringWithFormat:@"/api/comment/%ld",comm.CommentId];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallDELET:url Logo:@"yunyiyun_removeComment_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                [SelectData removeCommentAtIndex:CurrSelectComment];
                [inspectCurrView reloadData];
            }else{
                showMessageBox(@"评价失败，请重新提交。");
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil || indexPath.section == 0) return ;
        if ( ((CommentInfo *)SelectData.listForPingjia[indexPath.row]).isMyself){
        CurrSelectComment = indexPath.row;
        //add your code here
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"是否删除评论"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"删除",nil];
        [actionSheet showInView:inspectCurrView.view];
        }
    }
}
    
-(void)setData:(InspectStoreInfo *)data isShowDate:(bool)isShowDate inspectView:(InspectStoreViewController *)inspectview indexInListData:(int)indexInList{
    if (!SelectData) {
        NSString *CustomCellNibName = @"CommentInfoCell";
        UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CustomCellNibName];
        CustomCellNibName = @"LikeCommentTableViewCell";
        nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CustomCellNibName];
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [_tableView addGestureRecognizer:longPressGr];
        
    }
     SelectData = data;
     index = indexInList;
    [_tableView reloadData];
    currInspectId = data.inspectId;
    inspectCurrView = inspectview;
    _textAddr.text = data.addr;
    _textUserName.text = data.userName;
    _textStoreName.text = data.storeName;
    _imageUrl.imageUrl = data.ImageUrl;
    NSDate * curr = [NSDate new];
    _textDay.text = @"";
    _textMonth.text = @"";
    _textYear.text = @"";
    _textTime.text = [NSDate dateFormateDate:data.date FormatePattern:@"HH:mm"];
    if (isShowDate) {
        NSString * datestr = [data.date getFriendlyTime:NO];
        if ([datestr hasPrefix:@"今天"]||[datestr hasPrefix:@"昨天"]) {
            _textDay.text = [datestr substringToIndex:2];
        }else{
            _textMonth.text =[NSString stringWithFormat:@"%d月",data.date.month];//[NSDate dateFormateDate:data.date FormatePattern:@"MM月"];
            _textDay.text = [NSString stringWithFormat:@"%d",data.date.day];//[NSDate dateFormateDate:data.date FormatePattern:@"dd"];
            if (curr.year!=data.date.year) {
                _textYear.text =[NSDate dateFormateDate:data.date FormatePattern:@"yyyy年"];
            }
        }
    }

}

-(void)setData:(NSString *)userName StoreName:(NSString *)storeName Addr:(NSString *)addr Date:(NSDate *)date ImageUrl:(NSString *)url isShowDate:(bool)isShowDate inspectView:(InspectStoreViewController *)inspectview InspectStoreId:(long)inspectId{
    currInspectId = inspectId;
    inspectCurrView = inspectview;
    _textAddr.text = addr;
    _textUserName.text = userName;
    _textStoreName.text = storeName;
    _imageUrl.imageUrl = url;
    NSDate * curr = [NSDate new];
    _textDay.text = @"";
    _textMonth.text = @"";
    _textYear.text = @"";
    _textTime.text = [NSDate dateFormateDate:date FormatePattern:@"HH:mm"];
    if (isShowDate) {
        NSString * datestr = [date getFriendlyTime:NO];
        if ([datestr hasPrefix:@"今天"]||[datestr hasPrefix:@"昨天"]) {
            _textDay.text = [datestr substringToIndex:2];
        }else{
            _textMonth.text =[NSDate dateFormateDate:date FormatePattern:@"MM月"];
            _textDay.text = [NSDate dateFormateDate:date FormatePattern:@"dd"];
            if (curr.year!=date.year) {
                _textYear.text =[NSDate dateFormateDate:date FormatePattern:@"yyyy年"];
            }
        }
    }
    
}
- (IBAction)toZanpingjia:(id)sender {
    if (inspectCurrView) {
        CGRect frame = self.frame;
        [inspectCurrView showZanpingjia:currInspectId isZan:SelectData.isSelfZan Top:frame.origin.y indexForData:index];
    }
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (SelectData && SelectData.listForPingjia) {
            return SelectData.listForPingjia.count;
        }
    }else if(section == 0){
        if (SelectData && SelectData.hieghtForZan>0) {
            return 1;
        }
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (SelectData && SelectData.listForPingjia) {
            CommentInfo *  comm = SelectData.listForPingjia[indexPath.row];
            return comm.higehtForConent;
        }
    }else if(indexPath.section == 0){
        return SelectData.hieghtForZan;
    }

    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (SelectData && SelectData.listForPingjia) {
            CommentInfo *  comm = SelectData.listForPingjia[indexPath.row];
             CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentInfoCell"];
            [cell setData:comm];
            return cell;
        }
    }else if(indexPath.section == 0){
        LikeCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCommentTableViewCell"];
        [cell setData:SelectData.zanString];
        return cell;
    }

   return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (SelectData && SelectData.listForPingjia) {
            CommentInfo *  comm = SelectData.listForPingjia[indexPath.row];
            if (!comm.isMyself) {
                [inspectCurrView showPingjia:currInspectId indexForData:index pId:comm.fromUserId pname:comm.fromUserName cId:comm.CommentId];
            }else{
                [inspectCurrView hideZanpingjia];
                CurrSelectComment = indexPath.row;
                //add your code here
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"是否删除评论"
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"删除",nil];
                [actionSheet showInView:inspectCurrView.view];
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)toPeopleList:(id)sender {
    if (inspectCurrView) {
        [inspectCurrView showPeopleList:SelectData.CreaterUserCode];
    }
}

@end
