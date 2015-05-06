//
//  MADE_COMMON.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-28.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "MADE_COMMON.h"

@implementation MADE_COMMON
+(NSString*) parsetAddTag:(NSString*) tag Url:(NSString*) url{
    int index =  [url intLastIndexOf:'.'];
    NSString *suffix = [url substringFromIndex:index];
    return [NSString stringWithFormat:@"%@-%@%@",[[url substringFromIndex:0] substringToIndex:index],tag,suffix];
}
+(UIImage*) pasetImage110:(UIImage*) image{
    UIImage *tempImage2 = COMMON_CUTIMG(image);
    CGSize size = tempImage2.size;
    tempImage2  = [tempImage2 setImageSize:CGSizeMake(110, 110*size.height/size.width)];
    UIImage *image01 = [tempImage2 setImageSize:CGSizeMake(110, 110*size.height/size.width)];
    image01 = [image01 cutImage:CGRectMake(0, (image01.size.height-110)/2, 110, 110)];
    return image01;
}
+(void) pasetImageAddWrite110ak640:(NSString*) url{
    NSString *path640 = [MADE_COMMON parsetAddTag:@"640" Url:url];
    NSString *path110 = [MADE_COMMON parsetAddTag:@"110" Url:url];
    NSFileManager *f = [NSFileManager defaultManager];
    UIImage *image = [UIImage imageWithContentsOfFile:url];
    if(image){
        if(![f fileExistsAtPath:path640]){
            UIImage *image640 = COMMON_CUTIMG(image);
            NSData *data = UIImageJPEGRepresentation(image640, 1.0f);
            [data writeToFile:path640 atomically:YES];
        }
        if(![f fileExistsAtPath:path110]){
            UIImage *image110 = [MADE_COMMON pasetImage110:image];
            NSData *data = UIImageJPEGRepresentation(image110, 1.0f);
            [data writeToFile:path110 atomically:YES];
        }
    }
}
+(void) deleteImage110ak640:(NSString*) url{
    NSString *path640 = [MADE_COMMON parsetAddTag:@"640" Url:url];
    NSString *path110 = [MADE_COMMON parsetAddTag:@"110" Url:url];
    NSFileManager *f = [NSFileManager defaultManager];
    if([f fileExistsAtPath:url]){
        [f removeItemAtPath:url error:NULL];
    }
    if([f fileExistsAtPath:path640]){
        [f removeItemAtPath:path640 error:NULL];
    }
    if([f fileExistsAtPath:path110]){
        [f removeItemAtPath:path110 error:NULL];
    }
}
@end
