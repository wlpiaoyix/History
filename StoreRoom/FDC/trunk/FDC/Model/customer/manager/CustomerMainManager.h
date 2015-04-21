//
//  CustomerMainManager.h
//  FDC
//
//  Created by wlpiaoyi on 15/1/21.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDCBaseManger.h"
#import "LableEntity.h"
#import "CustomerEntity.h"
#import "CustomerBirthdayEntity.h"
#import "CustomerFollowUpEntity.h"
#import "CustomerFollowUpDetailEnity.h"
#import "CustomerVerificationEntity.h"
#import "SignOverdueEntity.h"

@interface CustomerMainManager : FDCBaseManger
/**
 销售员首页信息
 */
-(void) mainForCustomerWithStartTime:(NSDate*) startTime endTime:(NSDate*) endTime objectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 客户生日信息
 */
-(void) birthDayForCustomerWithObjectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 客户跟踪接口
 customerName:客户名称
 visitData:访问时间
 orderLevel:客户意向程度
 customerType:客户类型
 */
-(void) followUpForCustomerWithName:(NSString*) customerName visitDate:(NSDate*) visitDate orderLevel:(float) orderLevel customerType:(NSString*) customerType objectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 客户跟踪详细信息
 */
-(void) followUpDetailForCustomerWithObjectId:(NSString*) objectId customerId:(NSString*) customerId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;

/**
 联系状态改变接口
 customerId:客户ID
 followUpDate:跟踪日期
 followUpWay:跟踪方式
 isEnabled:是否有效
 */
-(void) optFollowUpForCustomer:(NSString*) customerId followUpDate:(NSString*) followUpDate followUpWay:(NSString*) followUpWay isEnabled:(NSString*) isEnabled success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 逾期签约列表
 */
-(void) singedOverdueForCustomer:(NSString*) customerId objectId:(NSString*) objectId startTime:(NSString*) startTime endTime:(NSString*) endTime success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 联系状态改变
 */
-(void) optContactedStatusWithCompactId:(NSString*) compactId userId:(NSString*) userId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) queryCustomerWithObjectId:(NSString*) objectId customerName:(NSString*) customerName customerPhone:(NSString*) customerPhone certificate:(NSString*) certificate visitDate:(NSString*) visitDate visitWay:(NSString*) visitWay orderLevel:(NSString*) orderLevel tradeState:(NSString*) tradeState success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 客户验证
 */
-(void) verificationForCustomerWithObjectId:(NSString*) objectId customerName:(NSString*) customerName customerPhone:(NSString*) customerPhone certificate:(NSString*) certificate success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 客户来电专访
 */
-(void) customerCallVisitWithIds:(NSString*) customerIds success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 新增客户
 */
-(void) persistCustomer:(CustomerEntity*) entity success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 调查表
 */
-(void) findQuestionaryWithObjectId:(NSString*) objectId visitWay:(NSString*) visitWay custormerId:(NSString*) custormerId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 客户跟踪下拉信息
 */
-(void) pullDownForFollowupWithDic:(NSString*) dic objectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 查询户型
 */
-(void) queryHouseholderWithObjectId:(NSString*) objectId success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
/**
 查询房屋信息
 objectId:项目ID
 houseloderId:户型ID
 houseNum:房屋编号
 biuldId:楼座ID
 unitId:单元ID
 floorNum:楼层编号
 */
-(void) queryHouseInfoWithObjectId:(NSString*) objectId householderId:(NSString*) householderId houseNum:(NSString*) houseNum biuldId:(NSString*) biuldId unitId:(NSString*) unitId floorNum:(NSString*) floorNum success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
@end
