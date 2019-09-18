//
//  Nave.m
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "Nave.h"
#import "Globals.h"
#import "GameSoundManager.h"

@implementation Nave

@synthesize shot;


- (id)init {
    self = [super init];
    if (self) {
        NaveShot *aShot = [NaveShot spriteWithFile:@"nave-shot.png"];
        [aShot setVelocity:CGPointMake(20.0f, 1000.0f)];
        [aShot setTag:NAVE_SHOT_TAG];
        [self setShot:aShot];
        [aShot release];
    }
    return self;
}

//- (CGRect)rect
//{
//    //	CGSize s = [texture_ contentSize];
//    CGSize s = self.textureRect.size;
//	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
//}


- (void)makeShot:(ccTime)delta direction:(int)aDiretion
{
    if(!shot.visible)
        shot.visible = YES;
    
    float velocityY =  (self.shot.position.y - (self.shot.velocity.y * aDiretion * delta));
    
    CGPoint position;
    
    if (shot.startPosition.y == 0 && shot.startPosition.x == 0){
        position = ccp(self.position.x, velocityY);
        [[self shot] setStartPosition:position];
        [[[GameSoundManager sharedManager] soundEngine]setEffectsVolume:.8];
        [[[GameSoundManager sharedManager] soundEngine] playEffect:@"nave-shot.3gp"];
    }else{
        position = ccp(self.position.x, velocityY);
    }
    
    if (self.shot.position.y < MIN_LIMIT_Y || self.shot.position.y > MAX_LIMIT_Y){
        [self setOriginalPositionForShot];
        [[self shot] setStartPosition:ccp(0, 0)];
    }else { 
        [[self shot] setPosition: position];
    }
}

- (void)setOriginalPositionForShot
{
    [[self shot] setPosition: ccp(self.position.x, self.position.y + 15)];
}

- (void)dealloc {
    [super dealloc];
}

@end
