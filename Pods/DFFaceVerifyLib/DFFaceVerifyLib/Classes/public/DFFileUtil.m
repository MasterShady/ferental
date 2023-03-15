//
//  DFFileUtil.m
//  DFFaceVerifyLib
//
//  Created by mac on 2021/12/17.
//

#import "DFFileUtil.h"

NSString * const DFPublicSourceBundle = @"DFFacePublicSource";
NSString * const DFNeteasySourceBundle = @"DFFaceNeteasySource";


@implementation DFFileUtil

+(UIImage *)imageWithName:(NSString *)name
           withBundleName:(NSString *)bundleName{
    
    return [self imageWithName:name withBundleName:bundleName withAdjustScale:true withType:@"png"];
}

+(UIImage *)imageWithName:(NSString *)name withBundleName:(NSString *)bundleName withAdjustScale:(BOOL)adjust{
    
    return [self imageWithName:name withBundleName:bundleName withAdjustScale:adjust withType:@"png"];
}


+(NSString *)filePathWithName:(NSString *)name
               withBundleName:(NSString *)bundleName{
    
    NSURL * bundleUrl = [[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle" subdirectory:nil] URLByAppendingPathComponent:name];
    
    return  bundleUrl.path;
}

+ (UIImage *)imageWithName:(NSString *)name withBundleName:(NSString *)bundleName withAdjustScale:(BOOL)adjust withType:(NSString *)type{
    
    
    NSURL * bundleUrl = [[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle" subdirectory:nil] URLByAppendingPathComponent:name];
    
    NSString * adjust_Destription = @"";
    
    if (adjust == true) {
        
        adjust_Destription = [NSString stringWithFormat:@"@%dx",(int)UIScreen.mainScreen.scale];
    }
    
   
    NSString * path = [NSString stringWithFormat:@"%@%@.%@",bundleUrl.path,adjust_Destription,type];
    
    return  [[UIImage alloc] initWithContentsOfFile:path];
}

@end
