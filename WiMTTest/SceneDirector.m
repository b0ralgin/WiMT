//
//  SceneDirector.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SceneDirector.h"
#import "ViewController.h"

@implementation SceneDirector{
    ViewController *_viewController;
    int currentLevel;
}
static SceneDirector *instance = nil;

+ (SceneDirector *) shared{
    if(instance == nil){
        instance = [[SceneDirector alloc] init];
    }
    return instance;
}

-(instancetype)init{
    if(( self = [super init] )){
        currentLevel = 0;
        _viewController = nil;
    }
    return self;
}

-(void)setViewController: (ViewController *) viewController{
    _viewController = viewController;
}

-(void)runNextLevel {
    currentLevel++;
    if (currentLevel > 3) {
        currentLevel = 0;
    }
    
    [_viewController runLevel:currentLevel];
}

- (void)restartLevel {
    [_viewController runLevel:currentLevel];
}
@end
