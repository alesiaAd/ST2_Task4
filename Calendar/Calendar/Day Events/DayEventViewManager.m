//
//  DayEventViewManager.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "DayEventViewManager.h"
#import "TimeLabel.h"

@interface DayEventViewManager ()

@end

@implementation DayEventViewManager

- (void) setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UICollectionViewCell new];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:NSStringFromClass(TimeLabel.class)]) {
        TimeLabel * timeLabel = [collectionView dequeueReusableSupplementaryViewOfKind:NSStringFromClass(TimeLabel.class) withReuseIdentifier:NSStringFromClass(TimeLabel.class) forIndexPath:indexPath];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *time = [formatter dateFromString:@"00:00"];
        time = [time dateByAddingTimeInterval:60*15*indexPath.item];
        timeLabel.timeLabel.text = [formatter stringFromDate:time];
        return timeLabel;
    } else {
        NSAssert(YES, @"Impossible case. Seems like introducing new kind of supplementary view, but not handling here. Return empty view to avoid crashes on production");
        return [UICollectionReusableView new];
    }
}

@end
