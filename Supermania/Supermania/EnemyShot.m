//
//  EnemyShot.m
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "EnemyShot.h"
#import "Globals.h"

@implementation EnemyShot

@synthesize startPosition;

- (id)init {
    self = [super init];
    if (self) {
        startPosition = ccp(0, 0);
        drainEnergy = 10;
    }
    return self;
}

- (void)setUpPosition:(CGPoint)position{
    [self setPosition: position];
    [self setStartPosition:ccp(0, 0)];
}

@end
