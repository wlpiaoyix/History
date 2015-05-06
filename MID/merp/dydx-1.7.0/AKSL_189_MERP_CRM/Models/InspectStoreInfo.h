//
//  InspectStoreInfo.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentInfo.h"

@interface InspectStoreInfo : NSObject
//(NSString *)userName StoreName:(NSString *)storeName Addr:(NSString *)addr Date:(NSDate*)date ImageUrl:(NSString *)url isShowDate:(bool)isShowDate inspectView:(InspectStoreViewController *)inspectview InspectStoreId:(long)inspectId
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * storeName;
@property (strong,nonatomic) NSString * addr;
@property (strong,nonatomic) NSDate * date;
@property (strong,nonatomic) NSString * ImageUrl;
@property (assign) long inspectId;
@property (assign) bool isSelfZan;
@property (strong,nonatomic) NSMutableArray * listForZan;
@property (strong,nonatomic) NSMutableArray * listForPingjia;
@property (assign) CGFloat hieghtForZanpingjia;
@property (assign) CGFloat hieghtForZan;
@property (assign) CGFloat hieghtForContent;
@property (strong,nonatomic) NSString * zanString;
@property (strong,nonatomic) NSString * attamentsIds;
@property (strong,nonatomic) NSString * checkContents;
@property (strong,nonatomic) NSDictionary * organization;
@property (strong,nonatomic) NSString * userHaderImageUrl;
@property (strong,nonatomic) NSString * CreaterUserCode;
@property (assign) long selfZanId;
@property (strong,nonatomic) NSString * checkTypeName;
@property (strong,nonatomic) NSArray * ImagesAll;

@property (assign) BOOL isNewObj;

-(void)addZan:(NSDictionary *)dic;
-(void)removeCommentAtIndex:(int)index;
-(void)addComment:(CommentInfo *)comm;
-(void)removeSelfZan;
-(CGFloat)hieghtForZanpingjiaNewDetailInfo;
+(InspectStoreInfo *)getInspectStoreInfo:(NSDictionary *)inspectInfo;
+(InspectStoreInfo *)getInspectStoreInfoNewObj:(NSDictionary *)inspectInfo;
@end
