//
//  DateEventsModel.h
//  Calendar
//
//  Created by Alesia Adereyko on 29/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateEventsModel : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *eventsArray;

@end
