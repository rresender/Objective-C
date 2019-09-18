//
//  Background.m
//  Supermania
//
//  Created by Renato Resende on 5/5/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "Background.h"
#import "Globals.h"

@implementation Background

- (void)move:(ccTime)delta direction:(int)aDirection
{
//    float velocityY =  (self.position.y - (self.velocity.y * aDiretion * delta));
//    
//    CGPoint position = ccp(self.position.x, velocityY);
//    
//    [self setPosition: position];
    
    CGPoint point = self.position;
    
    point.x += velocity.x * delta * aDirection;
	point.y += velocity.y * delta * aDirection;
	
	if (point.x >= MAX_LIMIT_X || point.x <= MIN_LIMIT_X) {
		velocity.x = -velocity.x;
	}
	
	if (point.y >= MAX_LIMIT_Y || point.y <= MIN_LIMIT_Y) {
        velocity.y = -velocity.y;
	}
    
    [self setPosition:point];
}



@end
