//
//  GameObject.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameObject.h"

static NSTimeInterval const animationDelay = 0.05;

@implementation GameObject
{
    NSMutableDictionary* animationDictionary;
}

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    
    if (self != nil) {
        lightCopy = [SKSpriteNode spriteNodeWithTexture:self.texture];
        animationDictionary = [NSMutableDictionary new];
        
        if (self.size.width > 0 && self.size.height > 0) {
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
            self.physicsBody.allowsRotation = NO;
            self.physicsBody.friction = 1.0;
        }
    }
    
    return self;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    
    if (self != nil) {
        lightCopy = [SKSpriteNode spriteNodeWithTexture:texture];
        animationDictionary = [NSMutableDictionary new];
        
        if (self.size.width > 0 && self.size.height > 0) {
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
            self.physicsBody.allowsRotation = NO;
            self.physicsBody.friction = 1.0;
        }
    }
    
    return self;
}

- (void)removeFromParent {
    [lightCopy removeFromParent];
    [super removeFromParent];
}

- (void)addAnimation:(NSArray*)animationList ByName:(NSString*)animationName {
    [animationDictionary setObject:animationList forKey:animationName];
}

- (void)startAnimation:(NSString*)animationName {
    NSArray* animationList = [animationDictionary objectForKey:animationName];
    if (animationList == nil) {
        return;
    }
    
    SKAction* animation = [SKAction repeatActionForever:[SKAction animateWithTextures:animationList timePerFrame:animationDelay]];
    [self removeAllActions];
    [self runAction:animation];
}

- (void)startOnceAnimation:(NSString *)animationName WithEndBlock:(void (^)())block {
    NSArray* animationList = [animationDictionary objectForKey:animationName];
    if (animationList == nil) {
        block();
        return;
    }
    
    SKAction* animation = [SKAction animateWithTextures:animationList timePerFrame:animationDelay];
    [self removeAllActions];
    [self runAction:animation completion:block];
}

- (void)startLightAnimation:(NSString*)animationName {
    NSArray* animationList = [animationDictionary objectForKey:animationName];
    if (animationList == nil) {
        return;
    }
    
    SKAction* animation = [SKAction repeatActionForever:[SKAction animateWithTextures:animationList timePerFrame:animationDelay]];
    [lightCopy removeAllActions];
    [lightCopy runAction:animation];
}

- (void)setParent:(SKNode *)parent {
    [parent addChild:self];
    [[parent scene] addChild:lightCopy];
}

- (void)setLightTexture:(SKTexture *)texture {
    [lightCopy removeAllActions];
    lightCopy.texture = texture;
}

- (void)setPosition:(CGPoint)position {
    lightCopy.position = position;
    [super setPosition:position];
}

- (void)update {
    CGPoint pos = self.position;
    SKNode* node = self;
    
    while (node.parent != [node scene]) {
        node = node.parent;
        pos.x += node.position.x;
        pos.y += node.position.y;
    }
    
    lightCopy.position = pos;
}

- (void)setCustomBodyRect:(CGRect)rect {
    rect.origin.x -= rect.size.width;
    rect.origin.y -= 0.5*rect.size.height;
    
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:CGPathCreateWithRect(rect, nil)];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.friction = 1.0;
}

- (void)setFall {
    
}

- (void)setGround {
    
}

- (void)lightOn {
    
}

- (void)setZPosition:(CGFloat)zPosition {
    //lightCopy.zPosition = zPosition;
    [super setZPosition:zPosition];
}

@end
