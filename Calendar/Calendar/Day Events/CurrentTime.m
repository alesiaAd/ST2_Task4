//
//  CurrentTime.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "CurrentTime.h"
#import "UIColor+extensions.h"

const CGFloat labelWidth = 50.0;
const CGFloat labelLeadingMarging = 10.0;
const CGFloat lineHeight = 2.0;

@implementation CurrentTime

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentTimeLabel = [UILabel new];
        self.currentTimeLabel.font = [UIFont systemFontOfSize:15];
        self.currentTimeLabel.textColor = [UIColor grayDark];
        self.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.currentTimeLabel];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.currentTimeLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:labelLeadingMarging],
                                                  [self.currentTimeLabel.widthAnchor constraintEqualToConstant:labelWidth],
                                                  [self.currentTimeLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                                  [self.currentTimeLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor]
                                                  ]];
        
        self.currentTimeLine = [UIView new];
        self.currentTimeLine.backgroundColor = [UIColor red];
        self.currentTimeLine.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.currentTimeLine];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.currentTimeLine.leadingAnchor constraintEqualToAnchor:self.currentTimeLabel.trailingAnchor],
                                                  [self.currentTimeLine.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                                                  [self.currentTimeLine.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                                  [self.currentTimeLine.heightAnchor constraintEqualToConstant:lineHeight]
                                                  ]];
    }
    return self;
}

@end
