//
//  Event.m
//  WiMTTest
//
//  Created by Alexander Semenov on 26.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Event.h"

@implementation Event
@synthesize text = _text;
@synthesize location = _location;
@synthesize state = _state;
-(instancetype) init{
    if(( self = [super init] ))
    {
        _state = NotShown;
    }
    return self;
}
@end
