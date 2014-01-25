//
//  GameScene.h
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Girl.h"
#import "Button.h"
#import "SceneBackground.h"
#import "Heart.h"

@interface GameScene : SKScene<GirlMovedDelegate, SKPhysicsContactDelegate> {
    SceneBackground *background;
    SKCropNode* darkSideNode;
}

- (void)loadLevel;
- (void)initRoomBound:(float)width;
- (void)addObject:(NSString*)objName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn;
//- (void)addWallObject:(NSString*)objName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn;

@end
