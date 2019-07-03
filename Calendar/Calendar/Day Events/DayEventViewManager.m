//
//  DayEventViewManager.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "DayEventViewManager.h"
#import "TimeLabel.h"
#import "CurrentTime.h"
#import "EventCollectionViewCell.h"
#import <EventKit/EventKit.h>

@interface DayEventViewManager ()

@end

@implementation DayEventViewManager

- (void) setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:EventCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(EventCollectionViewCell.class)];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)update {
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCollectionViewCell *cell = (EventCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(EventCollectionViewCell.class) forIndexPath:indexPath];
    if (self.model.eventsArray.count > 0) {
        EKEvent *event = self.model.eventsArray[indexPath.item];
        cell.nameLabel.text = event.title;
        cell.backgroundColor = [[UIColor colorWithCGColor:event.calendar.CGColor] colorWithAlphaComponent:0.5];
        cell.layer.zPosition = 1;
        
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.eventsArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    if ([kind isEqualToString:NSStringFromClass(TimeLabel.class)]) {
        TimeLabel * timeLabel = [collectionView dequeueReusableSupplementaryViewOfKind:NSStringFromClass(TimeLabel.class) withReuseIdentifier:NSStringFromClass(TimeLabel.class) forIndexPath:indexPath];
        NSDate *time = [formatter dateFromString:@"00:00"];
        time = [time dateByAddingTimeInterval:60 * 15 * indexPath.item];
        timeLabel.timeLabel.text = [formatter stringFromDate:time];
        if ([[formatter stringFromDate:time] hasSuffix:@"00"]) {
            timeLabel.timeLabel.hidden = NO;
        } else {
            timeLabel.timeLabel.hidden = YES;
        }
        for (EKEvent *event in self.model.eventsArray) {
            if ([timeLabel.timeLabel.text isEqualToString:[formatter stringFromDate:event.startDate]]) {
                timeLabel.timeLabel.hidden = NO;
            } else if ([[[formatter stringFromDate:event.startDate] substringToIndex:3] integerValue] == [[timeLabel.timeLabel.text substringToIndex:3] integerValue] && [[timeLabel.timeLabel.text substringFromIndex:3] integerValue] - [[[formatter stringFromDate:event.startDate] substringFromIndex:3] integerValue] < 0) {
                timeLabel.timeLabel.hidden = NO;
                timeLabel.timeLabel.text = [formatter stringFromDate:event.startDate];
            }
        }
        return timeLabel;
    } else if ([kind isEqualToString:NSStringFromClass(CurrentTime.class)]) {
        CurrentTime * currentTime = [collectionView dequeueReusableSupplementaryViewOfKind:NSStringFromClass(CurrentTime.class) withReuseIdentifier:NSStringFromClass(CurrentTime.class) forIndexPath:indexPath];
        currentTime.currentTimeLabel.text = [formatter stringFromDate:[NSDate date]];
        NSDateComponents *componentsCurrent = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
        NSDateComponents *componentsModel = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:self.model.date];
        if (componentsCurrent.day != componentsModel.day || componentsCurrent.month != componentsModel.month || componentsCurrent.year != componentsModel.year) {
            currentTime.hidden = YES;
        } else {
            currentTime.hidden = NO;
        }
        currentTime.layer.zPosition = 2;
        return currentTime;
    } else {
        NSAssert(YES, @"Impossible case. Seems like introducing new kind of supplementary view, but not handling here. Return empty view to avoid crashes on production");
        return [UICollectionReusableView new];
    }
}

@end
