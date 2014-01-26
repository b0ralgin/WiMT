//
//  ViewController.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SceneDirector shared] setViewController:self];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        [self runLevel:0];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)runLevel:(int)levelNumber{
    SKView * skView = (SKView *)self.view;
    
    GameScene *nextLevel = nil;
    switch (levelNumber) {
        case 0: {
            nextLevel = [[ImageScene alloc] initWithImage:@"splash"];
            SKSpriteNode* text = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu_name"];
            text.position = CGPointMake(512, 500);
            [nextLevel addChild:text];
            break;
        }
            
        case 1:
            nextLevel = [BedroomScene sceneWithSize:CGSizeMake(1024, 768)];
            break;
            
        case 2:
            nextLevel = [LivingScene sceneWithSize:CGSizeMake(1024, 768)];
            break;
            
        case 3:
            nextLevel = [[ImageScene alloc] initWithImage:@"end_screen"];
            break;
            
        default:
            return;
    }
    
    nextLevel.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:nextLevel transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:2.0]];
    if ([nextLevel respondsToSelector:@selector(startAnimation)])
        [nextLevel startAnimation];
}

@end
