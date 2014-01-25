//
//  BedroomScene.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "BedroomScene.h"

@implementation BedroomScene
{
    
}

- (void)loadLevel {
    [self initBackground];
    [self initRoomBound:background.backgroundWidth];
    [self initObjects];
}

- (void)initBackground{
    background = [SceneBackground node];
    [self addChild:background];
    background.zPosition = -1;
    
    [background setTileList:@[@"BedroomDark", @"BedroomWindowDark", @"BedroomDark"] LightVersion:nil];
}

- (void)initObjects {
    [self addObject:@"Bed" WithCollision:0 Contact:0 OnPos:CGPointMake(0, 120) Dynamic:NO];
    [self addObject:@"Chair" WithCollision:kCollisionBox Contact:kContactBox OnPos:CGPointMake(150, 108) Dynamic:YES];
    [self addObject:@"Carpet" WithCollision:kCollisionTrap Contact:kContactTrap OnPos:CGPointMake(250, 100) Dynamic:NO];
    [self addObject:@"Picture" WithCollision:0 Contact:0 OnPos:CGPointMake(250, 400) Dynamic:NO];
    [self addObject:@"ToyBox" WithCollision:kCollisionBox Contact:kContactBox OnPos:CGPointMake(400, 108) Dynamic:NO];
    [self addObject:@"Doll" WithCollision:kCollisionEnemy Contact:kContactEnemy OnPos:CGPointMake(550, 108) Dynamic:YES];
    [self addObject:@"Shelf" WithCollision:0 Contact:0 OnPos:CGPointMake(600, 500) Dynamic:NO];
    [self addObject:@"Switch" WithCollision:kCollisionSwitch Contact:kContactSwitch OnPos:CGPointMake(650, 400) Dynamic:NO];
    [self addObject:@"Door" WithCollision:kCollisionDoor Contact:kContactDoor OnPos:CGPointMake(800, 120) Dynamic:NO];
}

- (void)addObject:(NSString*)objName WithCollision:(uint32_t)collisionMask Contact:(uint32_t)contactMask OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    GameObject* obj = [GameObject spriteNodeWithImageNamed:objName];
    obj.physicsBody.dynamic = dyn;
    obj.physicsBody.collisionBitMask = collisionMask;
    obj.physicsBody.contactTestBitMask = contactMask;
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
}

@end
