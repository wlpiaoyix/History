//
//  InspectStoreDetailInfoCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreDetailInfoCell.h"
#import "InspectStoreInfo.h"
#import "CommentInfo.h"
#import "CommentInfoCell.h"
#import "LikeCommentTableViewCell.h"
#import "HttpApiCall.h"

@implementation InspectStoreDetailInfoCell{
    InspectStoreInfoListPage * inspectCurrView;
    InspectStoreInfo * SelectData;
    int CurrSelectComment;
    long currInspectId;
    int index;
}

- (void)awakeFromNib
{
    // Initialization code
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

 

-(void)setData:(InspectStoreInfo *)data inspectView:(InspectStoreInfoListPage *)inspectview indexInListData:(int)indexInList{
    if (!SelectData) {
        NSString *CustomCellNibName = @"CommentInfoCell";
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
    //_textAddr.text = data.addr;
    _textUserName.text = data.userName;
    _textStoreName.text = data.storeName;
    //_imageUrl.imageUrl = data.ImageUrl;
    _textForInfo.text = [NSString stringWithFormat:@"#%@#%@",data.checkTypeName,data.checkContents];//data.checkContents;
    _userHaderImage.imageUrl = data.userHaderImageUrl;
    _userHaderImage.layer.cornerRadius = 25;
    _textForDate.text = [data.date getFriendlyTime:YES];
    _textForType.text = [NSString stringWithFormat:@"#%@#",data.checkTypeName];
    
    CGRect frame = _textForInfo.frame;
    CGFloat speace = data.hieghtForContent - 30;
    frame.size.height = data.hieghtForContent;
    _textForInfo.frame = frame;
      frame = _listView.frame;
      frame.origin.y = 58+speace;
    frame.size.height = data.hieghtForZanpingjiaNewDetailInfo - frame.origin.y;
    _listView.frame = frame;
    if (self.imageUrl) {
        self.imageUrl.imageUrl = @"";
        for(EMAsyncImageView *view in [self.imageUrl subviews])
        {
            [view removeFromSuperview];
        }
        self.imageUrl.layer.cornerRadius = 0;
    }
    
    if (data.ImagesAll.count == 1) {
        _imageUrl.imageUrl = data.ImagesAll[0];
        self.imageUrl.layer.cornerRadius = 0;
    }
    else if ([data.ImagesAll count] == 2)
    {
        for (int i =0 ; i< 2; i++) {
            EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(i*60, 0, 60, 120)];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            imgView.imageUrl = data.ImagesAll[i];
            imgView.layer.cornerRadius = 0;
            [self.imageUrl addSubview:imgView];
        }
    }
    else if ([data.ImagesAll count] == 3)
    {
        EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 120)];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.imageUrl =data.ImagesAll[0];
        imgView.layer.cornerRadius = 0;
        [self.imageUrl addSubview:imgView];
        int hegith = 0;
        for (int i =1 ; i< 3; i++) {
            EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(60, hegith, 60, 60)];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            hegith+=60;
            imgView.imageUrl = data.ImagesAll[i];
            imgView.layer.cornerRadius = 0;
            [self.imageUrl addSubview:imgView];
        }
    }
    else if ([data.ImagesAll count] >= 4)
    {
        for (int i =0 ; i< 2; i++) {
            for (int j = 0; j<2; j++) {
                if ((i*2+j) <4 ) {
                    EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(j*60, i*60, 60, 60)];
                    [imgView setContentMode:UIViewContentModeScaleAspectFill];
                    imgView.imageUrl =  [data.ImagesAll objectAtIndex:i*2+j];
                    imgView.layer.cornerRadius = 0;
                    [self.imageUrl addSubview:imgView];
                }
                else
                {
                    break;
                }
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

-(IBAction)toImagesView:(id)sender{
    [inspectCurrView showImagesView:index];
}

-(IBAction)toNamePage:(id)sender{
    [inspectCurrView showSingePage:SelectData.CreaterUserCode Name:SelectData.userName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
