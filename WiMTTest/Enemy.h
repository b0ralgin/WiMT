//
//  Enemy.h
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameObject.h"

static NSString* const enemyWalkAnimationName = @"Enemy walk";
static NSString* const enemyStandAnimationName = @"Enemy stand";
static NSString* const enemyAttackAnimationName = @"Enemy attack";

@interface Enemy : GameObject

@property (assign,nonatomic) int health;
@property (assign,nonatomic) float moveSpeed;

- (void)damage:(int)hit;
- (void)move;
- (void)stand;
- (void)attack;

@end
