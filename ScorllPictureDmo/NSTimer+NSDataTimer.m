//
//  NSTimer+NSDataTimer.m
//  ScorllPictureDmo
//
//  Created by 刘晨阳 on 2018/5/24.
//  Copyright © 2018年 changba-mac. All rights reserved.
//

#import "NSTimer+NSDataTimer.h"

@implementation NSTimer(NSDataTimer)

- (void)pause
{
    if([self isValid])
    {
        [self setFireDate:[NSDate distantFuture]];
    }
}

- (void)start
{
    if ([self isValid]) {
        [self setFireDate:[NSDate distantPast]];
    }
}

- (void)restartTimerAfterIntervalue:(NSTimeInterval)interval
{
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
}

@end
