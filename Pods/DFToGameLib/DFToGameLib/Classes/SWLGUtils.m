//
//  SWLGUtils.m
//  DoFunNew
//
//  Created by mac on 2021/6/4.
//

#import "SWLGUtils.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation SWLGUtils

+(NSString *)hexTobyte:(NSString *)str{
    
    
    unsigned char * tmp = SWLG_HexToByte(str.UTF8String, str.length);
    
    if (tmp == NULL) {
        
        return  nil;
    }
    
    return [NSString stringWithCString: tmp encoding:NSUTF8StringEncoding];
}





// 把十六进制字符串，转为字节码，每两个十六进制字符作为一个字节
unsigned char* SWLG_HexToByte(const char* szHex,int nLen)
{
    if(!szHex)
        return NULL;
    
    int iLen = nLen;
    
    if (nLen <= 0 || 0 != nLen%2)
        return NULL;
    
    //unsigned char* pbBuf = new unsigned char[iLen/2+1];  //  ˝æ›ª∫≥Â«¯
    unsigned char* pbBuf = (unsigned char*)malloc(iLen/2+1);
    
    memset(pbBuf,0,iLen/2+1);
    
    int tmp1, tmp2;
    for (int i = 0;i< iLen/2;i ++)
    {
        tmp1 = (int)szHex[i*2] - (((int)szHex[i*2] >= 'A')?'A'-10:'0');
        
        if(tmp1 >= 16)
            return NULL;
        
        tmp2 = (int)szHex[i*2+1] - (((int)szHex[i*2+1] >= 'A')?'A'-10:'0');
        
        if(tmp2 >= 16)
            return NULL;
        
        pbBuf[i] = (tmp1*16+tmp2);
    }
    
    return pbBuf;
}


/**
 生成十六进制AES 秘钥
 */
+  (NSString *)random128BitAESKey {
    unsigned char buf[kCCKeySizeAES128];
    arc4random_buf(buf, sizeof(buf));
    
    NSData *data = [NSData dataWithBytes:buf length:sizeof(buf)];
    
    return [self hexStringFromData:data];
}

/**
 data转换为十六进制的string
 */
+  (NSString *)hexStringFromData:(NSData *)myD {
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

/**
 16进制字符串转data
 */
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || str.length == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

/**
 先对加密后生成的byte数组加密，加密后转成16进制字符串
 */
+  (NSString *)md5ForBytesToLower32Bate:(NSString *)str {
    NSData *data = [self convertHexStrToData:str];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    

    NSData *hexData = [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];

//    NSLog(@"计算MD5签名 sign ==== %@", [self hexStringFromData:hexData]);
    
    return [self hexStringFromData:hexData];
}

/*
 * 字符串转字典（NSString转Dictionary）
 *   parameter
 *     turnString : 需要转换的字符串
 */
+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString
{
    turnString = [turnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //收尾空格
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    turnString = [turnString stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    
    
    NSData *turnData = [turnString dataUsingEncoding:NSUTF8StringEncoding];
    if (turnData != nil) {
        NSError *err;
        NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;

        }
        return turnDic;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"解析数据出错，请重试!");
        });
        return  nil;
    }
    
    
    
}


+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}


+ (NSString *)hmcloud_generateCToken:(NSString * )pkgName
                          withUserId:(NSString *)userId
                          withUserToken:(NSString *)userToken
                     withAccessKey:(NSString *)accessKey
                          withAccessKeyId:(NSString *)accessKeyId
                       withChannelId:(NSString *)channelId{
    
    
    NSData *keyData = [self hexToBytes:accessKey];
    Byte *keyArr = (Byte*)[keyData bytes];

    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@", userId, userToken, pkgName, accessKeyId, channelId];
    NSData *strData = [str dataUsingEncoding:kCFStringEncodingUTF8];

    NSData *aesData = [self AES256EncryptWithKey:(void *)keyArr forData:strData ];//加密后的串
    return [self stringByHashingWithSHA1:aesData];
}


+ (NSData *) hexToBytes:(NSString *)val {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= val.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString * hexStr = [val substringWithRange:range];
        NSScanner * scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSData *) AES256EncryptWithKey:(const void *)key forData:(NSData *)data {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          key, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);

    return nil;
}

+ (NSString *) stringByHashingWithSHA1:(NSData *)data {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}
@end


