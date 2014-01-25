//
//  LivingScene.m
//  WiMTTest
//
//  Created by Akira Yamaoka on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "LivingScene.h"
#import "Mask.h"
@implementation LivingScene

- (void)loadLevel {
    [self initBackground];
    [self initRoomBound:background.backgroundWidth];
    [self initObjects];
}

- (void)initBackground{
    background = [SceneBackground node];
    [self addChild:background];
    background.zPosition = -1;
    [background setTileList:@[@"LivingroomDark", @"LivingroomDark",@"LivingroomDark", @"LivingroomDark" ,@"LivingroomDark", @"LivingroomDark" ] LightVersion:nil];
}

- (void)initObjects {
    [self addObject:@"LivingPicture" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(150, 500) Dynamic:NO];
    [self addObject:@"Hang" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(400, 108) Dynamic:NO];
    [self addObject:@"Clock" WithObjectType:TRAP_OBJECT OnPos:CGPointMake(500, 500) Dynamic:NO];
    [self addObject:@"Sofa" WithObjectType:TRAP_OBJECT OnPos:CGPointMake(700, 120) Dynamic:NO];
    [self addObject:@"Flower" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(750, 108) Dynamic:YES];
    [self addObject:@"Candy" WithObjectType:CANDY_OBJECT OnPos:CGPointMake(800, 108) Dynamic:NO];
    [self addObject:@"Candy" WithObjectType:CANDY_OBJECT OnPos:CGPointMake(900, 108) Dynamic:NO];
    [self addObject:@"LivingChair" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1000, 108) Dynamic:NO];
    [self addObject:@"TeethCarpet" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1200, 100) Dynamic:NO];
    [self addObject:@"Door" WithObjectType:DOOR_OBJECT OnPos:CGPointMake(1500, 120) Dynamic:NO];
    [self addObject:@"Speaker" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1300, 120) Dynamic:NO];
    [self addObject:@"switch_off" WithObjectType:SWITCH_OBJECT OnPos:CGPointMake(1300, 500) Dynamic:NO];
    [self addObject:@"TV" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(1700, 108) Dynamic:YES];
}

- (void)addObject:(NSString*)objName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    GameObject* obj = [GameObject spriteNodeWithImageNamed:objName];
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, objType);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
}

@end
