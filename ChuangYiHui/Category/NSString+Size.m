//
//  NSString+Size.m
//  GoldUnion
//
//  Created by GYY on 20/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font
{
    CGSize resLabelSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        resLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
        
    }else{
        resLabelSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return resLabelSize;
}

@end
