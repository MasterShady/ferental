//
//  SwiftLoader.m
//  ferental
//
//  Created by 刘思源 on 2022/12/27.
//

#import "SwiftLoader.h"
#import <objc/runtime.h>

// SwiftLoader.m



@implementation SwiftLoader

+ (void)load {
    SEL selector = @selector(swift_load);
    
    int numClasses = objc_getClassList(NULL, 0);
    Class* classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    for (int i = 0; i < numClasses; i++) {
        Class class = classes[i];
        Method method = class_getClassMethod(class, selector);
        if (method != NULL) {
            IMP imp = method_getImplementation(method);
            ((id (*)(Class, SEL))imp)(class, selector);
        }
    }
    free(classes);
}

@end
