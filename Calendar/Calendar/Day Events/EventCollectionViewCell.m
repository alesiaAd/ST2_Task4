//
//  EventCollectionViewCell.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "EventCollectionViewCell.h"

static const CGFloat padding = 5.0;

@implementation EventCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        
        self.nameLabel = [UILabel new];
        self.nameLabel.numberOfLines = 0;
        [self.nameLabel sizeToFit];
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.nameLabel];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:padding],
                                                  [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-padding],
                                                  [self.nameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:padding],
                                                  [self.nameLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-padding]
                                                  ]];
    }
    return self;
}

@end
