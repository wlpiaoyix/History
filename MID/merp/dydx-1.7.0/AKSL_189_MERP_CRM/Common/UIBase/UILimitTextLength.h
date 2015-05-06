//
//  UILimitTextLength.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTReParser;

@interface UILimitTextLength : UITextView <UITextViewDelegate>{
 NSInteger selfLimitTextLength;
    NSString *_lastAcceptedValue;
    WTReParser *_parser; 
}

-(void)limitTextLength:(NSInteger)limitTextLength;
//@property (strong,nonatomic) NSString * placeholder;
@property (strong, nonatomic) NSString *pattern;

@end
