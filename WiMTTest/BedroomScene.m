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
    [darkSideNode addChild:background];
    background.zPosition = -1;
    
    [background setTileList:@[@"BedroomDark", @"BedroomWindowDark", @"BedroomDark"] LightVersion:@[@"BedroomLight", @"BedroomWindowLight", @"BedroomLight"]];
}

- (void)initObjects {
    [self addObject:@"BedDark" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(0, 120) Dynamic:NO];
    [self addObject:@"BedroomChairDark" WithObjectType:BOX_OBJECT OnPos:CGPointMake(250, 108) Dynamic:YES];
    [self addObject:@"Carpet" WithObjectType:TRAP_OBJECT OnPos:CGPointMake(400, 100) Dynamic:NO];
    [self addObject:@"BedroomPicture" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(600, 500) Dynamic:NO];
    [self addObject:@"ToyBox" WithObjectType:BOX_OBJECT OnPos:CGPointMake(600, 108) Dynamic:NO];
    [self addObject:@"Doll" WithObjectType:ENEMY_OBJECT OnPos:CGPointMake(750, 108) Dynamic:YES];
    [self addObject:@"BedroomShelf" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1100, 500) Dynamic:NO];
    [self addObject:@"switch_off" WithObjectType:SWITCH_OBJECT OnPos:CGPointMake(1050, 550) Dynamic:NO];
    [self addObject:@"BedroomDoorClose" WithObjectType:DOOR_OBJECT OnPos:CGPointMake(1200, 120) Dynamic:NO];
}

- (void)openDoor:(GameObject*)door {
    if (!darkSideNode.hidden) {
        return;
    }
    
    [door setLightTexture:[SKTexture textureWithImageNamed:@"BedroomDoorOpen"]];
    
    [super openDoor:door];
}

@end
