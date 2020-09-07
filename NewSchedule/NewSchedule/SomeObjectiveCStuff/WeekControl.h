//
//  WeekControl.h
//  NewSchedule
//
//  Created by IvanLyuhtikov on 3.09.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WeekControl;


@protocol WeekControlDelegate <NSObject>

- (NSArray<NSString *> *)dataForDays:(WeekControl *)weekControl;
- (void)convenientPage:(UIButton *)sender;

@end

@interface WeekControl : UIControl

@property (nonatomic, weak) id<WeekControlDelegate> weekDelegate;
@property (nonatomic, strong) UIColor *colorOfDays;
@property (nonatomic, assign) NSInteger currentDay;

@end

NS_ASSUME_NONNULL_END
