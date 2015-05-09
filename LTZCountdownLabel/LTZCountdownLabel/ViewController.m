//
//  ViewController.m
//  LTZCountdownLabel
//
//  Created by Peter Lee on 15/5/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "ViewController.h"
#import "LTZCountdownLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *timeString = @"2015-06-23 23:35:30";
    
    NSDateFormatter *f1 = [[NSDateFormatter alloc] init];
    [f1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *theDay = [f1 dateFromString:timeString];
    
    
    LTZCountdownLabel *label = [[LTZCountdownLabel alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width-20, 40) timeInterval:1.0 numberColor:[UIColor yellowColor] unitColor:[UIColor redColor] timefont:[UIFont systemFontOfSize:17.0]];
    
    [self.view addSubview:label];
    
    [label fireWithDestinationDate:theDay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
