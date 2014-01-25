//
//  BedroomBackground.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SceneBackground.h"
#import "GameObject.h"

static NSString *const tilesFilename = @"bedroom";
static const float nearRatio = 0.1;
static const float farRatio = 0.25;

@implementation SceneBackground {
    NSMutableArray* tileSpriteList;
    SKTexture* forestTexture;
    SKTexture* startTexture;
    SKSpriteNode* forestSprite;
    
    NSMutableArray *nearParalaxList;
    NSMutableArray *farParalaxList;
    
    SKCropNode* cropNode;
    
    float backgroundWidth, xPos;
}

-(instancetype)init
{
    if ((self = [super init] )) {
        tileSpriteList = [NSMutableArray new];
        cropNode = [SKCropNode new];
        [self addChild:cropNode];
        
        forestTexture = [SKTexture textureWithImageNamed:@"forest patter"];
        startTexture = [SKTexture textureWithImageNamed:@"star patter"];
        forestSprite = nil;
        
        backgroundWidth = 0;
        xPos = 0;
    }
    
    return self;
}

- (void)setTileList:(NSArray *)tileList LightVersion:(NSArray *)tileLightList {
    for (SKNode* node in tileSpriteList) {
        [node removeFromParent];
    }
    
    [tileSpriteList removeAllObjects];
    
    NSMutableDictionary* tempAtlas = [NSMutableDictionary new];
    backgroundWidth = 0;
    xPos = 0;
    
    for (ushort i = 0; i < tileList.count; i++) {
        NSString* tileName = tileList[i];
        NSString* lightName = (tileLightList.count > i ? tileLightList[i] : tileName);
        
        SKTexture* tileTexture = [tempAtlas objectForKey:tileName];
        if (tileTexture == nil) {
            tileTexture = [SKTexture textureWithImageNamed:tileName];
            [tempAtlas setObject:tileTexture forKey:tileName];
        }
        
        SKTexture* tileLightTexture = [tempAtlas objectForKey:lightName];
        if (tileLightTexture == nil) {
            tileLightTexture = [SKTexture textureWithImageNamed:lightName];
            [tempAtlas setObject:tileLightTexture forKey:lightName];
        }
        
        GameObject* tileSprite = [GameObject spriteNodeWithTexture:tileTexture];
        tileSprite.physicsBody.dynamic = NO;
        tileSprite.physicsBody.categoryBitMask = 0;
        tileSprite.physicsBody.collisionBitMask = 0;
        tileSprite.physicsBody.contactTestBitMask = 0;
        [tileSprite setLightTexture:tileLightTexture];
        [tileSpriteList addObject:tileSprite];
        [tileSprite setParent:cropNode];
        tileSprite.position = CGPointMake(backgroundWidth + 0.5*tileSprite.size.width, 0.5*tileSprite.size.height);
        
        backgroundWidth += tileSprite.size.width;
    }
    
    [forestSprite removeAllChildren];
    [forestSprite removeFromParent];
    
    forestSprite = [SKSpriteNode spriteNodeWithTexture:startTexture size:CGSizeMake(2*backgroundWidth, startTexture.size.height)];
    [self addChild:forestSprite];
    forestSprite.zPosition = -1;
}

- (float)backgroundWidth {
    return backgroundWidth;
}

- (void)moveBackground:(float)xPosition {
    xPos = nearRatio * xPosition - 0.5 * nearRatio * backgroundWidth;
    float position = xPos;
    
    for (SKSpriteNode* node in tileSpriteList) {
        node.position = CGPointMake(roundf(position + 0.5*node.size.width), node.position.y);
        position += node.size.width;
    }
}

@end
