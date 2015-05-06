//
//  CTM_RecordFromUserCell.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-23.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityUser.h"
typedef void (^RFUCExcueClickButton)(EntityUser *userx);
@interface CTM_RecordFromUserCell : UITableViewCell{
    @protected EntityUser *userx;
    @protected RFUCExcueClickButton methodx;
}
-(void) setEntityUser:(EntityUser*) user;
-(void) setExcueClickButton:(RFUCExcueClickButton) method;
@end
