//
//  SelectorOfInspectStore.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SelectorOfInspectStore.h"

@implementation SelectorOfInspectStore
+(NSMutableArray *)setjson:(NSArray *)array
{
    NSMutableArray *dataArray = [NSMutableArray new];
    for (int i = 0 ; i< [array count]; i++) {
    SelectorOfInspectStore *selector = [SelectorOfInspectStore new];
    selector.title = [array[i] objectForKey:@"title"];
    selector.imageUrl = API_IMAGE_URL_GET2([array[i] objectForKey:@"coverPic"]);
        selector.dateSelect = [array[i] objectForKey:@"period"];
        selector.condition = [array[i] objectForKey:@"condition"];
                 if ([[array[i] objectForKey:@"type"] isEqualToString:@"default"]) {
                     selector.isCanDelete = NO;
                     if ([[array[i] objectForKey:@"title"] isEqualToString:@"最新"]) {
                         selector.type = 0;
                     }
                     else if ([[array[i] objectForKey:@"title"] isEqualToString:@"我的"])
                     {
                         selector.type = 1;
                     }
                     else if ([[array[i] objectForKey:@"title"] isEqualToString:@"点赞"])
                     {
                         selector.type = 2;
                     }
                     else if ([[array[i] objectForKey:@"title"] isEqualToString:@"评论"])
                     {
                         selector.type = 3;
                     }
                 }
                 else
                 {
                     selector.isCanDelete = YES;
                     selector.type = 5;
                     selector.userCode = [array[i] objectForKey:@"desc"];
                 }
        selector.countOfRemind = [[[array[i] objectForKey:@"data"] objectForKey:@"unRead"] intValue];
        selector.countOfComment = [[[array[i] objectForKey:@"data"] objectForKey:@"comment"] intValue];
        selector.countOfLike =  [[[array[i] objectForKey:@"data"] objectForKey:@"like"] intValue];
        selector.isCanMove = YES;
        selector.tagId = [[array[i] objectForKey:@"id"] intValue];
        [dataArray addObject:selector];
        }
    SelectorOfInspectStore * selector = [SelectorOfInspectStore new];
    selector.title = @"添加标签";
    selector.type = 4;
    selector.isCanDelete =NO;
    selector.isCanMove =NO;
    [dataArray addObject:selector];
    return dataArray;
}
@end
