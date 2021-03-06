//
//  Mask.h
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#ifndef Game_Mask_h
#define Game_Mask_h

static const uint32_t CandyColisionBM = 0x0 << 0;
static const uint32_t NonTouchTrapColisionBM = 0x0 << 0;
static const uint32_t EnemyColBM = 0b;
static const uint32_t ColBM = 0b0001;



static const uint32_t kCollisionRoom = 0b00011;
static const uint32_t kCollisionBox = 0b00101;
static const uint32_t kCollisionTrap = 0b10001;
static const uint32_t kCollisionEnemy = 0b10000;
static const uint32_t kCollisionGirl = 0b00111;
static const uint32_t kCollisionSwitch = 0b00000;
static const uint32_t kCollisionDoor = 0b00000;

static const uint32_t kContactBox = 0b00101;
static const uint32_t kContactFire = 0b10011;
static const uint32_t kContactCandy=0b01111;
static const uint32_t kContactTrap = 0b10011;
static const uint32_t kContactEnemy = 0b10001;
static const uint32_t kContactGirl = 0b01111;
static const uint32_t kContactSwitch = 0b01111;
static const uint32_t kContactDoor = 0b01111;
static const uint32_t kContactRoom = 0b10001;

#endif
