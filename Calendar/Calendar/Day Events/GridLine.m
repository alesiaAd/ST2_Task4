//
//  GridLine.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "GridLine.h"
#import "UIColor+extensions.h"

@implementation GridLine

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CAShapeLayer *dashLine = [CAShapeLayer layer];
        dashLine.strokeColor = [UIColor grayLight].CGColor;
        dashLine.fillColor = nil;
        dashLine.lineDashPattern = @[@2, @5];
        dashLine.frame = self.bounds;
        dashLine.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        [self.layer addSublayer:dashLine];
    }
    return self;
}

@end
