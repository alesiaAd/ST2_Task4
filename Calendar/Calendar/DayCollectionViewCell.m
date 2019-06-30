//
//  DayCollectionViewCell.m
//  Calendar
//
//  Created by Alesia Adereyko on 28/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "DayCollectionViewCell.h"
#import "UIColor+extensions.h"

@interface DayCollectionViewCell ()

@property (strong, nonatomic) UIView *selectionView;

@end

@implementation DayCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.blueDark;
        
        self.selectionView = [UIView new];
        self.selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.selectionView];
        self.selectionView.backgroundColor = [UIColor red];
        self.selectionView.hidden = YES;
        
        const CGFloat selectionViewDiameter = 50.0;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.selectionView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                                  [self.selectionView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:-5],
                                                  [self.selectionView.widthAnchor constraintEqualToConstant:selectionViewDiameter],
                                                  [self.selectionView.heightAnchor constraintEqualToConstant:selectionViewDiameter],
                                                  ]
         ];
        self.selectionView.layer.cornerRadius = selectionViewDiameter / 2;
        self.selectionView.layer.masksToBounds = YES;
        
        self.dayLabel = [UILabel new];
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dayLabel.font = [UIFont systemFontOfSize:17 weight: UIFontWeightSemibold];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dayLabel];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.dayLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                                  [self.dayLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                                  [self.dayLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],                                                  
                                                  ]
         ];
        
        self.weekDaylabel = [UILabel new];
        self.weekDaylabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.weekDaylabel.font = [UIFont systemFontOfSize:12];
        self.weekDaylabel.textColor = [UIColor whiteColor];
        self.weekDaylabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.weekDaylabel];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.weekDaylabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                                  [self.weekDaylabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                                  [self.weekDaylabel.topAnchor constraintEqualToAnchor:self.dayLabel.bottomAnchor],
                                                  ]
         ];
        
        const CGFloat dotViewDiameter = 5.0;
        self.dotView = [UIView new];
        self.dotView.translatesAutoresizingMaskIntoConstraints = NO;
        self.dotView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.dotView];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.dotView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                                  [self.dotView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                                  [self.dotView.heightAnchor constraintEqualToConstant:dotViewDiameter],
                                                  [self.dotView.widthAnchor constraintEqualToConstant:dotViewDiameter]
                                                  ]
         ];
        
        self.dotView.layer.cornerRadius = dotViewDiameter / 2;
        self.dotView.layer.masksToBounds = YES;
    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.selectionView.hidden = NO;
    } else {
        self.selectionView.hidden = YES;
    }
    
}

@end
