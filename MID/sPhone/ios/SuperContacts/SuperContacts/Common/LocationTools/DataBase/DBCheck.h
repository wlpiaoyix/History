//
//  DBCheck.h
//  ST-ME
//
//  Created by wlpiaoyi on 13-12-27.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBCheck : NSObject
@property NSString *databasePath;
-(id) initDataBaseName:(NSString*) dataBaseName;
-(bool) openDataBase;
//-(bool) createTableWithSql:(NSString*) sql;
//-(bool) insertTableWithSql:(NSString*) sql Value:(id) value,...;
//-(NSArray*) queryTableWithSql:(int) type;
-(bool)createTimerTable;
-(bool) insertTableValue;
-(void) queryTable;
-(bool) deleteTable;
@end
