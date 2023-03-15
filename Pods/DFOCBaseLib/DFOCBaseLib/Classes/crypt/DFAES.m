//
//  DFAES128.m
//  zuhaowan
//
//  Created by mac on 2021/4/21.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import "DFAES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+JFUTF8.h"
@implementation DFAES

//AES ECB 加密
+ (NSString *)AES128EncryptECB:(NSString *)plainText key:(NSString *)key {
    NSData *key_data = [NSData  convertHexStrToData:key];
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,   //这里用的 NoPadding的填充方式
                                          //除此以外还有 kCCOptionPKCS7Padding 和 kCCOptionECBMode
                                          key_data.bytes,
                                          kCCKeySizeAES128,
                                          NULL,
                                          data.bytes,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [NSData hexStringFromData:resultData];
    }else {
        NSLog(@"加密失败");
    }
    free(buffer);
    return nil;
}

//AES ECB 解密
+ (NSString *)AES128DecryptECB:(NSString *)encryptText key:(NSString *)key {
    NSData *key_data = [NSData convertHexStrToData:key];
    NSData *data = [NSData convertHexStrToData:encryptText];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode, //加密和解密的填充模式必须一致
                                          [key_data bytes],
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        NSString *str = [resultData utf8String];
        
        return str;
        
    }
    free(buffer);
    return nil;
}
//AES ECB 加密
+ (NSString *)AES256EncryptECB:(NSString *)plainText key:(NSString *)key {
    NSData *key_data = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,   //这里用的 NoPadding的填充方式
                                          //除此以外还有 kCCOptionPKCS7Padding 和 kCCOptionECBMode
                                          key_data.bytes,
                                          kCCKeySizeAES256,
                                          NULL,
                                          data.bytes,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        
        return [[resultData base64EncodedDataWithOptions:0] utf8String];
    }else {
        NSLog(@"加密失败");
    }
    free(buffer);
    return nil;
}

//AES ECB 解密
+ (NSString *)AES256DecryptECB:(NSString *)encryptText key:(NSString *)key {
    
    NSData *key_data = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options: NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode, //加密和解密的填充模式必须一致
                                          [key_data bytes],
                                          kCCKeySizeAES256,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted ];
        
        NSString *str = [resultData utf8String];
        
        return str;
        
    }
    free(buffer);
    return nil;
}
@end
