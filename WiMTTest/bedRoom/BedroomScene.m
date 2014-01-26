//
//  BedroomScene.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "BedroomScene.h"
#import "Mask.h"

@implementation BedroomScene
{
    NSMutableArray *_eventList;
}

- (void)loadLevel {
    [self initBackground];
    [self initRoomBound:background.backgroundWidth];
    [self initObjects];
    [self initEvents];
}

- (void)initGirl {
    [super initGirl];
    
    /*[_girl turnOff];
    
    SKSpriteNode* mindBuble = [SKSpriteNode spriteNodeWithImageNamed:@"MindBuble"];
    SKSpriteNode* story1 = [SKSpriteNode spriteNodeWithImageNamed:@"Story1"];
    SKSpriteNode* story2 = [SKSpriteNode spriteNodeWithImageNamed:@"Story2"];
    SKSpriteNode* story3 = [SKSpriteNode spriteNodeWithImageNamed:@"Story3"];
    
    [self addChild:mindBuble];
    [self addChild:story1];
    [self addChild:story2];
    [self addChild:story3];
    
    mindBuble.zPosition = 1001;
    story1.zPosition = 1001;
    story2.zPosition = 1001;
    story3.zPosition = 1001;
    
    mindBuble.position = CGPointMake(270, 430);
    story1.position = CGPointMake(290, 460);
    story2.position = CGPointMake(290, 460);
    story3.position = CGPointMake(290, 460);
    
    mindBuble.alpha = 0.0;
    story1.alpha = 0.0;
    story2.alpha = 0.0;
    story3.alpha = 0.0;
    
    SKAction* showSprite = [SKAction fadeAlphaTo:1.0 duration:2.0];
    SKAction* hideSprite = [SKAction fadeAlphaTo:0.0 duration:1.0];
    SKAction* wait0 = [SKAction waitForDuration:1.0];
    SKAction* wait1 = [SKAction waitForDuration:4.0];
    SKAction* wait2 = [SKAction waitForDuration:8.0];
    
    [mindBuble runAction:[SKAction sequence:@[showSprite, wait0, hideSprite, showSprite, wait0, hideSprite, showSprite, wait0, hideSprite]]];
    [story1 runAction:[SKAction sequence:@[showSprite, wait0, hideSprite]]];
    [story2 runAction:[SKAction sequence:@[wait1, showSprite, wait0, hideSprite]]];
    [story3 runAction:[SKAction sequence:@[wait2, showSprite, wait0, hideSprite]]];
    
    [_girl performSelector:@selector(turnOn) withObject:Nil afterDelay:7.5];*/
}

- (void)initBackground{
    background = [SceneBackground node];
    [darkSideNode addChild:background];
    background.zPosition = -1;
    
    [background setTileList:@[@"BedroomDark", @"BedroomWindowDark", @"BedroomDark"] LightVersion:@[@"BedroomLight", @"BedroomWindowLight", @"BedroomLight"]];
}

- (void)initObjects {
    [self addObject:@"BedDark" Light:@"BedLight" WithObjectType:ROOM_OBJECT OnPos:CGPointMake(0, 120) Dynamic:NO];
    [self addObject:@"BedroomChairDark" Light:@"BedroomChairLight" WithObjectType:BOX_OBJECT OnPos:CGPointMake(450, 108) Dynamic:YES];
    Trap* mucus = [self addTrap:@"Mucus" Light:@"Carpet" OnPos:CGPointMake(800, 100) Dynamic:NO];
    [self addObject:@"BedroomPicture" Light:nil WithObjectType:ROOM_OBJECT OnPos:CGPointMake(500, 500) Dynamic:NO];
    [self addObject:@"ToyBox" Light:nil WithObjectType:BOX_OBJECT OnPos:CGPointMake(1000, 108) Dynamic:NO];
    [self addObject:@"BedroomShelf" Light:nil WithObjectType:ROOM_OBJECT OnPos:CGPointMake(1600, 500) Dynamic:NO];
    [self addObject:@"switch_off" Light:nil WithObjectType:SWITCH_OBJECT OnPos:CGPointMake(1370, 550) Dynamic:NO];
    [self addObject:@"BedroomDoorClose" Light:nil WithObjectType:DOOR_OBJECT OnPos:CGPointMake(1700, 120) Dynamic:NO];
    Enemy* doll = [self addEnemy:@"Doll" Light:@"DollLight" OnPos:CGPointMake(1100, 108) Dynamic:YES];
    
    mucus.activeTime = 0;
    [mucus trapOn];
    
    doll.moveSpeed = 2;
    [doll move];
}

- (void)openDoor:(GameObject*)door {
    if (!darkSideNode.hidden) {
        return;
    }

    [door setLightTexture:[SKTexture textureWithImageNamed:@"BedroomDoorOpen"]];
    
    [super openDoor:door];
}

-(void)initEvents{
    _eventList = [NSMutableArray new];

    Event *event = [[Event alloc] init];
    event.text = @"Hello, I lost my Teddy. Please, help me find Him";
    event.location = 100;
    [_eventList addObject:event];
    
    event = [[Event alloc] init];
    event.text = @"To jump loud shout!";
    event.location = 500;
    [_eventList addObject:event];
    
    event = [[Event alloc] init];
    event.text = @"Aaah! This is danger acid! Jump!";
    event.location = 700;
    [_eventList addObject:event];
    
    event = [[Event alloc] init];
    event.text = @"I see something dark... I'm scary!";
    event.location = 950;
    [_eventList addObject:event];
    
    event = [[Event alloc] init];
    event.text = @"I need to turn light on!";
    event.location = 1200;
    [_eventList addObject:event];
}

-(void)update:(NSTimeInterval)currentTime{
    for(uint i = 0; i<_eventList.count; i++){
        Event * event = _eventList[i];
        if(event.state == NotShown && event.location < _girl.position.x){
            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            
            label.text = event.text;
            label.fontSize = 30;
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            label.position = CGPointMake(_girl.position.x, 650);
            label.zPosition = 1111000;
            [self addChild:label];
            event.state = Showing;
            event.label = label;
            SKAction *delay = [SKAction waitForDuration:3.0f];
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5f];
            SKAction *sequenceAction = [SKAction sequence:@[delay,fadeOut]];
            [label runAction:sequenceAction completion:^(void){event.state = Shown;}];
            
            for(uint j = 0; j<i; j++){
                Event * earlierEvent = _eventList[j];
                if(earlierEvent.state == Showing){
                    earlierEvent.label.hidden = YES;
                    earlierEvent.state = Shown;
                }
            }
        }
    }
}
@end
