//
//  UILimitTextLength.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "UILimitTextLength.h"
#import "WTReParser.h"

@implementation UILimitTextLength

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        _lastAcceptedValue = nil;
        _parser = nil;
        selfLimitTextLength = 140;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delegate = self;
        _lastAcceptedValue = nil;
        _parser = nil;
        selfLimitTextLength = 140;
    }
    return self;
}
-(void)didMoveToSuperview{
    self.delegate = self;
    CGRect frame = CGRectMake(self.frame.size.width-45, self.frame.size.height-30,40, 25);
   UILabel *  limitLengthLabel = [[UILabel alloc]initWithFrame:frame];
    limitLengthLabel.text = [NSString stringWithFormat:@" %d",selfLimitTextLength];
    limitLengthLabel.textAlignment = NSTextAlignmentLeft;
    limitLengthLabel.layer.cornerRadius = 12;
    limitLengthLabel.backgroundColor = [UIColor colorWithRed:0.961 green:0.000 blue:0.635 alpha:1];
    limitLengthLabel.textColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1];
    limitLengthLabel.tag = 1000;
    [self addSubview:limitLengthLabel];
}

- (NSString*)pattern
{
    return _parser.pattern;
}

- (void)setPattern:(NSString *)pattern
{ 
    if (pattern == nil || [pattern isEqualToString:@""])
        _parser = nil;
    else
        _parser = [[WTReParser alloc] initWithPattern:pattern];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{}
-(void)textViewDidEndEditing:(UITextView *)textView{}

-(void)textViewDidChange:(UITextView *)textView{
     if (selfLimitTextLength >= 0) {
        if(textView.text.length > selfLimitTextLength){
            textView.text = [textView.text substringToIndex:selfLimitTextLength];
        }
    }
    if (_parser == nil) {
        UILabel * limitLengthLabel = (UILabel *)[self viewWithTag:1000];
        if (limitLengthLabel) {
            limitLengthLabel.text = [NSString stringWithFormat:@" %d",selfLimitTextLength-textView.text.length];
        }
        return;
    }
    
    __block WTReParser *localParser = _parser;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *formatted = [localParser reformatString:textView.text];
        if (formatted == nil)
            formatted = _lastAcceptedValue;
        else
            _lastAcceptedValue = formatted;
        NSString *newText = formatted;
        if (![textView.text isEqualToString:newText]) {
            textView.text = formatted;
        }
    });
    UILabel * limitLengthLabel = (UILabel *)[self viewWithTag:1000];
    if (limitLengthLabel) {
        limitLengthLabel.text = [NSString stringWithFormat:@" %d",selfLimitTextLength-textView.text.length];
    }
}

-(void)limitTextLength:(NSInteger)limitTextLength{
    selfLimitTextLength = limitTextLength;
    self.text = @"";
    UILabel * limitLengthLabel = (UILabel *)[self viewWithTag:1000];
    if (limitLengthLabel) {
        limitLengthLabel.text = [NSString stringWithFormat:@" %d",selfLimitTextLength-self.text.length];
    }
}
@end
