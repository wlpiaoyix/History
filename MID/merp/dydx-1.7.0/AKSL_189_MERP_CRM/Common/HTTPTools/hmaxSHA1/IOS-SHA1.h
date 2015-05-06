#import "HashSHA256.h"

#import <CommonCrypto/CommonHMAC.h>
@interface NSString (encrypto)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
- (NSString *) base64;
 
@end