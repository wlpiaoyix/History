#import "HashSHA256.h"

#import <CommonCrypto/CommonHMAC.h>


@implementation HashSHA256


- (NSString *) hashedValue :(NSString *) key andData: (NSString *) data {
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSString *hash;

    NSMutableString* output = [NSMutableString   stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;

}

@end