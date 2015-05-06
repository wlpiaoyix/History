//
//  InspectStoreInfo.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreInfo.h"

@implementation InspectStoreInfo

-(void)addComment:(CommentInfo *)comm{
    [self.listForPingjia addObject:comm];
    CGFloat higeht = 138;
    self.hieghtForZan = 0;
    if (self.listForZan && self.listForZan.count>0) {
        CGFloat zanh =10;
        zanh += [self.zanString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(208, 2000)].height;
        higeht += zanh;
        self.hieghtForZan = zanh;
    }
    for (CommentInfo * comment in self.listForPingjia) {
        higeht += comment.higehtForConent;
    }
    self.hieghtForZanpingjia = higeht;
}
-(void)removeCommentAtIndex:(int)index{
    [self.listForPingjia removeObjectAtIndex:index];
    CGFloat higeht = 138;
    self.hieghtForZan = 0;
    if (self.listForZan && self.listForZan.count>0) {
        CGFloat zanh =10;
        zanh += [self.zanString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(208, 2000)].height;
        higeht += zanh;
        self.hieghtForZan = zanh;
    }
    for (CommentInfo * comment in self.listForPingjia) {
        higeht += comment.higehtForConent;
    }
    self.hieghtForZanpingjia = higeht;
}

-(NSDictionary *)getZanUserObj:(int)index{
    NSDictionary *temp = self.listForZan[index];
    NSString * username = [temp valueForKey:@"userName"];
    if (username&&username.length>0) {
        return temp;
    }
    return [temp valueForKey:@"fromUser"];
}

-(void)addZan:(NSDictionary *)dic{
    self.isSelfZan = YES;
    self.selfZanId = [[dic valueForKey:@"id"]longValue];
    [self.listForZan addObject:dic];
    NSMutableString * zan = [NSMutableString new];
    for (int i=0;i<self.listForZan.count;i++) {
        NSDictionary * temp  =[self getZanUserObj:i];
        [zan appendString:[temp valueForKey:@"userName"]];
        [zan appendString:@","];
    }
    self.zanString = zan;
    CGFloat higeht = 138;
    self.hieghtForZan = 0;
    if (self.listForZan && self.listForZan.count>0) {
        CGFloat zanh =10;
        zanh += [self.zanString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(208, 2000)].height;
        higeht += zanh;
        self.hieghtForZan = zanh;
    }
    for (CommentInfo * comment in self.listForPingjia) {
        higeht += comment.higehtForConent;
    }
    self.hieghtForZanpingjia = higeht;
}
-(void)removeSelfZan{
    self.isSelfZan = NO;
    NSMutableString * zan = [NSMutableString new];
    long CurrUserID = [ConfigManage getLoginUser].userDataId;
    int tobeRemove = -1;
    for (int i=0;i<self.listForZan.count;i++) {
        NSDictionary * temp  = [self getZanUserObj:i];
        long tempuserid = [[temp valueForKey:@"userId"]longValue];
        if (tempuserid == 0) {
            tempuserid = [[temp valueForKey:@"id"]longValue];
        }
        if (CurrUserID == tempuserid) {
            if (tobeRemove>=0) {
                self.isSelfZan = YES;
                [zan appendString:[temp valueForKey:@"userName"]];
                [zan appendString:@","];
            }else{
                tobeRemove = i;
            }
        }else{
           [zan appendString:[temp valueForKey:@"userName"]];
           [zan appendString:@","];
         }
        }
    if (tobeRemove>=0) {
        [self.listForZan removeObjectAtIndex:tobeRemove];
    }
 self.zanString = zan;
    CGFloat higeht = 138;
    self.hieghtForZan = 0;
    if (self.listForZan && self.listForZan.count>0) {
        CGFloat zanh =10;
        zanh += [self.zanString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(208, 2000)].height;
        higeht += zanh;
        self.hieghtForZan = zanh;
    }
    for (CommentInfo * comment in self.listForPingjia) {
        higeht += comment.higehtForConent;
    }
    self.hieghtForZanpingjia = higeht;
}
-(CGFloat)hieghtForZanpingjiaNewDetailInfo{
    return self.hieghtForZanpingjia +60+ self.hieghtForContent;
}

+(InspectStoreInfo *)getInspectStoreInfoNewObj:(NSDictionary *)inspectInfo{
    
    InspectStoreInfo * info = [InspectStoreInfo new];
    info.isNewObj = YES;
    NSDictionary *temp = [inspectInfo valueForKey:@"user"];
    info.CreaterUserCode = [temp valueForKey:@"userCode"];
    info.userName = [temp valueForKey:@"userName"];
    info.userHaderImageUrl = API_IMAGE_URL_GET2([temp valueForKey:@"portrait"]);
    info.storeName = [[inspectInfo valueForKey:@"hall"]valueForKey:@"fullName"];
    info.addr = [inspectInfo valueForKey:@"location"];
    info.checkTypeName = [[inspectInfo valueForKey:@"type"]valueForKey:@"value"];
    [InspectStoreInfo setImages:info PicString:[inspectInfo objectForKey:@"picUrls"]];
    info.ImageUrl =info.ImagesAll[0];
    info.inspectId =[[inspectInfo objectForKey:@"id"]longValue];
    info.date = [NSDate dateFormateString:[inspectInfo objectForKey:@"time"] FormatePattern:nil];
    info.listForZan = [inspectInfo valueForKey:@"likes"];
    info.checkContents = [inspectInfo objectForKey:@"content"];
    NSString * contentsNew = [NSString stringWithFormat:@"#%@#%@",info.checkTypeName,info.checkContents];
    info.hieghtForContent =10+[contentsNew sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(245, 2000)].height;
    if (info.hieghtForContent<30) {
        info.hieghtForContent = 30;
    }
    
    NSMutableString * zan = [NSMutableString new];
    long CurrUserID = [ConfigManage getLoginUser].userDataId;
    for (NSDictionary * temp in info.listForZan) {
        NSDictionary *userdic = [temp valueForKey:@"fromUser"];
        [zan appendString:[userdic valueForKey:@"userName"]];
        [zan appendString:@","];
        long tempuserid = [[userdic valueForKey:@"id"]longValue];
        if (CurrUserID == tempuserid) {
            info.isSelfZan = YES;
            info.selfZanId = [[temp valueForKey:@"id"]longValue];
        }
    }
    info.zanString = zan;

    info.listForPingjia = [NSMutableArray new];
    
    NSArray * listcomm = [inspectInfo valueForKey:@"comments"];
    CGFloat higeht = 138;
    if (info.listForZan && info.listForZan.count>0) {
        CGFloat zanh =10;
        zanh += [info.zanString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(208, 2000)].height;
        higeht += zanh;
        info.hieghtForZan = zanh;
    }
    for (NSDictionary * temp in listcomm) {
        CommentInfo * comment = [CommentInfo getCommentInfoNew:temp];
        higeht += comment.higehtForConent;
        [info.listForPingjia addObject:comment];
    }
    info.hieghtForZanpingjia = higeht;
    return info;
}

+(void)setImages:(InspectStoreInfo *)info PicString:(NSString *)pics{
    NSArray * picsary = [pics componentsSeparatedByString:@","];
    NSMutableArray * newary = [NSMutableArray new];
    for (NSString * strpic in picsary) {
        [newary addObject:API_IMAGE_URL_GET2(strpic)];
    }
    info.ImagesAll = newary;
}


+(InspectStoreInfo *)getInspectStoreInfo:(NSDictionary *)inspectInfo{
    InspectStoreInfo * info = [InspectStoreInfo new];
    info.isNewObj = NO;
    info.CreaterUserCode = [inspectInfo valueForKey:@"userCode"];
    info.userName = [inspectInfo objectForKey:@"userName"];
    info.storeName  =[inspectInfo objectForKey:@"orgName"];
    info.addr =[inspectInfo objectForKey:@"checkLocation"];
    info.checkTypeName =[inspectInfo objectForKey:@"checkTypeName"];
    info.date = [NSDate dateFormateString:[inspectInfo objectForKey:@"checkTime"] FormatePattern:nil];
    info.ImageUrl =API_IMAGE_URL_GET2([inspectInfo objectForKey:@"defaultPic"]);
    info.inspectId =[[inspectInfo objectForKey:@"id"]longValue];
    
    info.listForZan = [inspectInfo valueForKey:@"likes"];
    info.attamentsIds = [inspectInfo objectForKey:@"attamentsIds"];
    info.checkContents = [inspectInfo objectForKey:@"checkContents"];
    info.hieghtForContent =10+[info.checkContents sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(245, 2000)].height;
    if (info.hieghtForContent<30) {
        info.hieghtForContent = 30;
    }
    info.organization = [inspectInfo objectForKey:@"organization"];
    info.userHaderImageUrl=API_IMAGE_URL_GET2([inspectInfo valueForKey:@"userPortrait"]);
    info.listForPingjia = [NSMutableArray new];
    NSMutableString * zan = [NSMutableString new];
     long CurrUserID = [ConfigManage getLoginUser].userDataId;
    for (NSDictionary * temp in info.listForZan) {
        [zan appendString:[temp valueForKey:@"userName"]];
        [zan appendString:@","];
        long tempuserid = [[temp valueForKey:@"userId"]longValue];
        if (CurrUserID == tempuserid) {
            info.isSelfZan = YES;
            info.selfZanId = [[temp valueForKey:@"id"]longValue];
        }
    }
    info.zanString = zan;
    NSArray * listcomm = [inspectInfo valueForKey:@"comment"];
    CGFloat higeht = 138;
    if (info.listForZan && info.listForZan.count>0) {
        CGFloat zanh =10;
        zanh += [info.zanString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(208, 2000)].height;
        higeht += zanh;
        info.hieghtForZan = zanh;
    }
    for (NSDictionary * temp in listcomm) {
        CommentInfo * comment = [CommentInfo getCommentInfo:temp];
        higeht += comment.higehtForConent;
        [info.listForPingjia addObject:comment];
    }
    info.hieghtForZanpingjia = higeht;
    return info;
}

@end
