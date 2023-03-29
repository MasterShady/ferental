//
//  NSBundle+AssociatedBundle.h
//  PKGModule
//
//  Created by 刘思源 on 2023/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (AssociatedBundle)

+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;

@end

NS_ASSUME_NONNULL_END
