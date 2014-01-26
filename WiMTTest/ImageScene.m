//
//  ImageScene.m
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "ImageScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation ImageScene
{
    AVAudioPlayer * player;
}

- (instancetype)initWithImage:(NSString *)imageName {
    self = [super initWithSize:CGSizeMake(1024, 768)];
    
    if (self != nil) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        sprite.position = CGPointMake(512, 384);
        [self addChild:sprite];
        
        //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"nyanaynay" ofType:@"wav"]];
        //player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

        [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"nyanaynay.mp3" waitForCompletion:YES]]];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self removeAllActions];
    //[player stop];
    [[SceneDirector shared] runNextLevel];
}

@end
