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
    
    [background setTileList:@[@"BedroomDark", @"BedroomWindowDark", @"BedroomWindowDark", @"BedroomDark", @"BedroomDark"] LightVersion:nil];
}

- (void)initObjects {
    GameObject* toyBox = [GameObject spriteNodeWithImageNamed:@"ToyBox"];
    toyBox.physicsBody.dynamic = YES;
    toyBox.physicsBody.categoryBitMask = kCollisionBox;
    toyBox.physicsBody.collisionBitMask = kCollisionBox;
    toyBox.physicsBody.contactTestBitMask = kContactRoom;
    toyBox.position = CGPointMake(400, 250);
    
    [toyBox setParent:darkSideNode];
}

@end
