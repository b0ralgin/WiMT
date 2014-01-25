//
//  Mask.m
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Mask.h"

//
//  Mask.h
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#ifndef Game_Mask_h
#define Game_Mask_h

void SetMask(SKPhysicsBody* body, GameObjectType objType) {
    body.categoryBitMask = kCategoryList[objType];
    body.collisionBitMask = kCollisionList[objType];
    body.contactTestBitMask = kContactList[objType];
}

#endif

