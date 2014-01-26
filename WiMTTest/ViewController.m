//
//  ViewController.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController{
    NSMutableArray *gameLevelList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SceneDirector shared] setViewController:self];
    [self initGameLevels];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        CGSize size = CGSizeMake(1024, 768);
        CGSize sizeView =skView.bounds.size;
    
        SKScene * scene = [BedroomScene sceneWithSize:size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

-(void)initGameLevels{
    gameLevelList = [NSMutableArray new];
    [gameLevelList addObject:[BedroomScene sceneWithSize:CGSizeMake(1024, 768)]];
    [gameLevelList addObject:[LivingScene sceneWithSize:CGSizeMake(1024, 768)]];
    
    for (SKScene* scene in gameLevelList) {
        scene.scaleMode = SKSceneScaleModeAspectFill;
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
    if (levelNumber >= gameLevelList.count) {
        return;
    }
    
    GameScene *nextLevel = gameLevelList[levelNumber];
    [skView presentScene:nextLevel transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:2.0]];
}
@end
