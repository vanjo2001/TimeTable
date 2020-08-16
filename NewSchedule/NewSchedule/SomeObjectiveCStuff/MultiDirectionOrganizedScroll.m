//
//  MultiDirectionOrganizedScroll.m
//  NewSchedule
//
//  Created by IvanLyuhtikov on 13.08.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

#import "MultiDirectionOrganizedScroll.h"
#import "NewSchedule-Swift.h"

@interface MultiDirectionOrganizedScroll () {
    MultiDirectionOrganizedScrollStyle _style;
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<UIScrollView *> *arrOfChildScrollViews;
@property (nonatomic, strong) NSMutableArray<NSValue *> *arrOfFrameChildScrollViews;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;  // If this property not be set to some value object will be useless

@end



@implementation MultiDirectionOrganizedScroll


#pragma mark - Initialization

- (instancetype)initWithCountOfPages:(NSInteger)count withFrame:(CGRect)rect andStyle:(MultiDirectionOrganizedScrollStyle)style {
    self = [super initWithFrame:rect];
    
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        _style = style;
    }
    return self;
}


#pragma mark - Setters and Getters

#define WIDTH SizeEntityObjC.screenWidth
#define HEIGHT SizeEntityObjC.screenHeight
#define BOTTOM_CONSTRAINT SizeEntityObjC.bottomConstraint
#define SIDE_CONSTANT 8

#define PAGE_CONTROL_CONSTANT 20

- (NSMutableArray<UIScrollView *> *)arrOfChildScrollViews {
    if (!_arrOfChildScrollViews) {
        _arrOfChildScrollViews = [[NSMutableArray alloc] init];
        return _arrOfChildScrollViews;
    }
    return _arrOfChildScrollViews;
}


- (void)setMultiDelegate:(id<MultiDirectionOrganizedScrollDelegate>)multiDelegate {
    if (!_multiDelegate) {
        _multiDelegate = multiDelegate;
        [self setupMultiScroll];
        if (self.isPageControlActive) {
            [self setupPageControl];
        }
        [self setupDataView];
    }
}

- (void)setPageControlActive:(BOOL)pageControlActive {
//    _pageControlActive = pageControlActive;
    if (_pageControlActive != pageControlActive) {
        _pageControlActive = pageControlActive;
        pageControlActive ? [self setupPageControl] : [self removePageControl];
    }
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        [self setNeedsDisplay];
    }
}


#pragma mark - Setup Methods

- (void)setupMultiScroll {
    
    self.edgeInsets = [_multiDelegate edge];
    
    NSInteger count = [_multiDelegate countOfPages];
    
    self.contentSize = CGSizeMake(([SizeEntityObjC screenWidth] * count), 0);
    
    for (long i = 0; i < count; i++) {
        
        [self.arrOfFrameChildScrollViews addObject:[NSValue valueWithCGPoint:CGPointMake(WIDTH * i, 0)]];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH * i,
                                                                              0,
                                                                              WIDTH,
                                                                              HEIGHT - BOTTOM_CONSTRAINT - self.edgeInsets.top - (_style ? PAGE_CONTROL_CONSTANT : 0))];
        
        scroll.backgroundColor = [UIColor colorWithDisplayP3Red:0.01 green:0.1 * i blue:1 alpha:1];
        scroll.contentSize = CGSizeMake(WIDTH, HEIGHT);
        
        [self.arrOfChildScrollViews addObject:scroll];

        [self addSubview:scroll];
        
    }
    
}


- (void)setupPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH/2,
                                                                       HEIGHT - BOTTOM_CONSTRAINT - PAGE_CONTROL_CONSTANT/2,
                                                                       0,
                                                                       0)];
    
    self.pageControl.numberOfPages = 6;
    self.pageControl.currentPage = 0;
    
    [self.superview addSubview:self.pageControl];
}

- (void)removePageControl {
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
}


- (void)setupDataView {
    
    NSInteger indexI = 0;
    
    for (NSArray *oneArr in self.multiDelegate.content) {
        
        UIScrollView *context = self.arrOfChildScrollViews[indexI];
        
        NSInteger indexJ = 0;
        
        for (CurriculumPare *one in oneArr) {
            
            UIView *pareView = [[UIView alloc] initWithFrame:CGRectMake([self.arrOfFrameChildScrollViews[indexI] CGPointValue].x + 15, indexJ * (20 + 125), WIDTH-30, 125)];
            pareView.backgroundColor = UIColor.cyanColor;
            pareView.layer.cornerRadius = 25;
            
            [context addSubview:pareView];
            
            indexJ++;
        }
        
        indexI++;
    }
}


#pragma mark - Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = round(scrollView.contentOffset.x / WIDTH);
    self.pageControl.currentPage = page;
}

@end

