//
//  DayEventViewManager.h
//  Calendar
//
//  Created by Alesia Adereyko on 30/06/2019.
//  Copyright © 2019 Alesia Adereyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DayEventViewManager : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;

@end
