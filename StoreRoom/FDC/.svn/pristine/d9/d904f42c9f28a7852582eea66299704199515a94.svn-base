//
//  CustomerMainManager.m
//  FDC
//
//  Created by wlpiaoyi on 15/1/21.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerMainManager.h"
#import "ConfigManage+Expand.h"

@implementation CustomerMainManager
/**
 销售员首页信息
 */
-(void) mainForCustomerWithStartTime:(NSDate*) startTime endTime:(NSDate*) endTime objectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetXSYSY_KH"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            NSArray *lables;
            if ([result isKindOfClass:[NSDictionary class]]) {
                LableEntity *label = [LableEntity instanceWithJson:result];
                lables = @[label];
            }else if([result isKindOfClass:[NSArray class]]){
                NSMutableArray *temp = [NSMutableArray new];
                for (NSDictionary *json in result) {
                    LableEntity *label = [LableEntity instanceWithJson:json];
                    [temp addObject:label];
                }
                lables = [NSArray arrayWithArray:temp];
            }
            success(lables,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    [hur requestGET:@{@"YH_YHID":[ConfigManage getLoginUser].userId,@"WY_WYID":objectId?objectId:[ConfigManage getLoginUser].objectId,@"StartTime":startTime?[startTime dateFormateDate:@"yyyy-MM-dd"]:@"2014-01-01",@"EndTime":endTime?[endTime dateFormateDate:@"yyyy-MM-dd"]:@"2018-12-31"}];
}

/**
 客户生日信息
 */
-(void) birthDayForCustomerWithObjectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetKH_SRXXARRY"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            NSMutableArray *arrayResult;
            if(result&&[result isKindOfClass:[NSArray class]]){
                for (NSDictionary *json in result) {
                    CustomerBirthdayEntity *entity = [CustomerBirthdayEntity instanceWithJson:json];
                    [arrayResult addObject:entity];
                }
            }
            success(arrayResult,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    [hur requestGET:@{@"YH_YHID":[ConfigManage getLoginUser].userId,@"WY_WYID":objectId?objectId:[ConfigManage getLoginUser].objectId}];
    
}
/**
 客户跟踪接口
 customerName:客户名称
 visitData:访问时间
 orderLevel:客户意向程度
 customerType:客户类型
 */
-(void) followUpForCustomerWithName:(NSString*) customerName visitDate:(NSDate*) visitDate orderLevel:(float) orderLevel customerType:(NSString*) customerType objectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetKH_GZXXARRY"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        
        NSMutableArray *arrayResult;
        if(result&&[result isKindOfClass:[NSArray class]]){
            for (NSDictionary *json in result) {
                CustomerFollowUpEntity *entity = [CustomerFollowUpEntity instanceWithJson:json];
                [arrayResult addObject:entity];
            }
        }
        if (success) {
            success(arrayResult,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"YH_YHID":[ConfigManage getLoginUser].userId,@"WY_WYID":objectId?objectId:[ConfigManage getLoginUser].objectId}];
    [params setObject:@"" forKey:@"KH_KHXM"];
    if ([NSString isEnabled:customerName]) {
        [params setObject:customerName forKey:@"KH_KHXM"];
    }
    [params setObject:@"" forKey:@"LF_LFRQ"];
    if (visitDate) {
        [params setObject:[visitDate dateFormateDate:@"yyyy-MM-dd"] forKey:@"LF_LFRQ"];
    }
    [params setObject:@"" forKey:@"KH_YXCD"];
    if (orderLevel>0) {
        [params setObject:[NSNumber numberWithFloat:orderLevel] forKey:@"KH_YXCD"];
    }
    [params setObject:@"" forKey:@"KH_KHLX"];
    if ([NSString isEnabled:customerType]) {
        [params setObject:customerType forKey:@"KH_KHLX"];
    }
    [hur requestGET:params];
    
}

-(void) followUpDetailForCustomerWithObjectId:(NSString*) objectId customerId:(NSString*) customerId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetKH_KHGZ_EDITBYID"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (result) {
            CustomerFollowUpDetailEnity *entity = [CustomerFollowUpDetailEnity instanceWithJson:result];
            result = entity;
        }
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"YH_YHID":[ConfigManage getLoginUser].userId,@"WY_WYID":objectId?objectId:[ConfigManage getLoginUser].objectId}];
    if ([NSString isEnabled:customerId]) {
        [params setObject:customerId forKey:@"KH_KHID"];
    }
    [hur requestGET:params];
}


/**
 联系状态改变接口
 customerId:客户ID
 followUpDate:跟踪日期
 followUpWay:跟踪方式
 isEnabled:是否有效
 */
-(void) optFollowUpForCustomer:(NSString*) customerId followUpDate:(NSString*) followUpDate followUpWay:(NSString*) followUpWay isEnabled:(NSString*) isEnabled success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"TJKH_GZJHXX"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"YH_YHID":[ConfigManage getLoginUser].userId}];
    if ([NSString isEnabled:customerId]) {
        [params setObject:customerId forKey:@"KH_KHID"];
    }
    if ([NSString isEnabled:followUpDate]) {
        [params setObject:followUpDate forKey:@"KH_GZRQ"];
    }
    if ([NSString isEnabled:followUpWay]) {
        [params setObject:followUpWay forKey:@"KH_GZFS"];
    }
    [params setObject:isEnabled?isEnabled:@"失效" forKey:@"GZ_SFSX"];
    [hur requestGET:params];
}
/**
 逾期签约列表
 */
-(void) singedOverdueForCustomer:(NSString*) customerId objectId:(NSString*) objectId startTime:(NSString*) startTime endTime:(NSString*) endTime success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetQYYQXXARRY"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (NSDictionary* json in result) {
            SignOverdueEntity *entity = [SignOverdueEntity instanceWithJson:json];
            [resultArray addObject:entity];
        }
        if (success) {
            success(resultArray,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([NSString isEnabled:objectId]) {
        [params setObject:objectId forKey:@"WY_WYID"];
    }else{
        [params setObject:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    }
    if ([NSString isEnabled:customerId]) {
        [params setObject:customerId forKey:@"YH_YHID"];
    }
    if ([NSString isEnabled:startTime]) {
        [params setObject:startTime forKey:@"StartTime"];
    }
    if ([NSString isEnabled:endTime]) {
        [params setObject:endTime forKey:@"EndTime"];
    }
    [hur requestGET:params];
}

/**
 联系状态改变
 */
-(void) optContactedStatusWithCompactId:(NSString*) compactId userId:(NSString*) userId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"ModifyHT_LXSTATE"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"YH_YHID":[ConfigManage getLoginUser].userId}];
    if ([NSString isEnabled:compactId]) {
        [params setObject:compactId forKey:@"HT_HTID"];
    }
    if ([NSString isEnabled:userId]) {
        [params setObject:userId forKey:@"YH_YHID"];
    }
    [hur requestGET:params];
    
}

-(void) queryCustomerWithObjectId:(NSString*) objectId customerName:(NSString*) customerName customerPhone:(NSString*) customerPhone certificate:(NSString*) certificate visitDate:(NSString*) visitDate visitWay:(NSString*) visitWay orderLevel:(NSString*) orderLevel  tradeState:(NSString*) tradeState success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetKH_KHCX"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (NSDictionary* json in result) {
            CustomerInfoEntity *entity = [CustomerInfoEntity instanceWithJson:json];
            [resultArray addObject:entity];
        }
        if (success) {
            success(resultArray,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([NSString isEnabled:objectId]) {
        [params setObject:objectId forKey:@"WY_WYID"];
    }else{
        [params setObject:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    }
    [params setObject:@"" forKey:@"KH_KHMC"];
    [params setObject:@"" forKey:@"KH_KHDH"];
    [params setObject:@"" forKey:@"KH_ZJHM"];
    [params setObject:@"" forKey:@"KH_LFRQ"];
    [params setObject:@"" forKey:@"KH_LFFS"];
    [params setObject:@"" forKey:@"KH_YXCD"];
    [params setObject:@"" forKey:@"tradeState"];
    if ([NSString isEnabled:customerName]) {
        [params setObject:customerName forKey:@"KH_KHMC"];
    }
    if ([NSString isEnabled:customerPhone]) {
        [params setObject:customerPhone forKey:@"KH_KHDH"];
    }
    if ([NSString isEnabled:certificate]) {
        [params setObject:certificate forKey:@"KH_ZJHM"];
    }
    if ([NSString isEnabled:visitDate]) {
        [params setObject:visitDate forKey:@"KH_ZJHM"];
    }
    if ([NSString isEnabled:visitWay]) {
        [params setObject:visitWay forKey:@"KH_LFFS"];
    }
    if ([NSString isEnabled:orderLevel]) {
        [params setObject:orderLevel forKey:@"KH_YXCD"];
    }
    if ([NSString isEnabled:tradeState]) {
        [params setObject:tradeState forKey:@"tradeState"];
    }
    [hur requestGET:params];
}
/**
 客户验证
 */
-(void) verificationForCustomerWithObjectId:(NSString*) objectId customerName:(NSString*) customerName customerPhone:(NSString*) customerPhone certificate:(NSString*) certificate success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"CustomerValidate"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (NSDictionary* json in result) {
            CustomerVerificationEntity *entity = [CustomerVerificationEntity instanceWithJson:json];
            [resultArray addObject:entity];
        }
        if (success) {
            success(resultArray,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([NSString isEnabled:objectId]) {
        [params setObject:objectId forKey:@"WY_WYID"];
    }else{
        [params setObject:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    }
    [params setObject:@"" forKey:@"KH_KHMC"];
    [params setObject:@"" forKey:@"KH_KHDH"];
    [params setObject:@"" forKey:@"KH_ZJHM"];
    if ([NSString isEnabled:customerName]) {
        [params setObject:customerName forKey:@"KH_KHMC"];
    }
    if ([NSString isEnabled:customerPhone]) {
        [params setObject:customerPhone forKey:@"KH_KHDH"];
    }
    if ([NSString isEnabled:certificate]) {
        [params setObject:certificate forKey:@"KH_ZJHM"];
    }
    [hur requestGET:params];
}
/**
 客户来电专访
 */
-(void) customerCallVisitWithIds:(NSString*) customerIds success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"XSY_LDZLF"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([NSString isEnabled:customerIds]) {
        [params setObject:customerIds forKey:@"KH_KHID"];
    }
    [hur requestGET:params];
    
}

/**
 新增客户
 */
-(void) persistCustomer:(CustomerEntity*) entity success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"KH_JBXXADD"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[entity toInstanceJson] forKey:@"khxx"];
    [hur requestGET:params];
    
}
/**
 调查表
 */
-(void) findQuestionaryWithObjectId:(NSString*) objectId visitWay:(NSString*) visitWay custormerId:(NSString*) custormerId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GETDCBXXBYLFFS"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (NSDictionary* json in result) {
            QuestionaryEntity *entity = [QuestionaryEntity instanceWithJson:json];
            [resultArray addObject:entity];
        }
        if (success) {
            success(resultArray,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:objectId?objectId:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    [params setObject:custormerId forKey:@"KH_KHID"];
    if ([NSString isEnabled:visitWay]) [params setObject:visitWay forKey:@"LF_LFFS"];
    [hur requestGET:params];
}
/**
 客户跟踪下拉信息
 */
-(void) pullDownForFollowupWithDic:(NSString*) dic objectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetZDGLARRY"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:objectId?objectId:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    [params setObject:dic forKey:@"ZD_ZDID"];
    [hur requestGET:params];
}

/**
 查询户型
 */
-(void) queryHouseholderWithObjectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetHXGLARRY"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:objectId?objectId:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    [hur requestGET:params];
}

/**
 查询房屋信息
 objectId:项目ID
 houseloderId:户型ID
 houseNum:房屋编号
 biuldId:楼座ID
 unitId:单元ID
 floorNum:楼层编号
 */
-(void) queryHouseInfoWithObjectId:(NSString*) objectId householderId:(NSString*) householderId houseNum:(NSString*) houseNum biuldId:(NSString*) biuldId unitId:(NSString*) unitId floorNum:(NSString*) floorNum success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"GetHXFWGLARRY"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(result,nil);
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:objectId?objectId:[ConfigManage getLoginUser].objectId forKey:@"WY_WYID"];
    [params setObject:householderId?householderId:@"" forKey:@"HX_HXID"];
    [params setObject:houseNum?houseNum:@"" forKey:@"FW_FWBH"];
    [params setObject:biuldId?biuldId:@"" forKey:@"LZ_LZID"];
    [params setObject:unitId?unitId:@"" forKey:@"FW_DYBH"];
    [params setObject:floorNum?floorNum:@"" forKey:@"FW_LCBH"];
    [hur requestGET:params];
}

@end
