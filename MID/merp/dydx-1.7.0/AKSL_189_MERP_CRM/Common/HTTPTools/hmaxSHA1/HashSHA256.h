#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface HashSHA256 : NSObject {


}

 - (NSString *) hashedValue :(NSString *) key andData: (NSString *) data ; 

@end