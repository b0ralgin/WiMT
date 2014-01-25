//
//  BedroomScene.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "BedroomScene.h"
#import "Mask.h"

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
    [self addObject:@"Bed" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(0, 120) Dynamic:NO];
    [self addObject:@"Chair" WithObjectType:BOX_OBJECT OnPos:CGPointMake(250, 108) Dynamic:YES];
    [self addObject:@"Carpet" WithObjectType:TRAP_OBJECT OnPos:CGPointMake(400, 100) Dynamic:NO];
    [self addObject:@"Picture" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(400, 500) Dynamic:NO];
    [self addObject:@"ToyBox" WithObjectType:BOX_OBJECT OnPos:CGPointMake(600, 108) Dynamic:NO];
    [self addObject:@"Doll" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(750, 108) Dynamic:YES];
    [self addObject:@"Shelf" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(900, 500) Dynamic:NO];
    [self addObject:@"switch_off" WithObjectType:SWITCH_OBJECT OnPos:CGPointMake(1050, 400) Dynamic:NO];
    [self addObject:@"Door" WithObjectType:DOOR_OBJECT OnPos:CGPointMake(1200, 120) Dynamic:NO];
}

- (void)addObject:(NSString*)objName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    GameObject* obj = [GameObject spriteNodeWithImageNamed:objName];
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, objType);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
}

@end
