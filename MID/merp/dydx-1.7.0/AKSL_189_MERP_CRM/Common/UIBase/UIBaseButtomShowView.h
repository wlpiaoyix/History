//
//  UIBaseButtomShowView.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 12/12/13.
//  Copyright (c) 2013 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBaseButtomShowView : UIView
-(void) showText:(NSString*) text;
-(void) setTextSize:(float) textSize;
-(void) setFontName:(NSString*) fontName;
-(void) setTextAlignment:(int)textAlignment;
-(void) setBackgroundColorLable:(UIColor*) backgroundColorLable;
-(void) setLableAque:(float)lableAque;
@end
