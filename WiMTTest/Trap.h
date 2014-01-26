//
//  Trap.h
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameObject.h"

static NSString* const trapActiveAnimationName = @"Trap act";
static NSString* const trapDeactiveAnimationName = @"Trap deact";
static NSString* const trapOnAnimationName = @"Trap on";
static NSString* const trapOffAnimationName = @"Trap off";

@interface Trap : GameObject

@property (assign,nonatomic) NSTimeInterval activeTime;
@property (assign,nonatomic) NSTimeInterval passiveTime;

- (void)trapOn;
- (BOOL)isActive;

@end
