//
//  NaveShot.m
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "NaveShot.h"


@implementation NaveShot

@synthesize startPosition;

- (id)init {
    self = [super init];
    if (self) {
        startPosition = ccp(0, 0);
    }
    return self;
}

@end
