//
//  CTM_Contents_Cell.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "EntityUser.h"
typedef void (^ContentsClickCall)(EntityUser *user);
@interface CTM_Contents_Cell : UITableViewCell{
    @protected ContentsClickCall xmethod;
}
-(void) setEntityUser:(EntityUser*) user;
-(void) setContentsClickCall:(ContentsClickCall) method;
@end
