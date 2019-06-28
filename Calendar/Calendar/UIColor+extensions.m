//
//  UIColor+extensions.m
//  Calendar
//
//  Created by Alesia Adereyko on 28/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "UIColor+extensions.h"

@implementation UIColor (CalendarColor)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red   = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue  = ((baseValue >> 8)  & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0)  & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *) grayDark {
    return [self colorFromHexString:@"383838"];
}

+ (UIColor *) gray {
    return [self colorFromHexString:@"8590A6"];
}

+ (UIColor *) grayLight {
    return [self colorFromHexString:@"C7C7C8"];
}

+ (UIColor *) blueDark {
    return [self colorFromHexString:@"037594"];
}

+ (UIColor *) red {
    return [self colorFromHexString:@"FC6769"];
}

@end
