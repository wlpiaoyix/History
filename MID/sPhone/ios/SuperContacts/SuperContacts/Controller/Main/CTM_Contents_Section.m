//
//  CTM_Contents_Section.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-20.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_Contents_Section.h"
@interface CTM_Contents_Section()
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@end
@implementation CTM_Contents_Section
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setTitleName:(NSString*) titleName{
    _lableName.text = titleName;
}

@end
