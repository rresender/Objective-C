//
//  Energy.m
//  Supermania
//
//  Created by Renato Resende on 5/6/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "Energy.h"


@implementation Energy

- (int)drain:(int)value
{
    CGRect rect = self.textureRect;
    
    [self setTextureRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - value,rect.size.height)];
    
    
    if (rect.size.width < 30 && actionStarted == NO) {
        actionStarted = YES;
        blink = [CCRepeatForever actionWithAction:[CCBlink actionWithDuration:3 blinks:5]];
        [self runAction:blink];
    }
    
    self.position = ccp(self.position.x-(value/2), self.position.y);
    
    return self.textureRect.size.width;
}

- (void)renew
{
    CGSize s = [texture_ contentSize];
    CGRect rect = self.textureRect;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.position = ccp(screenSize.width/2, 468);
    
    [self setTextureRect:CGRectMake(rect.origin.x, rect.origin.y, s.width, s.height)];
    
    CCRepeatForever * action = blink;
    
    [action stop];
    
    actionStarted = NO;
    
    self.visible = YES;

}

@end
