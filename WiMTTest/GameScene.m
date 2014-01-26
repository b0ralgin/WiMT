//
//  GameScene.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameScene.h"

static NSString *const leftButtonFilename = @"left_button.png";
static NSString *const rightButtonFilename = @"right_button.png";
static NSString *const jumpButtonFilename = @"jump_button.png";

@implementation GameScene {
    NSMutableArray *_heartList;
    GameObject* puf;
    float offset;
}

- (instancetype)initWithSize:(CGSize)size
{
    if (( self = [super initWithSize:size] )) {
        lastTime = 0;
        self.physicsWorld.gravity = CGVectorMake(0, -4);
        self.physicsWorld.contactDelegate = self;
        
        darkSideNode = [SKCropNode new];
        darkSideNode.zPosition = 100;
        [self addChild:darkSideNode];
        
        [self loadLevel];
        [self initGirl];
        [self initHealth];
        
        NSMutableArray* pufList = [NSMutableArray new];
        for (int i = 0; i < 12; i++) {
            [pufList addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Puf%d", i]]];
        }
        
        puf = [GameObject spriteNodeWithTexture:[pufList firstObject]];
        puf.physicsBody = nil;
        [puf addAnimation:pufList ByName:@"Puf"];
        puf.hidden = YES;
        [self addChild:puf];
        puf.zPosition = 2000;
    }
    return self;
}

- (void)loadLevel {
    
}

- (void)damage:(int)damage {
    puf.hidden = NO;
    
    [puf startOnceAnimation:@"Puf" WithEndBlock:^() {puf.hidden = YES;}];
    
    for (int i = _heartList.count-1; i>=0; i--) {
        Heart *heart = _heartList[i];
        damage = [heart damage:damage];
        if (damage <= 0) {
            break;
        }
    }
    
    if (damage > 0) {
        //DEFEAT
    }
}

- (void)initHealth{
    _heartList = [NSMutableArray new];
    
    for(uint i = 0; i< 3; i++){
        Heart *heart = [Heart node];
        heart.zPosition = 2000;
        [self addChild:heart];
        [_heartList addObject:heart];
        heart.position = CGPointMake((i+1)*70, 680);
    }
}

- (void)initGirl
{
    _girl = [[Girl alloc] init];
    _girl.position = CGPointMake(100, 400);
    _girl.zPosition = 1000;
    _girl.delegate = self;
    [_girl setParent:darkSideNode];
}

- (void)initRoomBound:(float)width {
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0] size:CGSizeMake(width, 100)];
    [self addChild:floor];
    floor.position = CGPointMake(width/2, 108-0.5*floor.size.height);
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.allowsRotation = NO;
    floor.physicsBody.dynamic = NO;
    SetMask(floor.physicsBody, BOX_OBJECT);
    
    GameObject *ceiling = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(width, 100)];
    ceiling.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ceiling.size];
    ceiling.physicsBody.dynamic = NO;
    ceiling.physicsBody.allowsRotation = NO;
    ceiling.position = CGPointMake(width/2, self.size.height + 0.5*ceiling.size.height);
    SetMask(ceiling.physicsBody, BOX_OBJECT);
    [self addChild:ceiling];
    
    GameObject *leftWall = [GameObject spriteNodeWithImageNamed:@"wall2"];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.physicsBody.friction =0;
    leftWall.physicsBody.allowsRotation = NO;
    leftWall.position = CGPointMake(-0.5*leftWall.size.width, self.size.height/2);
    SetMask(leftWall.physicsBody, BOX_OBJECT);
    [self addChild:leftWall];
    
    GameObject *rightWall = [GameObject spriteNodeWithImageNamed:@"wall2"];
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWall.size];
    rightWall.physicsBody.dynamic = NO;
        leftWall.physicsBody.friction =0;
    rightWall.physicsBody.allowsRotation = NO;
    rightWall.position = CGPointMake(width + 0.5*rightWall.size.width, self.size.height/2);
    SetMask(rightWall.physicsBody, BOX_OBJECT);
    [self addChild:rightWall];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    CGRect leftRect = CGRectMake(0, 0, 512, 768);
    CGRect rightRect = CGRectMake(512, 0, 512, 768);
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        //location.x -= offset;
        
        if (CGRectContainsPoint(leftRect, location)) {
            [_girl moveLeft];
        }
        if (CGRectContainsPoint(rightRect, location)) {
            [_girl moveRight];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        [_girl stopMoving];
    }
}

-(void)moveGirlTo:(CGPoint)position {
    offset = position.x;
    
    //NSLog(@"%f", self.position.x);
    for(int i = 0; i < _heartList.count; i++){
        Heart *heart = _heartList[i];
        heart.position = CGPointMake(position.x - 400 + 70*i, heart.position.y);
    }
    
    puf.position = position;
    
    [background moveBackground:position.x];
}

- (void)didSimulatePhysics {
    [self sendNodeChildrens:self Selector:@selector(update)];
}

- (void)sendNodeChildrens:(SKNode*)node Selector:(SEL)selector {
    NSArray* childrenList = node.children;
    for (id child in childrenList) {
        if ([child scene] == nil) {
            continue;
        }
        
        if ([child respondsToSelector:selector]) {
            [child performSelector:selector];
        }
        
        [self sendNodeChildrens:child Selector:selector];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    id nodeA = contact.bodyA.node;
    id nodeB = contact.bodyB.node;
    
    if ([nodeA position].y > [nodeB position].y) {
        nodeA = contact.bodyB.node;
        nodeB = contact.bodyA.node;
    }
    
    if ([nodeB physicsBody].velocity.dy == 0 && [nodeB respondsToSelector:@selector(setGround)]) {
        [nodeB setGround];
    }

    
    //Switch
    if ((contact.bodyA.categoryBitMask == kCategoryList[SWITCH_OBJECT] && contact.bodyB.categoryBitMask == kCategoryList[GIRL_OBJECT]) ||
        (contact.bodyB.categoryBitMask == kCategoryList[SWITCH_OBJECT] && contact.bodyA.categoryBitMask == kCategoryList[GIRL_OBJECT])) {
        [self lightOn];
    }
    
    //Door
    if (contact.bodyA.categoryBitMask == kCategoryList[DOOR_OBJECT] && contact.bodyB.categoryBitMask == kCategoryList[GIRL_OBJECT]) {
        [self openDoor:(GameObject*)contact.bodyA.node];
    }
    
    if (contact.bodyB.categoryBitMask == kCategoryList[ENEMY_OBJECT]) {
        if ([contact.bodyB.node respondsToSelector:@selector(move)]) {
            [(Enemy*)contact.bodyB.node move];
        }
    }
    
    if (contact.bodyB.categoryBitMask == kCategoryList[CHAINSAW_OBJECT] && _girl.isAttack) {
        if ([contact.bodyA.node respondsToSelector:@selector(damage:)]) {
            [(Enemy*)contact.bodyA.node damage:1];
        }
    }
    if (contact.bodyA.categoryBitMask == kCategoryList[CHAINSAW_OBJECT] && _girl.isAttack) {
        if ([contact.bodyB.node respondsToSelector:@selector(damage:)]) {
            [(Enemy*)contact.bodyB.node damage:1];
        }
    }
    if (contact.bodyB.categoryBitMask == kCategoryList[GIRL_OBJECT]) {
        if ([contact.bodyB.node.name isEqualToString:@"Girl"]) {
            if (contact.bodyA.categoryBitMask == kCategoryList[ENEMY_OBJECT] || contact.bodyA.categoryBitMask == kCategoryList[TRAP_OBJECT]) {
                BOOL attackFlag = YES;
                
                if ([contact.bodyA.node respondsToSelector:@selector(isActive)]) {
                    attackFlag = [(Trap*)contact.bodyA.node isActive];
                }
                
                if (attackFlag) {
                    if ([contact.bodyA.node respondsToSelector:@selector(attack)]) {
                        [(Enemy*)contact.bodyA.node attack];
                    }
                    
                    [self damage:1];
                }
            }
        }
    }
}

- (void)lightOn {
    darkSideNode.hidden = YES;
    [self sendNodeChildrens:self Selector:@selector(lightOn)];
}

- (void)openDoor:(GameObject*)door {
    [[SceneDirector shared] runNextLevel];
}

- (void)addObject:(NSString*)objName Light:(NSString*)lightName WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    GameObject* obj = [GameObject spriteNodeWithImageNamed:objName];
    if (lightName != nil) {
        [obj setLightTexture:[SKTexture textureWithImageNamed:lightName]];
    }
    
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, objType);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
}

- (Enemy*)addEnemy:(NSString*)enemyName Light:(NSString*)lightName OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    NSMutableArray* enemyStandAnimation = [NSMutableArray new];
    NSMutableArray* enemyWalkAnimation = [NSMutableArray new];
    NSMutableArray* enemyAttackAnimation = [NSMutableArray new];
    
    for (uint i = 0; ; i++) {
        SKTexture* standTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Stand%d", enemyName, i]];
        SKTexture* walkTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Move%d", enemyName, i]];
        SKTexture* attackTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Attack%d", enemyName, i]];
        
        if (standTexture.size.height != 128) {
            [enemyStandAnimation addObject:standTexture];
        }
        if (walkTexture.size.height != 128) {
            [enemyWalkAnimation addObject:walkTexture];
        }
        if (attackTexture.size.height != 128) {
            [enemyAttackAnimation addObject:attackTexture];
        }
        
        if (standTexture.size.height == 128 && walkTexture.size.height == 128 && attackTexture.size.height == 128) {
            break;
        }
    }
    
    Enemy* obj = [[Enemy alloc] initWithTexture:[enemyStandAnimation firstObject]];
    if (lightName != nil) {
        [obj setLightTexture:[SKTexture textureWithImageNamed:lightName]];
    }
    
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, ENEMY_OBJECT);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
    
    [obj addAnimation:enemyStandAnimation ByName:enemyStandAnimationName];
    [obj addAnimation:enemyWalkAnimation ByName:enemyWalkAnimationName];
    [obj addAnimation:enemyAttackAnimation ByName:enemyAttackAnimationName];
    
    return obj;
}

- (Trap*)addTrap:(NSString*)trapName Light:(NSString*)lightName OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    NSMutableArray* trapOnAnimation = [NSMutableArray new];
    NSMutableArray* trapOffAnimation = [NSMutableArray new];
    NSMutableArray* trapActiveAnimation = [NSMutableArray new];
    NSMutableArray* trapDeactiveAnimation = [NSMutableArray new];
    
    [trapOffAnimation addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Off",trapName]]];
    
    for (uint i = 0; ; i++) {
        SKTexture* onTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@On%d", trapName, i]];
        SKTexture* activeTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Active%d", trapName, i]];
        SKTexture* deactiveTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Deactive%d", trapName, i]];
        
        if (onTexture.size.height != 128) {
            [trapOnAnimation addObject:onTexture];
        }
        if (activeTexture.size.height != 128) {
            [trapActiveAnimation addObject:activeTexture];
        }
        if (deactiveTexture.size.height != 128) {
            [trapDeactiveAnimation addObject:deactiveTexture];
        }
        
        if (onTexture.size.height == 128 && activeTexture.size.height == 128 && deactiveTexture.size.height == 128) {
            break;
        }
    }
    
    Trap* obj = [[Trap alloc] initWithTexture:[trapOnAnimation firstObject]];
    if (lightName != nil) {
        [obj setLightTexture:[SKTexture textureWithImageNamed:lightName]];
    }
    
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, TRAP_OBJECT);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
    
    [obj addAnimation:trapOnAnimation ByName:trapOnAnimationName];
    [obj addAnimation:trapOffAnimation ByName:trapOffAnimationName];
    [obj addAnimation:trapActiveAnimation ByName:trapActiveAnimationName];
    [obj addAnimation:trapDeactiveAnimation ByName:trapDeactiveAnimationName];
    
    return obj;
}

- (void)addAnimateObject:(NSArray*)objNameList WithObjectType:(GameObjectType)objType OnPos:(CGPoint)pos Dynamic:(BOOL)dyn {
    NSMutableArray* animationList = [NSMutableArray new];
    for (NSString* textureName in objNameList) {
        [animationList addObject:[SKTexture textureWithImageNamed:textureName]];
    }
    
    GameObject* obj = [GameObject spriteNodeWithTexture:[animationList firstObject]];
    [obj addAnimation:animationList ByName:@"Start animation"];
    [obj startAnimation:@"Start animation"];
    
    obj.physicsBody.dynamic = dyn;
    SetMask(obj.physicsBody, objType);
    obj.position = CGPointMake(roundf(pos.x + 0.5*obj.size.width), roundf(pos.y + 0.5*obj.size.height));
    
    [obj setParent:darkSideNode];
}

@end
