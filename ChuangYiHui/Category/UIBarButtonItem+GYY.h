//
//  UIBarButtonItem+GYY.h
//  GoldUnion
//
//  Created by GYY on 14/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (GYY)

- (id)initWithIcon:(NSString *)icon size:(CGSize)size highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
+ (id)initWithIcon:(NSString *)icon size:(CGSize)size highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

@end
