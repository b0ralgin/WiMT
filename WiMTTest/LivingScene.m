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
       [self addObject:@"HangDark" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(100, 108) Dynamic:NO];
    [self addObject:@"ClockDark" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(400, 500) Dynamic:NO];
    Trap* Waver = [self addTrap:@"WaverDark" Light:@"WaverLight" OnPos:CGPointMake(408, 294) Dynamic:NO];
    [self addObject:@"SofaDark" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(700, 120) Dynamic:NO];
    [self addObject:@"PaintingDark" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(800, 500) Dynamic:NO];
   // [self addObject:@"Flower" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(750, 108) Dynamic:YES];
    [self addObject:@"candy" WithObjectType:CANDY_OBJECT OnPos:CGPointMake(800, 108) Dynamic:NO];
    [self addObject:@"candy" WithObjectType:CANDY_OBJECT OnPos:CGPointMake(900, 108) Dynamic:NO];
    [self addObject:@"ArmchairDark" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1300, 108) Dynamic:NO];
    [self addObject:@"Spikes" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1600, 100) Dynamic:NO];
    [self addObject:@"BedroomDoorClose" WithObjectType:DOOR_OBJECT OnPos:CGPointMake(2000, 120) Dynamic:NO];
    [self addObject:@"SpeakerDark" WithObjectType:BOX_OBJECT OnPos:CGPointMake(2200, 300) Dynamic:NO];
    [self addObject:@"switch_off" WithObjectType:SWITCH_OBJECT OnPos:CGPointMake(2300, 500) Dynamic:NO];
    //[self addObject:@"TV" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(1700, 108) Dynamic:YES];
    [self addObject:@"ChairDark" WithObjectType:BOX_OBJECT OnPos:CGPointMake(2700, 108) Dynamic:YES];
}

- (void)addObject:(NSString*)objName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    GameObject* obj = [GameObject spriteNodeWithImageNamed:objName];
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, objType);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
}


@end
