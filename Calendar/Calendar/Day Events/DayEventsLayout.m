//
//  DayEventsLayout.m
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import "DayEventsLayout.h"
#import "GridLine.h"
#import "TimeLabel.h"
#import "CurrentTime.h"
#import "EventCollectionViewCell.h"
#import "DayEventViewManager.h"
#import <EventKit/EventKit.h>

static const CGFloat gridLine15minsSpacing = 30;
static const CGFloat gridLine15minsHeight = 0.5;
static const int gridLinesNumber = 60 / 15 * 24;
static const int timeLabelsNumber = gridLinesNumber;
static const CGFloat timeLabelWidth = 60;

@interface DayEventsLayout ()

@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *gridLines;
@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *timeLabels;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *currentTime;
@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *eventItems;
@property (strong, nonatomic) NSMutableArray <UICollectionViewLayoutAttributes *> *allAttributes;

@end

@implementation DayEventsLayout

- (CGSize) collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, gridLinesNumber * gridLine15minsSpacing);
}

- (void)prepareLayout {
    self.allAttributes = [NSMutableArray new];
    
    [self.allAttributes addObject:[self prepareCurrentTime]];
    [self.allAttributes addObjectsFromArray:[self prepareGridLines]];
    [self.allAttributes addObjectsFromArray:[self prepareTimeLabels]];
    [self.allAttributes addObjectsFromArray:[self prepareEventItem]];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes * attr = (UICollectionViewLayoutAttributes *)object;
        return CGRectIntersectsRect(rect, attr.frame);
    }]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.eventItems[indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:NSStringFromClass(GridLine.class)]) {
        return self.gridLines[indexPath.item];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:NSStringFromClass(TimeLabel.class)]) {
        return self.timeLabels[indexPath.item];
    } else if ([elementKind isEqualToString:NSStringFromClass(CurrentTime.class)]) {
        return self.currentTime;
    }
    return nil;
}

- (NSMutableArray *)prepareGridLines {
    self.gridLines = [NSMutableArray new];
    for (int i = 0; i < gridLinesNumber; ++i) {
        UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(GridLine.class) withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attr.frame = CGRectMake(0, i * gridLine15minsSpacing, self.collectionView.bounds.size.width, gridLine15minsHeight);
        [self.gridLines addObject:attr];
    }
    return self.gridLines;
}

- (NSMutableArray *)prepareTimeLabels {
    self.timeLabels = [NSMutableArray new];
    for (int i = 0; i < timeLabelsNumber; ++i) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:NSStringFromClass(TimeLabel.class) withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attr.frame = CGRectMake(0, i * gridLine15minsSpacing, timeLabelWidth, gridLine15minsSpacing);
        if (CGRectIntersectsRect(self.currentTime.frame, attr.frame)) {
            attr.hidden = YES;
        } else {
            attr.hidden = NO;
        }
        [self.timeLabels addObject:attr];
    }
    return self.timeLabels;
}

- (UICollectionViewLayoutAttributes *)prepareCurrentTime {
    NSDate *currentTime = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:currentTime];
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:NSStringFromClass(CurrentTime.class) withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        attr.frame = CGRectMake(0, gridLine15minsSpacing * components.hour * 4 + gridLine15minsSpacing * (components.minute / 15.0) - gridLine15minsSpacing / 2, self.collectionView.bounds.size.width, gridLine15minsSpacing);
        [self.timeLabels addObject:attr];
    self.currentTime = attr;
    return self.currentTime;
}

- (NSMutableArray *)prepareEventItem {
    self.eventItems = [NSMutableArray new];
    DayEventViewManager *dataSource = (DayEventViewManager *)self.collectionView.dataSource;
    for (int i = 0; i < dataSource.model.eventsArray.count; ++i) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        EKEvent *event = dataSource.model.eventsArray[i];
        NSDateComponents *componentsStartEvent = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:event.startDate];
        NSDateComponents *componentsEndEvent = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:event.endDate];
        CGFloat eventStartY = gridLine15minsSpacing * componentsStartEvent.hour * 4 + gridLine15minsSpacing * (componentsStartEvent.minute / 15.0);
        CGFloat eventEndY = gridLine15minsSpacing * componentsEndEvent.hour * 4 + gridLine15minsSpacing * (componentsEndEvent.minute / 15.0);
        attr.frame = CGRectMake(timeLabelWidth, eventStartY, self.collectionView.bounds.size.width - timeLabelWidth - 5, eventEndY - eventStartY - 2);
        [self.eventItems addObject:attr];
//        for (UICollectionViewLayoutAttributes *attribute in self.eventItems) {
//            if (CGRectIntersectsRect(attr.frame, attribute.frame)) {
//                attr.frame.size = CGSizeMake(attr.frame.size.width / 2.0, attr.frame.size.height);
//                attribute.frame.size.width = attribute.frame.size.width / 2;
//            }
//        }
    }
    return self.eventItems;
}
@end
