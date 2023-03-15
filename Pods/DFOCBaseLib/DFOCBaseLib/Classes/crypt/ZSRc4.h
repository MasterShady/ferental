//
//  ZSRc4.h
//  haozhuzhushou
//
//  Created by chenhui on 2018/10/27.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSRc4 : NSObject

/**
 加密
 */
char* Encrypt(const char* szSource, const char* szPassWord,int szLen,int szPassLen);

/**
 解密
 */
char* Decrypt(const char* szSource, const char* szPassWord,int szLen,int szPassLen);


// 把十六进制字符串，转为字节码，每两个十六进制字符作为一个字节
unsigned char* HexToByte(const char* szHex,int nLen);

// 把字节码转为十六进制码，一个字节两个十六进制，内部为字符串分配空间
char* ByteToHex(const unsigned char* vByte, const int vLen);


+ (NSString *)swRc4EncryptWithSource:(NSString *)source rc4Key:(NSString *)rc4Key;

+ (NSString *)swRc4DecryptWithSource:(NSString *)source rc4Key:(NSString *)rc4Key;

@end


