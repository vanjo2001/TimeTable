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

@interface WeekControl ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrOfButtons;

@end


@implementation WeekControl

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
    UIColor *color = RGB(148, 149, 149);
    
    for (long i = 0; i < arrOfString.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:arrOfString[i] attributes:@{NSFontAttributeName: font,
                                                                                                                      NSForegroundColorAttributeName: color}];
        [button setAttributedTitle:attributedString forState:UIControlStateNormal];
        button.backgroundColor = self.colorOfDays;
        
        [self.arrOfButtons addObject:button];
    }
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:self.arrOfButtons];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
//    self.stackView.spacing = 8;
    
    [self addSubview:self.stackView];
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


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.greenColor;
    }
    
    return self;
}

@end
