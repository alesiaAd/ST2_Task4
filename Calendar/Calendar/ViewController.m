//
//  ViewController.m
//  Calendar
//
//  Created by Alesia Adereyko on 28/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "ViewController.h"
#import "DayCollectionViewCell.h"
#import "UIColor+extensions.h"
#import "DateEventsModel.h"
#import "DayEventViewManager.h"
#import "DayEventsLayout.h"
#import "GridLine.h"
#import "TimeLabel.h"
#import "CurrentTime.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) UICollectionView *selectDayCollectionView;
@property (strong, nonatomic) NSMutableArray <DateEventsModel *> *dateEventsModelsArray;
@property (strong, nonatomic) UICollectionView *dayEventsCollectionView;
@property (strong, nonatomic) DayEventViewManager *dayEventViewManager;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    self.title = [dateFormatter stringFromDate:[NSDate date]];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.selectDayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    self.selectDayCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.selectDayCollectionView];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.selectDayCollectionView.collectionViewLayout = collectionViewFlowLayout;
    self.selectDayCollectionView.backgroundColor = [UIColor blueDark];
    [self.selectDayCollectionView setPagingEnabled:YES];
    
    DayEventsLayout * dayEventsLayout = [DayEventsLayout new];
    self.dayEventsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:dayEventsLayout];
    self.dayEventsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.dayEventsCollectionView];
    self.dayEventsCollectionView.backgroundColor = [UIColor whiteColor];
    self.dayEventViewManager = [DayEventViewManager new];
    self.dayEventViewManager.collectionView = self.dayEventsCollectionView;
    
    [dayEventsLayout registerClass:GridLine.class forDecorationViewOfKind:NSStringFromClass(GridLine.class)];
    [self.dayEventsCollectionView registerClass:TimeLabel.class forSupplementaryViewOfKind:NSStringFromClass(TimeLabel.class) withReuseIdentifier:NSStringFromClass(TimeLabel.class)];
    [self.dayEventsCollectionView registerClass:CurrentTime.class forSupplementaryViewOfKind:NSStringFromClass(CurrentTime.class) withReuseIdentifier:NSStringFromClass(CurrentTime.class)];
    
    self.selectDayCollectionView.delegate = self;
    self.selectDayCollectionView.dataSource = self;
    
    [self.selectDayCollectionView registerClass:[DayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCell"];
    
    self.dateEventsModelsArray = [NSMutableArray new];
    
    [self setupConstraints];
    [self updateAuthorizationStatusToAccessEventStore];
    
    NSUInteger index = [self.dateEventsModelsArray indexOfObjectPassingTest:
                        ^BOOL(DateEventsModel *model, NSUInteger idx, BOOL *stop)
                        {
                            NSDateComponents *componentsModel = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:model.date];
                            NSDateComponents *componentsCurrent = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
                            return componentsModel.day == componentsCurrent.day && componentsModel.month == componentsCurrent.month && componentsModel.year == componentsCurrent.year;
                        }
                        ];
    
    [self.selectDayCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    self.dayEventViewManager.model = self.dateEventsModelsArray[index];
}

- (void) setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
                                              [self.selectDayCollectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.selectDayCollectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.selectDayCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.selectDayCollectionView.heightAnchor constraintEqualToConstant:60]
                                              ]
     ];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.dayEventsCollectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.dayEventsCollectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.dayEventsCollectionView.topAnchor constraintEqualToAnchor:self.selectDayCollectionView.bottomAnchor],
                                              [self.dayEventsCollectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]
     ];
}

- (NSArray *)fetchCalendarEventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSPredicate *fetchCalendarEvents = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *array = [self.eventStore eventsMatchingPredicate:fetchCalendarEvents];
    return array;
}

- (NSArray *)fetchCalendarEventForOneDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSArray *eventArray = [self fetchCalendarEventsFromDate:date toDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
    return eventArray;
}

- (void)fetchCalendarEvents:(NSDate *)date weeksAmount:(NSUInteger)amount {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    NSDateComponents *componentsStart = [calendar components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDayAsNumber = [componentsStart weekday];
    weekDayAsNumber = ((weekDayAsNumber + 5) % 7) + 1;
    [componentsStart setDay:componentsStart.day - weekDayAsNumber + 1];
    [componentsStart setHour:0];
    [componentsStart setMinute:0];
    [componentsStart setSecond:0];
    NSDateComponents *componentsEnd = [calendar components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDayAsNumberEnd = [componentsEnd weekday];
    weekDayAsNumberEnd = ((weekDayAsNumberEnd + 5) % 7) + 1;
    [componentsEnd setDay:componentsEnd.day - weekDayAsNumberEnd + 7 * amount];
    [componentsEnd setHour:23];
    [componentsEnd setMinute:59];
    [componentsEnd setSecond:59];
    for (NSInteger i = componentsStart.day; i <= componentsEnd.day; i++) {
        DateEventsModel *model = [DateEventsModel new];
        [componentsStart setDay:i];
        model.date = [[NSCalendar currentCalendar] dateFromComponents:componentsStart];
        model.eventsArray = [[self fetchCalendarEventForOneDay:model.date] mutableCopy];
        [self.dateEventsModelsArray addObject:model];
    }
}

- (void)updateAuthorizationStatusToAccessEventStore {
    self.eventStore = [[EKEventStore alloc] init];
    
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType: EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            break;
        }
        case EKAuthorizationStatusAuthorized: {
            self.isAccessToEventStoreGranted = YES;
            [self fetchCalendarEvents:[NSDate date] weeksAmount:2];
            break;
        }
        case EKAuthorizationStatusNotDetermined: {
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self fetchCalendarEvents:[NSDate date] weeksAmount:2];
                                                });
                                            }];
            break;
        }
    }
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DayCollectionViewCell";
    DayCollectionViewCell *cell = (DayCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self.dateEventsModelsArray[indexPath.item].date];
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale: [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    NSArray * weekdays = [df shortWeekdaySymbols];
    cell.weekDaylabel.text = [weekdays[components.weekday - 1] uppercaseString];
    
    if (self.dateEventsModelsArray[indexPath.item].eventsArray.count == 0) {
        cell.dotView.hidden = YES;
    } else {
        cell.dotView.hidden = NO;
    }
    
    NSInteger selectedWeekDay = 0;
    if (cell.selected) {
        selectedWeekDay = indexPath.item;
    }
    if (components.weekday == selectedWeekDay) {
        cell.selected = YES;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateEventsModelsArray.count;
}

- (CGFloat)widthOfDayCell {
    int cellsPerPage = 7;
    return self.selectDayCollectionView.bounds.size.width / cellsPerPage;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return 7;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self widthOfDayCell], 50);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self fetchCalendarEvents:[[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:self.dateEventsModelsArray.lastObject.date options:0] weeksAmount:1];
    [self.selectDayCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    self.title = [dateFormatter stringFromDate:self.dateEventsModelsArray[indexPath.item].date];
    self.dayEventViewManager.model = self.dateEventsModelsArray[indexPath.item];
    [self.dayEventViewManager.collectionView reloadData];
}
@end
