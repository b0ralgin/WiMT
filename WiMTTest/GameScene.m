//
//  GameScene.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameScene.h"
#import "Enemy.h"
#import "Mask.h"

static NSString *const leftButtonFilename = @"left_button.png";
static NSString *const rightButtonFilename = @"right_button.png";
static NSString *const jumpButtonFilename = @"jump_button.png";

@implementation GameScene {
    Girl* _girl;
    
    BOOL _isLightOn;
    
    float lastTime;
    
    int _health;
    NSMutableArray *_heartList;
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
    }
    return self;
}

- (void)loadLevel {
    
}

- (void)damage:(int)damage {
    
    for(int i = _heartList.count-1; i>=0; i--)
    {
        Heart *heart = _heartList[i];
        damage = [heart damage:damage];
        if(damage<=0)
        {
            break;
        }
    }
    
    if(damage > 0){
        //DEFEAT
    }
    
}

-(void)initHealth{
    _health = 6;
    _heartList = [NSMutableArray new];
    
    for(uint i=0; i<3; i++){
        Heart *heart = [Heart node];
        [self addChild:heart];
        [_heartList addObject:heart];
        heart.position = CGPointMake((i+1)*70, 680);
    }
    
    [self damage:3];
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
    
    GameObject *leftWall = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(100, self.size.height)];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.physicsBody.friction =0;
    leftWall.physicsBody.allowsRotation = NO;
    leftWall.position = CGPointMake(-0.5*leftWall.size.width, self.size.height/2);
    SetMask(leftWall.physicsBody, BOX_OBJECT);
    [self addChild:leftWall];
    
    GameObject *rightWall = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(100, self.size.height)];
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
    CGRect leftRect = CGRectMake(0, 0, 512, 384);
    CGRect rightRect = CGRectMake(512, 0, 512, 384);
    CGRect jumpRect = CGRectMake(0, 384, 1024, 384);
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (CGRectContainsPoint(leftRect, location)) {
            [_girl moveLeft];
        }
        if (CGRectContainsPoint(rightRect, location)) {
            [_girl moveRight];
        }
        if (CGRectContainsPoint(jumpRect, location)) {
            [_girl jump];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_girl stopMoving];
    }
}

-(void)moveGirlTo:(CGPoint)position {
    //NSLog(@"%f", self.position.x);
    for(Heart *heart in _heartList){
        heart.position = CGPointMake(position.x - 400, heart.position.y);
    }
    
    [background moveBackground:position.x];
}

-(void)update:(CFTimeInterval)currentTime {
    float dt = (lastTime == 0)?0: currentTime - lastTime;
    lastTime =  currentTime;
    
    [self updateNodeChildrens:self WithTime:dt];
    
    /* Called before each frame is rendered */
}

- (void)updateNodeChildrens:(SKNode*)node WithTime:(NSTimeInterval)dt {
    NSArray* childrenList = node.children;
    for (id child in childrenList) {
        if ([child scene] == nil) {
            continue;
        }
        
        if ([child respondsToSelector:@selector(update:)]) {
            [child update:dt];
        }
        
        [self updateNodeChildrens:child WithTime:dt];
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


}


@end
