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
{
    Trap* spikes;
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
    [background setTileList:@[@"LivingroomDark", @"LivingroomDark",@"LivingroomDark", @"LivingroomDark" ,@"LivingroomDark", @"LivingroomDark" ] LightVersion:nil];
}

- (void)initObjects {
    [self addObject:@"HangDark" Light:@"HangLight" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(100, 108) Dynamic:NO];
    [self addObject:@"ClockDark" Light:@"ClockLight" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(400, 500) Dynamic:NO];
    GameObject* weaver = [self addObject:@"WaverDark" Light:@"WaverLight" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(408, 294) Dynamic:NO];
    [self addObject:@"SofaDark" Light:@"SofaLight" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(700, 120) Dynamic:NO];
    [self addObject:@"PaintingDark" Light:@"PaintingLight" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(800, 500) Dynamic:NO];
    Enemy* flower = [self addEnemy:@"Flower" Light:@"FlowerLight" OnPos:CGPointMake(750, 108) Dynamic:YES];
    [self addObject:@"candy" Light:nil WithObjectType:CANDY_OBJECT OnPos:CGPointMake(800, 108) Dynamic:NO];
    [self addObject:@"candy" Light:nil WithObjectType:CANDY_OBJECT OnPos:CGPointMake(900, 108) Dynamic:NO];
    [self addObject:@"ArmchairDark" Light:@"ArmchairLight" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1300, 108) Dynamic:NO];
    spikes = [self addTrap:@"SpikesDark" Light:@"SpikesLight" OnPos:CGPointMake(1700, 100) Dynamic:NO];
    [self addObject:@"BedroomDoorClose" Light:nil WithObjectType:DOOR_OBJECT OnPos:CGPointMake(2000, 120) Dynamic:NO];
    [self addObject:@"SpeakerDark" Light:@"SpeakerLight" WithObjectType:BOX_OBJECT OnPos:CGPointMake(2200, 300) Dynamic:NO];
    [self addObject:@"switch_off" Light:nil WithObjectType:SWITCH_OBJECT OnPos:CGPointMake(2500, 500) Dynamic:NO];
    Enemy* tv = [self addEnemy:@"TV" Light:@"TVLight" OnPos:CGPointMake(1700, 108) Dynamic:YES];
    [self addObject:@"ChairDark" Light:@"ChairLight" WithObjectType:BOX_OBJECT OnPos:CGPointMake(2700, 108) Dynamic:YES];
    
    flower.moveSpeed = 1.5;
    [flower move];
    
    spikes.activeTime = 1.0;
    spikes.passiveTime = 1.5;
    
    tv.moveSpeed = 2;
    [tv move];
}

- (void)startAnimation {
    //[spikes trapOn];
}

@end
