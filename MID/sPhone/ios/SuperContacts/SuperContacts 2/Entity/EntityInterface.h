//
//  EntityInterface.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol EntityInterface<NSObject>
@required
- (int) getEntityId;
+(char*) getCreateSql;
+(char*) getPersistSql;
+(char*) getMergeSql;
+(char*) getDeleteSql;
+(char*) getFindSql;
@optional -(id) getJSONValue;
@end
