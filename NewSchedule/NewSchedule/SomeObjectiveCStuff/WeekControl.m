//
//  WeekControl.m
//  NewSchedule
//
//  Created by IvanLyuhtikov on 3.09.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

#import "WeekControl.h"
#import "NewSchedule-Swift.h"

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]


#define DefaultColorDay RGB(147, 148, 148)
#define HighlightColorDay RGB(0, 122, 255)
#define WeekControlItselfColor RGB(247, 247, 247)

//DarkMode version

#define DarkModeWeekControlItselfColor RGB(39, 39, 40)



//#define DarkModeHigh


@interface WeekControl ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrOfButtons;

@end


@implementation WeekControl

@synthesize currentDay = _currentDay;

- (void)setCurrentDay:(NSInteger)currentDay {
    if (_currentDay != currentDay) {
        _currentDay = currentDay;
        [self highlightCurrentDay];
    }
}

- (void)setWeekDelegate:(id<WeekControlDelegate>)weekDelegate {
    if (!_weekDelegate) {
        _weekDelegate = weekDelegate;
        [self setup];
    }
}

- (NSMutableArray<UIButton *> *)arrOfButtons {
    if (!_arrOfButtons) {
        _arrOfButtons = [[NSMutableArray alloc] init];
    }
    return _arrOfButtons;
}

- (UIColor *)colorOfDays {
    if (!_colorOfDays) {
        _colorOfDays = self.backgroundColor;
    }
    return _colorOfDays;
}


- (void)setup {
    
    NSArray<NSString *> *arrOfString = [self.weekDelegate dataForDays:self];
    
    // For Font
    
    UIFont *font = [UIFont fontWithName:@"SFProRounded-Regular" size:[SizeEntityObjC wd] * [SizeEntityObjC coefFont] > [SizeEntityObjC minWD] ? [SizeEntityObjC wd] * [SizeEntityObjC coefFont] : [SizeEntityObjC minWD]];
    UIColor *color = DefaultColorDay;
    
    for (long i = 0; i < arrOfString.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.showsTouchWhenHighlighted = YES;
        button.tag = i;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:arrOfString[i] attributes:@{NSFontAttributeName: font,
                                                                                                                      NSForegroundColorAttributeName: color
        }];
        [button setAttributedTitle:attributedString forState:UIControlStateNormal];
        button.backgroundColor = self.colorOfDays;
        
        [button addTarget:nil action:@selector(convenientPage:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.arrOfButtons addObject:button];
    }
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:self.arrOfButtons];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
//    self.stackView.spacing = 8;
    
    [self addSubview:self.stackView];
    
    if (!self.currentDay)
        [self highlightCurrentDay];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    const CGFloat widthMargin = self.bounds.size.width/15;
    rect.origin.x = widthMargin;
    rect.origin.y = 0;
    rect.size.width -= 2 * widthMargin;
    self.stackView.frame = rect;
    
}

- (void)highlightCurrentDay {
    for (UIButton *button in self.arrOfButtons) {
//        button.highlighted = false;
        
        button.enabled = YES;
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            button.titleLabel.textColor = DefaultColorDay;
        }];
        
        
        if (button.tag == self.currentDay) {
//            button.highlighted = true;
            
            button.enabled = NO;
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.transform = CGAffineTransformMakeScale(1.25, 1.25);
            } completion:^(BOOL finished) {
                button.titleLabel.textColor = HighlightColorDay;
            }];
            
        }
    }
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorNamed:@"WeekControlColor"];
        
    }
    
    return self;
}

@end
