//
//  MultiDirectionOrganizedScroll.h
//  NewSchedule
//
//  Created by IvanLyuhtikov on 13.08.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Protocols

@class CurriculumPare;

@protocol MultiDirectionOrganizedScrollDelegate <NSObject>

@required
- (NSInteger)countOfPages;
- (UIEdgeInsets)edge;

@end


#pragma mark - Enum

typedef NS_ENUM(NSInteger, MultiDirectionOrganizedScrollStyle) {
    MultiDirectionOrganizedScrollStyleDefault,
    MultiDirectionOrganizedScrollStyleGrayLine
};


#pragma mark - Class

/****************    Multi Direction Organized Scroll        ****************/

@interface MultiDirectionOrganizedScroll : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<NSArray<CurriculumPare *> *> *data;
@property (nonatomic, weak) id<MultiDirectionOrganizedScrollDelegate> multiDelegate;    // Delegate should be set in the viewDidLayoutSubviews or some method which include valid layout
@property (nonatomic, assign, getter=isPageControlActive) BOOL pageControlActive;
@property (nonatomic, strong) UIColor *color;

- (void)reloadData;

- (instancetype)initWithCountOfPages:(NSInteger)count withFrame:(CGRect)rect andStyle:(MultiDirectionOrganizedScrollStyle)style;

@end

NS_ASSUME_NONNULL_END
