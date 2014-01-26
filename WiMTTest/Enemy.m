//
//  Enemy.m
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy
{
    NSTimeInterval lastCollision;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    
    if (self != nil) {
        self.moveSpeed = 2;
        self.health = 1;
        
        lastCollision = 0;
    }
    
    return self;
}

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    
    if (self != nil) {
        self.moveSpeed = 2;
        self.health = 1;
        
        lastCollision = 0;
    }
    
    return self;
}

- (void)damage:(int)hit {
    NSLog(@"%@ damage %d" , self, hit);
    
    if (self.health <= 0) {
        return;
    }
    
    self.health -= hit;
    if (self.health <= 0) {
        [self lightOn];
    }
}

- (void)stand {
    [self startAnimation:enemyStandAnimationName];
}

- (void)attack {
    void (^attackBlock) () = ^() {
        [self continueMove];
    };
    
    [self startOnceAnimation:enemyAttackAnimationName WithEndBlock:attackBlock];
}

- (void)move {
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    if (lastCollision + 4 > curTime) {
        return;
    }
    
    lastCollision = curTime;
    
    self.xScale *= -1;
    [self continueMove];
}

- (void)continueMove {
    [self startAnimation:enemyWalkAnimationName];
    [self runAction:[SKAction repeatActionForever:[SKAction moveByX:self.xScale*self.moveSpeed y:0 duration:0.1]]];
}

- (void)lightOn {
    [self removeAllActions];
    SetMask(self.physicsBody, ROOM_OBJECT);
    self.physicsBody.dynamic = NO;
}

@end
