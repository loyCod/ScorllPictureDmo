//
//  NSTimer+NSDataTimer.h
//  ScorllPictureDmo
//
//  Created by 刘晨阳 on 2018/5/24.
//  Copyright © 2018年 changba-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(NSDataTimer)
- (void)pause;
- (void)start;
- (void)restartTimerAfterIntervalue:(NSTimeInterval)interval;
@end
