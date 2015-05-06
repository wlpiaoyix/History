//
//  BSB_SearchBarView.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallBackClickSearchBarSearch)(NSString *text);
typedef void (^CallBackClickSearchBarClear)(void);
@interface BSB_SearchBarView : UIView<UITextFieldDelegate>
+(id) getNewInstance;
-(void) setCallBackSearch:(CallBackClickSearchBarSearch) search;
-(void) setcallBackClear:(CallBackClickSearchBarClear) clear;
-(UITextField*) getTextField;
@end
