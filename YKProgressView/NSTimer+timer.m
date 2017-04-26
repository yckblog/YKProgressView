//
//  NSTimer+timer.m
//  YKProgressView
//
//  Created by yzl on 2017/4/25.
//  Copyright © 2017年 yzl. All rights reserved.
//

#import "NSTimer+timer.h"

@implementation NSTimer (timer)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end
