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
#import "SceneDirector.h"
#import "Heart.h"
#import "Enemy.h"
#import "Trap.h"

@interface GameScene : SKScene<GirlMovedDelegate, SKPhysicsContactDelegate> {
    SceneBackground *background;
    SKCropNode* darkSideNode;
    @protected
    Girl* _girl;
    
    BOOL _isLightOn;
    float lastTime;
}

- (void)initGirl;
- (void)loadLevel;
- (void)initRoomBound:(float)width;
- (void)openDoor:(GameObject*)door;
- (GameObject*)addObject:(NSString*)objName Light:(NSString*)lightName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn;
- (Enemy*)addEnemy:(NSString*)enemyName Light:(NSString*)lightName OnPos:(CGPoint)pos Dynamic:(BOOL)dyn;
- (Trap*)addTrap:(NSString*)trapName Light:(NSString*)lightName OnPos:(CGPoint)pos Dynamic:(BOOL)dyn;
//- (void)addWallObject:(NSString*)objName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn;

@end
