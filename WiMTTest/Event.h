//
//  Event.h
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
typedef enum{NotShown = 0, Showing, Shown} EventState;
@interface Event : NSObject
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) float location;
@property (assign, nonatomic) EventState state;
@property (strong, nonatomic) SKLabelNode *label;
@end
