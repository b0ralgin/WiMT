//
//  Girl.h
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameObject.h"
#import "GirlMovedDelegate.h"
@interface Girl : GameObject

@property id <GirlMovedDelegate> delegate;

- (void)moveLeft;
- (void)moveRight;
- (void)stopMoving;
- (void)jump;
- (void)startOpenDoorAnimation;
- (void)stopAttack;
- (void)resumeAttack;
- (void)turnOn;
- (void)turnOff;
- (BOOL)isAttack;

@end
