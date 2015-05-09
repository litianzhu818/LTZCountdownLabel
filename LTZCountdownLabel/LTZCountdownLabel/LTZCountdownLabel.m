//
//  LTZCountdownLabel.m
//  LTZCountdownLabel
//
//  Created by Peter Lee on 15/5/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//
#define NSRangeZero NSMakeRange(0, 0)
#define NSRangeEndLocation(range) (range.location +range.length)
#define NSRangeBentween(x, y) NSMakeRange(NSRangeEndLocation(x), y.location-NSRangeEndLocation(x))


#import "LTZCountdownLabel.h"

@implementation LTZCountdownLabel
{
    dispatch_source_t timer;
}

- (instancetype)initWithFrame:(CGRect)frame
                 timeInterval:(NSTimeInterval)timeInterval
                  numberColor:(UIColor *)numberColor
                    unitColor:(UIColor *)unitColor
                     timefont:(UIFont *)timefont
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberColor = numberColor;
        self.unitColor = unitColor;
        self.timeInterval = timeInterval;
        self.timefont = timefont;
        // 倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        // 每秒执行
        dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),(self.timeInterval)*NSEC_PER_SEC, 0*NSEC_PER_SEC);
    }
    return self;
}

- (void)fireWithDestinationDate:(NSDate *)destinationDate;
{
    if (!destinationDate) {
        return;
    }
    
    self.destinationDate = destinationDate;
    
    [self startTime];
}

- (void)fire
{
    if (!self.destinationDate) {
        return;
    }
    
    [self startTime];
}

- (void)invalidate
{
    dispatch_source_cancel(timer);
}

-(void)startTime
{
    __weak typeof(self) weakSelf = self;
    
    // 执行事件
    dispatch_source_set_event_handler(timer, ^{
        
        //定义一个NSCalendar对象
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        //得到当前时间
        NSDate *today = [NSDate date];
        
        //用来得到具体的时差
        unsigned int unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:self.destinationDate options:0];
        
        NSInteger day = 0;
        NSInteger hour = 0;
        NSInteger minute = 0;
        NSInteger second = 0;
        
        if ([today compare:weakSelf.destinationDate] <= NSOrderedSame) {
            day = [d day];
            hour = [d hour];
            minute = [d minute];
            second = [d second];
        }
        
        // 设置字体和颜色
        NSString *countdown = [NSString stringWithFormat:@"%ld日%ld时%ld分%ld秒", (long)day, (long)hour, (long)minute, (long)second];
        
        NSRange riRange = [countdown rangeOfString:@"日"];
        NSRange shiRange = [countdown rangeOfString:@"时"];
        NSRange fenRange = [countdown rangeOfString:@"分"];
        NSRange miaoRange = [countdown rangeOfString:@"秒"];
       
        
        NSRange dayRange = NSRangeBentween(NSRangeZero, riRange);
        NSRange hourRange = NSRangeBentween(riRange, shiRange);
        NSRange minuteRange = NSRangeBentween(shiRange, fenRange);;
        NSRange secondRange = NSRangeBentween(fenRange, miaoRange);;
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:countdown attributes:@{NSForegroundColorAttributeName: weakSelf.unitColor, NSFontAttributeName:weakSelf.timefont}];
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                value:weakSelf.numberColor
                                range:dayRange];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:weakSelf.numberColor
                                 range:hourRange];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:weakSelf.numberColor
                                 range:minuteRange];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:weakSelf.numberColor
                                 range:secondRange];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
                weakSelf.attributedText = attributedString;
            
        });
        
        // 如果时间到了，停止定时器
        if ([today compare:weakSelf.destinationDate] >= NSOrderedSame) {
            dispatch_source_cancel(timer);
        }
        
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"定时器结束了！");
    });
    
    dispatch_resume(timer);
}

- (UIColor *)numberColor
{

    if (!_numberColor) {
        return [UIColor blackColor];
    }
    
    return _numberColor;
}

- (UIColor *)unitColor
{
    if (!_unitColor) {
        return [UIColor blackColor];
    }
    
    return _unitColor;
}

- (UIFont *)timefont
{
    if (!_timefont) {
        return [UIFont systemFontOfSize:17.0];
    }
    
    return _timefont;
}

- (void)dealloc
{
    [self invalidate];
    NSLog(@"%@",@"LTZCountdownLabel has released self");
}

@end
