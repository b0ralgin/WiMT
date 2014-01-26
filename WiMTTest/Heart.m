//
//  Heart.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Heart.h"
static NSString *const emptyHeartFilename = @"emptyHeart.png";
static NSString *const halfHeartFilename = @"halfHeart.png";
static NSString *const fullHearttFilename = @"fullHeart.png";

static const int START_HP = 2;

@implementation Heart{
    int hp;
    SKTexture* heart[3];
}

-(instancetype)init{
    if (( self = [super initWithImageNamed:fullHearttFilename]))
    {
        hp = START_HP;
        heart[0] = [SKTexture textureWithImageNamed:emptyHeartFilename];
        heart[1] = [SKTexture textureWithImageNamed:halfHeartFilename];
        heart[2] = [SKTexture textureWithImageNamed:fullHearttFilename];
    }
    return self;
}

- (int)damage:(int)damage {
    int rest = damage - hp;
    
    hp -= damage;
    if (hp < 0) {
        hp = 0;
    }
    
    [self showAnimation];
    return rest;
}

- (int)restore:(int)health {
    int rest = health - START_HP + hp;
    
    hp += health;
    if (hp > START_HP) {
        hp = START_HP;
    }
    
    [self showAnimation];
    return rest;
}

-(void)showAnimation {
    self.texture = heart[hp];
}
@end
