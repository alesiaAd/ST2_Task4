//
//  DayEventsLayout.h
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayEventsLayout : UICollectionViewLayout

+ (CGFloat) yOffsetForDate:(NSDate *)date;

@end
