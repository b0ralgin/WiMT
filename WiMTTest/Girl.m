//
//  Girl.m
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Girl.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static NSString* const girlDarkStand[] = {@"GirlStand0", @"GirlStand1", @"GirlStand2", @"GirlStand3", @"GirlStand4", @"GirlStand5", @"GirlStand6", @"GirlStand7", nil};
static NSString* const girlDarkMove[] = {@"GirlWalk0", @"GirlWalk1", @"GirlWalk2", @"GirlWalk3", @"GirlWalk4", @"GirlWalk5", @"GirlWalk6", @"GirlWalk7", nil};
static NSString* const girlDarkCStand[] = {@"GirlCStand0", @"GirlCStand1", nil};
static NSString* const girlDarkCMove[] = {@"GirlCWalk0", @"GirlCWalk1", @"GirlCWalk2", @"GirlCWalk3", @"GirlCWalk4", @"GirlCWalk5", @"GirlCWalk6", @"GirlCWalk7", nil};
static NSString* const girlDarkFly[] = {@"GirlFly0", nil};
static NSString* const girlDarkFall[] = {@"GirlFall0", nil};
static NSString* const girlLightStand[] = {@"GirlStand0", @"GirlStand1", @"GirlStand2", @"GirlStand3", @"GirlStand4", @"GirlStand5", @"GirlStand6", @"GirlStand7", nil};
static NSString* const girlLightMove[] = {@"GirlWalk0", @"GirlWalk1", @"GirlWalk2", @"GirlWalk3", @"GirlWalk4", @"GirlWalk5", @"GirlWalk6", @"GirlWalk7", nil};
static NSString* const girlLightFly[] = {@"GirlFly0", nil};
static NSString* const girlLightFall[] = {@"GirlFall0", nil};

static NSString* const activeWeapon[] = {@"Chainsaw0", @"Chainsaw1", nil};

static NSString* const darkStandAnimationName = @"Dark stand";
static NSString* const darkMoveAnimationName = @"Dark stand12";
static NSString* const darkCStandAnimationName = @"Dark dwstand";
static NSString* const darkCMoveAnimationName = @"Dark sewtand12";
static NSString* const darkFlyAnimationName = @"Dark stand2";
static NSString* const darkFalLAnimationName = @"Dark 3";
static NSString* const lightStandAnimationName = @"Dark stand4";
static NSString* const lightMoveAnimationName = @"Dark stan5d";
static NSString* const lightFlyAnimationName = @"Dark sta6nd";
static NSString* const lightFallAnimationName = @"Dark st7and";

static CGPoint const weaponOffset = {90, -43};

static NSTimeInterval const animationDelay = 0.05;
static float const moveSpeed = 50;
static float const maxSpeed = 250;
static float const jumpPower = 400;

typedef enum {GROUND_STATE, FLY_STATE, FALL_STATE} GirlJumpStateType;
typedef enum {STAND_STATE, MOVE_STATE} GirlMoveStateType;
typedef enum {ATTACK_STATE, PASSIVE_STATE} GirlAttackStateType;
typedef enum {NORMAL_STATE, GIRL_OFF_STATE} GirlActiveStateType;

@implementation Girl {
    GameObject* weapon;
    
    GirlJumpStateType jumpState;
    GirlMoveStateType moveState;
    GirlAttackStateType attackState;
    GirlActiveStateType activeState;
    
    uint32_t weaponCategoryMask;
    
    AVAudioRecorder *recorder;
    BOOL allowAttack;
}

- (instancetype)init {
    self = [super initWithImageNamed:girlDarkStand[0]];
    
    if (self != nil) {
        self.name = @"Girl";
        
        [self setCustomBodyRect:CGRectMake(55, 0, 90, 181)];
        
        activeState = NORMAL_STATE;
        jumpState = FALL_STATE;
        moveState = STAND_STATE;
        attackState = PASSIVE_STATE;
        
        allowAttack = YES;
        recorder = nil;
        self.delegate = nil;
        
        [self initTextures];
        [self initWeapon];
        
        self.physicsBody.contactTestBitMask = kContactList[GIRL_OBJECT];
        self.physicsBody.collisionBitMask = kCollisionList[GIRL_OBJECT];
        self.physicsBody.categoryBitMask = kCategoryList[GIRL_OBJECT];
        self.physicsBody.dynamic = YES;
        
        [self startAnimation];
        [self startAudioRec];
        
        [self stopAttack];
    }
    
    return self;
}

- (void)initTextures {
    NSMutableArray* animationList = [NSMutableArray new];
    for (ushort i = 0; girlDarkStand[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkStand[i]]];
        [self addAnimation:animationList ByName:darkStandAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlDarkMove[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkMove[i]]];
        [self addAnimation:animationList ByName:darkMoveAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlDarkCStand[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkCStand[i]]];
        [self addAnimation:animationList ByName:darkCStandAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlDarkCMove[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkCMove[i]]];
        [self addAnimation:animationList ByName:darkCMoveAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlDarkFly[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkFly[i]]];
        [self addAnimation:animationList ByName:darkFlyAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlDarkFall[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkFall[i]]];
        [self addAnimation:animationList ByName:darkFalLAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlLightStand[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightStand[i]]];
        [self addAnimation:animationList ByName:lightStandAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlLightMove[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightMove[i]]];
        [self addAnimation:animationList ByName:lightMoveAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlLightFly[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightFly[i]]];
        [self addAnimation:animationList ByName:lightFlyAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; girlLightFall[i] != nil; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightFall[i]]];
        [self addAnimation:animationList ByName:lightFallAnimationName];
    }
}

- (void)initWeapon {
    weapon = [GameObject spriteNodeWithImageNamed:activeWeapon[0]];
    SetMask(weapon.physicsBody, CHAINSAW_OBJECT);
    weapon.physicsBody.dynamic = NO;
    weapon.position = weaponOffset;
   // [ weapon setCustomBodyRect:CGRectMake(0, 0, weapon.size.width/2, weapon.size.height)];
   
   // [self addChild:weapon];
    
    NSMutableArray* weaponAnimationList = [NSMutableArray new];
    for (ushort i = 0; activeWeapon[i] != nil; i++) {
        [weaponAnimationList addObject:[SKTexture textureWithImageNamed:activeWeapon[i]]];
    }
    
    SKAction* weaponAnimation = [SKAction animateWithTextures:weaponAnimationList timePerFrame:animationDelay];
    weaponAnimation = [SKAction repeatActionForever:weaponAnimation];
    [weapon runAction:weaponAnimation];
    
    attackState = ATTACK_STATE;
    [self endAttack];
}

- (void)moveLeft {
    if (activeState == GIRL_OFF_STATE || (moveState == MOVE_STATE && self.xScale < 0)) {
        return;
    }
    
    moveState = MOVE_STATE;
    
    self.xScale = -1;
    [self startAnimation];
}

- (void)moveRight {
    if (activeState == GIRL_OFF_STATE || (moveState == MOVE_STATE && self.xScale > 0)) {
        return;
    }
    
    moveState = MOVE_STATE;
    
    self.xScale = 1;
    [self startAnimation];
}

- (void)stopMoving {
    if (moveState == STAND_STATE) {
        return;
    }
    
    self.physicsBody.velocity = CGVectorMake(0, self.physicsBody.velocity.dy);
    moveState = STAND_STATE;
    
    [self startAnimation];
}

- (void)startAnimation {
    switch (jumpState) {
        case GROUND_STATE:
            if (moveState == STAND_STATE) {
                switch (attackState) {
                    case PASSIVE_STATE:
                        [self startAnimation:darkStandAnimationName];
                        break;
                        
                    case ATTACK_STATE:
                        [self startAnimation:darkCStandAnimationName];
                        break;
                }
                
                [self startLightAnimation:lightStandAnimationName];
            }
            
            if (moveState == MOVE_STATE) {
                switch (attackState) {
                    case PASSIVE_STATE:
                        [self startAnimation:darkMoveAnimationName];
                        break;
                        
                    case ATTACK_STATE:
                        [self startAnimation:darkCMoveAnimationName];
                        break;
                }
                
                [self startLightAnimation:lightMoveAnimationName];
            }
            
            break;
            
        case FLY_STATE:
            //if (attackState == PASSIVE_STATE) {
            [self startAnimation:darkFlyAnimationName];
            [self startLightAnimation:lightFlyAnimationName];
            //}
            
            break;
            
        case FALL_STATE:
            //if (attackState == PASSIVE_STATE) {
            [self startAnimation:darkFalLAnimationName];
            [self startLightAnimation:lightFallAnimationName];
            //}
            
            break;
    }
}

- (void)update {
    SKAction* moveSceneAction = [SKAction moveTo:CGPointMake(512-self.position.x, 0) duration:0];
    [[self scene] runAction:moveSceneAction];
    
    weapon.position = weaponOffset;
    
    if (self.delegate != nil) {
        [self.delegate moveGirlTo:self.position];
    }
    
    if (moveState == MOVE_STATE) {
        [self.physicsBody applyImpulse:CGVectorMake(self.xScale*moveSpeed, 0)];
    }
    
    if (self.physicsBody.velocity.dx > maxSpeed) {
        self.physicsBody.velocity = CGVectorMake(maxSpeed, self.physicsBody.velocity.dy);
    }
    
    if (self.physicsBody.velocity.dx < -maxSpeed) {
        self.physicsBody.velocity = CGVectorMake(-maxSpeed, self.physicsBody.velocity.dy);
    }
    
    if (self.physicsBody.velocity.dy < 0) {
        [self setFall];
    }
    
    if (self.physicsBody.velocity.dy == 0) {
        [self setGround];
    }
    
    if (recorder != nil) {
        [recorder updateMeters];
        
        if (activeState == NORMAL_STATE) {
            //double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
            
            double avaragePowerForChannel = 1000 * pow(10, (0.25 * [recorder averagePowerForChannel:0]));
            
            if (avaragePowerForChannel > 0.01) {
                [self beginAttack];
            }
            else {
                [self endAttack];
            }
            
            if (avaragePowerForChannel > 3.5) {
                [self jump];
            }
        }
    }
    
    [super update];
}

- (void)jump {
    if (activeState == GIRL_OFF_STATE || jumpState != GROUND_STATE) {
        return;
    }
    
    [self stopAttack];
    
    [self.physicsBody applyImpulse:CGVectorMake(0, jumpPower)];
    jumpState = FLY_STATE;
}

- (void)startOpenDoorAnimation {
    self.xScale = 1;
    moveState = STAND_STATE;
}

- (void)setWeaponContactBitMask:(uint32_t)mask {
    weapon.physicsBody.contactTestBitMask = mask;
}

- (void)setWeaponCategoryBitMask:(uint32_t)mask {
    weaponCategoryMask = mask;
}

- (void)setWeaponCollisionBitMask:(uint32_t)mask {
    weapon.physicsBody.collisionBitMask = mask;
}

- (void)beginAttack {
    if (attackState == ATTACK_STATE || !allowAttack) {
        return;
    }
    
    attackState = ATTACK_STATE;
    
   // weapon.hidden = NO;
    [self addChild:weapon];
    [self startAnimation];
}

- (void)endAttack {
    if (attackState == PASSIVE_STATE) {
        return;
    }
    attackState = PASSIVE_STATE;
    
   // weapon.hidden = YES;
    [weapon removeFromParent];
    [self startAnimation];
}

- (void)startAudioRec {
    allowAttack = YES;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
    
	NSError *error;
    
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
	}
    else {
        NSLog(@"audio error - %@", [error description]);
    }
}

- (void)stopAttack {
    [self endAttack];
    allowAttack = NO;
    //[recorder stop];
}

- (void)resumeAttack {
    allowAttack = YES;
    //[recorder record];
}

- (void)setFall {
    if (jumpState == FALL_STATE) {
        return;
    }
    
    [self stopAttack];
    
    jumpState = FALL_STATE;
    
    [self startAnimation];
}

- (void)setGround {
    if (jumpState == GROUND_STATE) {
        return;
    }
    
    [self resumeAttack];
    
    jumpState = GROUND_STATE;
    
    [self startAnimation];
}

- (void)setXScale:(CGFloat)xScale {
    lightCopy.xScale = xScale;
    [super setXScale:xScale];
}

- (void)setPosition:(CGPoint)position {
    SKAction* moveSceneAction = [SKAction moveTo:CGPointMake(512-position.x, 0) duration:0];
    [[self scene] runAction:moveSceneAction];
    
    if (self.delegate != nil) {
        [self.delegate moveGirlTo:self.position];
    }
    
    [super setPosition:position];
}

- (void)turnOn {
    activeState = NORMAL_STATE;
}

- (void)turnOff {
    [self stopMoving];
    [self stopAttack];
    activeState = GIRL_OFF_STATE;
}

- (BOOL)isAttack {
    return !weapon.hidden;
}

@end
