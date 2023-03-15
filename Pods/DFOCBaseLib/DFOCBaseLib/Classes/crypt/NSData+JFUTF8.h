//
//  NSData+JFUTF8.h
//  AES128
//
//  Created by mac on 2021/4/15.
//  Copyright © 2021 lihaiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (JFUTF8)

- (NSString *)utf8String;

+ (NSData *)convertHexStrToData:(NSString *)str;

+ (NSString *)hexStringFromData:(NSData *)myD;

@end

NS_ASSUME_NONNULL_END
