//
//  Enemy.m
//  Supermania
//
//  Created by Renato Resende on 4/29/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "Enemy.h"
#import "Globals.h"
#import "GameSoundManager.h"


@implementation Enemy

- (id)init {
    self = [super init];
    if (self) {
        drainEnergy = 30;
    }
    return self;
}

@synthesize shot;

- (void)makeShot:(ccTime)delta direction:(int)aDiretion
{
    float velocityY =  self.shot.position.y - self.shot.velocity.y * delta * aDiretion;
    
//    CGPoint position = ccp(self.position.x, velocityY);
    
    CGPoint position;
    
    if (shot.startPosition.y == 0 && shot.startPosition.x == 0){
        position = ccp(self.position.x, velocityY);
        [[self shot] setStartPosition:position];
        [[[GameSoundManager sharedManager] soundEngine]setEffectsVolume:.5];
        [[[GameSoundManager sharedManager] soundEngine] playEffect:@"enemy-shot.3gp"];
    }else{
        position = ccp(shot.startPosition.x, velocityY);
    }

    if (self.shot.position.y < MIN_LIMIT_Y){
        [[self shot] setPosition: self.position];
        [[self shot] setStartPosition:ccp(0, 0)];
    }else{
        [[self shot] setPosition: position];
    }
    
    [[self shot] setVisible:YES];
}

- (void)move:(ccTime)delta direction:(int)aDirection
{
    CGPoint point = self.position;
    
    point.x += velocity.x * delta * aDirection;
	point.y += velocity.y * delta * aDirection;
	
	if (point.x > MAX_LIMIT_X || point.x < MIN_LIMIT_X) {
		velocity.x = -velocity.x;
	}
	
	if (point.y > MAX_LIMIT_Y || point.y < MIN_LIMIT_Y) {
        velocity.y = -velocity.y;
	}
    
    [self setPosition:point];
    
}

@end
