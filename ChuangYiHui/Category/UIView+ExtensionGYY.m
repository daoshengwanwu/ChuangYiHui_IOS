//
//  UIView+ExtensionGYY.m
//  GoldUnion
//
//  Created by Gongyy on 16/11/17.
//  Copyright © 2016年 LEE . All rights reserved.
//

#import "UIView+ExtensionGYY.h"

@implementation UIView (ExtensionGYY)

- (UIViewController *)viewController
{
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
        
    } while (next != nil);
    
    return nil;
}




@end
