//
//  SWLGUtils.h
//  DoFunNew
//
//  Created by mac on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN





@interface SWLGUtils : NSObject


/**
 生成十六进制AES 秘钥
 */
+ (NSString *)random128BitAESKey;

/**
 data转换为十六进制的string
 */
+ (NSString *)hexStringFromData:(NSData *)myD;

/**
 16进制字符串转data
 */
+  (NSData *)convertHexStrToData:(NSString *)str;


/**
 先对加密后生成的byte数组加密，加密后转成16进制字符串
 */
+  (NSString *)md5ForBytesToLower32Bate:(NSString *)str;


+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString;

+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url;

+ (NSString *)hmcloud_generateCToken:(NSString * )pkgName
                          withUserId:(NSString *)userId
                          withUserToken:(NSString *)userToken
                     withAccessKey:(NSString *)accessKey
                          withAccessKeyId:(NSString *)accessKeyId
                       withChannelId:(NSString *)channelId;

+(NSString *)hexTobyte:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
