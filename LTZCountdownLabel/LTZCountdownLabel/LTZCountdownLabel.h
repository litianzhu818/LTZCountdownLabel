//
//  LTZCountdownLabel.h
//  LTZCountdownLabel
//
//  Created by Peter Lee on 15/5/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTZCountdownLabel : UILabel

@property (strong, nonatomic) NSDate *destinationDate;
@property (assign, nonatomic) NSTimeInterval timeInterval;

@property (strong, nonatomic) UIColor *numberColor;
@property (strong, nonatomic) UIColor *unitColor;

@property (strong, nonatomic) UIFont *timefont;

- (instancetype)initWithFrame:(CGRect)frame
                 timeInterval:(NSTimeInterval)timeInterval
                  numberColor:(UIColor *)numberColor
                    unitColor:(UIColor *)unitColor
                     timefont:(UIFont *)timefont;

- (void)fireWithDestinationDate:(NSDate *)destinationDate;

- (void)fire;
- (void)invalidate;

@end
