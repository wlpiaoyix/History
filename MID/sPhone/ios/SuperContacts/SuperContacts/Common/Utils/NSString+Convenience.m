//
//  NSString+Convenience.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NSString+Convenience.h"

@implementation NSString (Convenience)

-(NSDate*) dateFormateString:(NSString*) formatePattern{
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:formatePattern==nil?@"yyyy-MM-dd HH:mm:ss":formatePattern];
    return [dft dateFromString:self];
}
-(bool) stringEndWith:(NSString*) suffix{
    if(![NSString isEnabled:suffix]){
        return YES;
    }
    int formIndex = [self length]-[suffix length];
    if(formIndex>self.length){return NO;}
    if([suffix isEqual:[self substringFromIndex: formIndex]])return YES;
    else return NO;
}

-(bool) stringStartWith:(NSString*) suffix{
    if(![NSString isEnabled:suffix]){
        return YES;
    }
    int toIndex = [suffix length];
    if(toIndex>self.length){return NO;}
    if([suffix isEqual:[self substringToIndex: toIndex]])return YES;
    else return NO;

}

-(int) intLastIndexOf:(char) suffix{
    const char* temp = [self UTF8String];
    for (int i=strlen(temp);i>0;i--) {
        char c = temp[i];
        if(c==suffix){
            return i;
        }
    }
    return 0;
}
+(bool) isEnabled:(id) target{
    if(!target||target==nil||target==[NSNull null]||[@"" isEqual:target])return NO;
    else return YES;
}
+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
