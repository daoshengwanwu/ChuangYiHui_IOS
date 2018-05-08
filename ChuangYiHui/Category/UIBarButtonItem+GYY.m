//
//  UIBarButtonItem+GYY.m
//  GoldUnion
//
//  Created by GYY on 14/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "UIBarButtonItem+GYY.h"

@implementation UIBarButtonItem (GYY)

- (id)initWithIcon:(NSString *)icon size:(CGSize)size highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *backImg = [UIImage imageNamed:icon];
    [btn setBackgroundImage:backImg forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    
    btn.bounds = CGRectMake(0, 0, size.width,size.height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
    
}

+ (id)initWithIcon:(NSString *)icon size:(CGSize)size highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon size:size highlightedIcon:highlighted target:target action:action];
}

@end
