//
//  Trap.m
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Trap.h"

@implementation Trap
{
    BOOL danger;
}

- (void)trapOn {
    danger = YES;
    [self startAnimation:trapOnAnimationName];
    if (self.activeTime > 0) {
        [self performSelector:@selector(deactive) withObject:nil afterDelay:self.activeTime];
    }
}

- (void)trapOff {
    danger = NO;
    [self startAnimation:trapOffAnimationName];
    [self performSelector:@selector(active) withObject:nil afterDelay:self.passiveTime];
}

- (void)deactive {
    danger = NO;
    void (^trapBlock) () = ^() {
        [self trapOff];
    };
    
    [self startOnceAnimation:trapDeactiveAnimationName WithEndBlock:trapBlock];
}

- (void)active {
    danger = YES;
    void (^trapBlock) () = ^() {
        [self trapOn];
    };
    
    [self startOnceAnimation:trapActiveAnimationName WithEndBlock:trapBlock];
}

- (BOOL)isActive {
    return danger;
}

- (void)lightOn {
    [self removeAllActions];
    SetMask(self.physicsBody, ROOM_OBJECT);
    self.physicsBody.dynamic = NO;
}

@end
