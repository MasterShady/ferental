//
//  DFFileUtil.h
//  DFFaceVerifyLib
//
//  Created by mac on 2021/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const DFPublicSourceBundle;
extern NSString * const DFNeteasySourceBundle;

@interface DFFileUtil : NSObject


+(UIImage *)imageWithName:(NSString *)name
           withBundleName:(NSString *)bundleName;

+(UIImage *)imageWithName:(NSString *)name
           withBundleName:(NSString *)bundleName
          withAdjustScale:(BOOL)adjust;

+(UIImage *)imageWithName:(NSString *)name
           withBundleName:(NSString *)bundleName
          withAdjustScale:(BOOL)adjust
                 withType:(NSString *)type;

+(NSString *)filePathWithName:(NSString *)name
               withBundleName:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
