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

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) UICollectionView *selectDayCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    self.title = [dateFormatter stringFromDate:[NSDate date]];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.selectDayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    self.selectDayCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.selectDayCollectionView];
    [collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.selectDayCollectionView.collectionViewLayout = collectionViewFlowLayout;
    self.selectDayCollectionView.backgroundColor = [UIColor blueDark];
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.selectDayCollectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.selectDayCollectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.selectDayCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.selectDayCollectionView.heightAnchor constraintEqualToConstant:60]
                                              ]
     ];
    self.selectDayCollectionView.delegate = self;
    self.selectDayCollectionView.dataSource = self;
    
    [self.selectDayCollectionView registerClass:[DayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCell"];
    
    [self updateAuthorizationStatusToAccessEventStore];
    
}

- (NSArray *)fetchCalendarEventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSPredicate *fetchCalendarEvents = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *array = [self.eventStore eventsMatchingPredicate:fetchCalendarEvents];
    return array;
}

- (void)fetchCalendarEventForEndOfDay {
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSArray *eventArray = [self fetchCalendarEventsFromDate:[NSDate date] toDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
}

- (void)fetchCalendarEventsForWeek {
    NSDateComponents *componentsStartWeek = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    [componentsStartWeek setDay:componentsStartWeek.day - componentsStartWeek.weekday + 2];
    [componentsStartWeek setHour:0];
    [componentsStartWeek setMinute:0];
    [componentsStartWeek setSecond:0];
    NSDateComponents *componentsEndWeek = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    [componentsEndWeek setDay:componentsEndWeek.day + (7 - componentsEndWeek.weekday) + 1];
    [componentsEndWeek setHour:23];
    [componentsEndWeek setMinute:59];
    [componentsEndWeek setSecond:59];
    NSArray *eventArray = [self fetchCalendarEventsFromDate:[[NSCalendar currentCalendar] dateFromComponents:componentsStartWeek] toDate:[[NSCalendar currentCalendar] dateFromComponents:componentsEndWeek]];
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
            [self fetchCalendarEventsForWeek];
            break;
        }
        case EKAuthorizationStatusNotDetermined: {
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self fetchCalendarEventsForWeek];
                                                });
                                            }];
            break;
        }
    }
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DayCollectionViewCell";
    DayCollectionViewCell *cell = (DayCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    cell.weekDaylabel.text = @"BT";
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
