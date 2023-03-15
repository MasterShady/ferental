#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LDDemoDefines.h"
#import "NTESApproveMsgController.h"
#import "NTESDottedLineProgress.h"
#import "NTESLDMainViewController.h"
#import "NTESLiveDetectView.h"
#import "NTESTimeoutToastView.h"
#import "NTESToastView.h"
#import "UIColor+NTESLiveDetect.h"
#import "UIImageView+NTESLDGif.h"
#import "AgreeAlertView.h"
#import "ApproveAlertView.h"
#import "DFFaceVerifyManager.h"
#import "DFFileUtil.h"

FOUNDATION_EXPORT double DFFaceVerifyLibVersionNumber;
FOUNDATION_EXPORT const unsigned char DFFaceVerifyLibVersionString[];

