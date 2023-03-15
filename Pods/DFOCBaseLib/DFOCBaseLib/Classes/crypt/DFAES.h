//
//  DFAES128.h
//  zuhaowan
//
//  Created by mac on 2021/4/21.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface DFAES : NSObject

/**
 13  *  AES128加密ECB
 14  *
 15  *  @param plainText 原文
 16  *
 17  *  @return 加密好的字符串
 18  */
+ (NSString *)AES128EncryptECB:(NSString *)plainText key:(NSString *)key;
/**
 21  *  AES128解密ECB
 22  *
 23  *  @param encryptText 密文
 24  *
 25  *  @return 明文
 26  */
+ (NSString *)AES128DecryptECB:(NSString *)encryptText key:(NSString *)key;


/**
 13  *  AES256加密ECB
 14  *
 15  *  @param plainText 原文
 16  *
 17  *  @return 加密好的字符串
 18  */
+ (NSString *)AES256EncryptECB:(NSString *)plainText key:(NSString *)key;
/**
 21  *  AES256解密ECB
 22  *
 23  *  @param encryptText 密文
 24  *
 25  *  @return 明文
 26  */
+ (NSString *)AES256DecryptECB:(NSString *)encryptText key:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
