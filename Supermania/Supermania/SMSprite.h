//
//  SMSprite.h
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum{
    kEnemyDiretctionUp = -1,
    kEnemyDiretctionDown = 1
};


@interface SMSprite : CCSprite {
    CGPoint velocity;
    int drainEnergy;
}

@property(nonatomic) CGPoint velocity;
@property(nonatomic, readonly) float radius;
@property(nonatomic, readonly) CGRect rect;
@property(nonatomic)int drainEnergy;

- (BOOL)collideWithSprite:(CCSprite *)sprite;

@end
