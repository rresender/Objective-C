//
//  SMSprite.m
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "SMSprite.h"
#import "Globals.h"
#import "NaveShot.h"

@implementation SMSprite

@synthesize velocity, drainEnergy;

- (id)init {
    self = [super init];
    if (self) {
        drainEnergy = DEFAULT_DRAIN_ENERGY;
    }
    return self;
}

- (float)radius
{
	return self.texture.contentSize.width / 2;
}

- (CGRect)rect
{
    CGSize contentSize = [self contentSize];
	CGPoint contentPosition = [self position];
	CGRect result = CGRectOffset(CGRectMake(0, 0, contentSize.width, contentSize.height), contentPosition.x-contentSize.width/2, contentPosition.y-contentSize.height/2);
	return result;
}

- (BOOL)collideWithSprite:(SMSprite *)sprite
{
    if(CGRectIntersectsRect([self rect], [sprite rect]))
        return YES;
    return NO;
}



@end
