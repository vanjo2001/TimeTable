//
//  MultiDirectionOrganizedScroll.m
//  NewSchedule
//
//  Created by IvanLyuhtikov on 13.08.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

#import "MultiDirectionOrganizedScroll.h"
#import "NewSchedule-Swift.h"
#import "MegaSuperDuper.mm"



@interface MultiDirectionOrganizedScroll () {
    MultiDirectionOrganizedScrollStyle _style;
}

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<UIScrollView *> *arrOfChildScrollViews;
@property (nonatomic, strong) NSMutableArray<NSValue *> *arrOfFrameChildScrollViews;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<ContentView *> *> *arrOfContentView;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;  // If this property not be set to some value object will be useless


@end



@implementation MultiDirectionOrganizedScroll


#pragma mark - Initialization

- (instancetype)initWithCountOfPages:(NSInteger)count withFrame:(CGRect)rect andStyle:(MultiDirectionOrganizedScrollStyle)style {
    self = [super initWithFrame:rect];
    
//    auto aa = new MegaSuperDuper;
    
    if (self) {
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

#define CONTENT_VIEW_HEIGHT 125
#define CONTENT_VIEW_SIDE_OFFSET 15
#define CONTENT_VIEW_CORNER_RADIUS 25
#define CONTENT_VIEW_TOP_CONSTRAINT 40
#define CONTENT_VIEW_GAP 20

#define PAGE_CONTROL_CONSTANT 20



- (void)setMultiDelegate:(id<MultiDirectionOrganizedScrollDelegate>)multiDelegate {
    if (!_multiDelegate) {
        _multiDelegate = multiDelegate;
        
        [self setupMultiScroll];
        [self setupLoadMode];
        if (self.isPageControlActive) {
            [self setupPageControl];
        }
    }
}

- (void)setData:(NSArray<NSArray<CurriculumPare *> *> *)data {
    if (_data != data) {
        _data = data;
        [self reloadData];
    }
}

- (NSMutableArray<NSMutableArray<ContentView *> *> *)arrOfContentView {
    if (!_arrOfContentView) {
        _arrOfContentView = [NSMutableArray new];
    }
    return _arrOfContentView;
}


- (NSMutableArray<UIScrollView *> *)arrOfChildScrollViews {
    if (!_arrOfChildScrollViews) {
        _arrOfChildScrollViews = [[NSMutableArray alloc] init];
        return _arrOfChildScrollViews;
    }
    return _arrOfChildScrollViews;
}


- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(WIDTH/2, HEIGHT/2);
        
    }
    return _indicator;
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

- (void)goToPageOfScrollView:(NSInteger)page {
    [self setContentOffset:CGPointMake(WIDTH * page, 0) animated:YES];
}


- (void)setupLoadMode {
    
    [self.superview addSubview:self.indicator];
    [self.indicator startAnimating];
}

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
        
        scroll.backgroundColor = [UIColor colorNamed:@"BackgroundColor"];
//        [UIColor colorWithDisplayP3Red:0.01 green:0.1 * i blue:1 alpha:1]
//        scroll.contentSize = CGSizeMake(WIDTH, HEIGHT);
        
        [self.arrOfChildScrollViews addObject:scroll];

        [self addSubview:scroll];
        
    }
    
}


- (void)setupPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH/2,
                                                                       HEIGHT - BOTTOM_CONSTRAINT - PAGE_CONTROL_CONSTANT/2,
                                                                       0,
                                                                       0)];
    
    self.pageControl.pageIndicatorTintColor = UIColor.lightGrayColor;
    self.pageControl.currentPageIndicatorTintColor = UIColor.cyanColor;
    self.pageControl.numberOfPages = 6;
    self.pageControl.currentPage = 0;
    
    [self.superview addSubview:self.pageControl];
}

- (void)removePageControl {
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
}

- (void)prepateForReload {
    
    for (NSMutableArray<ContentView *> *arrOfView in self.arrOfContentView) {
        for (ContentView *oneView in arrOfView) {
            [oneView removeFromSuperview];
        }
    }
    
    [self.arrOfContentView removeAllObjects];
}

- (void)reloadData {
    
    [self prepateForReload];
    
    NSInteger indexI = 0;
    
    for (NSArray *arr in self.data) {

        NSInteger indexJ = 0;
        
        UIScrollView *context = self.arrOfChildScrollViews[indexI];

        //Layout compute
        __block CGPoint point = [self.arrOfFrameChildScrollViews[indexI] CGPointValue];

        point.x += CONTENT_VIEW_SIDE_OFFSET;
        point.y = CONTENT_VIEW_TOP_CONSTRAINT;
        
        NSMutableArray<ContentView *> *oneArr = [NSMutableArray new];
        
        for (CurriculumPare *pare in arr) {
            
            __block ContentView *realPareView = NULL;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                realPareView = [[[NSBundle mainBundle] loadNibNamed:@"ContentView" owner:self options:nil] objectAtIndex:0];
                realPareView.backgroundColor = [UIColor colorNamed:@"ContentViewColor"];
                
                realPareView.alpha = 0.0;
                
                realPareView.numberOfPare.text = pare.numberPare;
                realPareView.numberOfRoom.text = pare.room;
                realPareView.subject.text = pare.pairName;
                realPareView.teacher.text = pare.teacher;
                realPareView.time.text = @"11:40-12:50";
                
                CGRect fframe = realPareView.frame;
                fframe.size.width = WIDTH-CONTENT_VIEW_SIDE_OFFSET * 2;
                fframe.origin = point;
                
                realPareView.frame = fframe;
                realPareView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:realPareView.bounds cornerRadius:realPareView.layer.cornerRadius].CGPath;
                
                [context addSubview:realPareView];
                 
                 [UIView animateWithDuration:(indexJ == 0 ? 1 : indexJ) animations:^{
                     realPareView.alpha = 1.0;
                 }];
                
                [oneArr addObject:realPareView];
                
                point.y += fframe.size.height + CONTENT_VIEW_GAP;
                
            });
            
            indexJ++;
            
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (point.y > context.bounds.size.height) {
                context.contentSize = CGSizeMake(WIDTH, point.y);
            }
        });

        

        [self.arrOfContentView addObject:oneArr];
        [self.arrOfFrameChildScrollViews insertObject:[NSValue valueWithCGPoint:point] atIndex:indexI];

        indexI++;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator stopAnimating];
    });

}


@end


