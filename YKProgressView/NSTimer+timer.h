//
//  NSTimer+timer.h
//  YKProgressView
//
//  Created by yzl on 2017/4/25.
//  Copyright © 2017年 yzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (timer)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)())block
                                    repeats:(BOOL)repeats;



@end
