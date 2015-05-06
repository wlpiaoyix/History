//
//  SingeInspectStoreCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-14.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SingeInspectStoreCell.h"
#import "HttpApiCall.h"
#import "CommentInfo.h"
#import "InspectStoreViewController.h"
#import "InspectStoreInfo.h"
#import "CommentInfoDetailedCell.h"
#import "LikeCommentTableViewCell.h"


@implementation SingeInspectStoreCell{
    InspectStoreViewController * inspectCurrView;
    InspectStoreInfo * SelectData;
    int CurrSelectComment;
    long currInspectId;
    int index;
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setData:(InspectStoreInfo *)data  inspectView:(InspectStoreViewController *)inspectview indexInListData:(int)indexInList{
    if (!SelectData) {
        NSString *CustomCellNibName = @"CommentInfoDetailedCell";
        UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CustomCellNibName];
        CustomCellNibName = @"LikeCommentTableViewCell";
        nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CustomCellNibName];
         
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
    _textContent.text = data.checkContents;
    _userImageHeader.imageUrl = data.userHaderImageUrl;
    _textTime.text = [@"  " stringByAppendingString:[data.date getFriendlyTime:YES]];
    
    
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
            NSDictionary *temp = [reArg JSONValue];
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
            CommentInfoDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentInfoDetailedCell"];
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

@end
