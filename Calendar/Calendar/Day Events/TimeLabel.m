//
//  TimeLabel.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "TimeLabel.h"
#import "UIColor+extensions.h"

@implementation TimeLabel

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.timeLabel = [UILabel new];
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textColor = [UIColor grayDark];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.timeLabel];
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.timeLabel.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:10],
                                                  [self.timeLabel.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],
                                                  [self.timeLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
                                                  ]];
    }
    return self;
}

@end
