//
//  OfflinePackageURLProtocol.h
//  OfflinePackage
//
//  Created by 刘思源 on 2022/11/30.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface OfflinePackageURLProtocol : NSURLProtocol

@property (class, strong, nonatomic) NSString *pkgRoot;

@end

NS_ASSUME_NONNULL_END
