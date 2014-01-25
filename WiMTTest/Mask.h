//
//  Mask.h
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t CandyColisionBM = 0x0 << 0;
static const uint32_t NonTouchTrapColisionBM = 0x0 << 0;
static const uint32_t EnemyColBM = 0b;
static const uint32_t ColBM = 0b0001;

typedef enum {
    ROOM_OBJECT = 0,
    BOX_OBJECT = 1,
    TRAP_OBJECT = 2,
    ENEMY_OBJECT = 3,
    CANDY_OBJECT = 4,
    SWITCH_OBJECT = 5,
    DOOR_OBJECT = 6,
    GIRL_OBJECT = 7
} GameObjectType;

static const uint32_t kCollisionList[] = {
    0b00000, //Room
    0b00001, //Box
    0b00000, //Trap
    0b00010, //Enemy
    0b00000, //Candy
    0b00000, //Switch
    0b00000, //Door
    0b00100  //Girl
};

static const uint32_t kContactList[] = {
    0b00000, //Room
    0b00000, //Box
    0b00000, //Trap
    0b00010, //Enemy
    0b00000, //Candy
    0b00000, //Switch
    0b00000, //Door
    0b01000  //Girl
};

static const uint32_t kCategoryList[] = {
    0b00000, //Room
    0b00111, //Box
    0b01011, //Trap
    0b01101, //Enemy
    0b01000, //Candy
    0b01000, //Switch
    0b01000, //Door
    0b00001  //Girl
};

extern void SetMask(SKPhysicsBody* body, GameObjectType objType);
