//
//  ViewController.m
//  Calendar
//
//  Created by Alesia Adereyko on 28/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    self.title = [dateFormatter stringFromDate:[NSDate date]];
    
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


@end
