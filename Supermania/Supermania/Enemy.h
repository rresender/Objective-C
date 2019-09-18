//
//  Enemy.h
//  Supermania
//
//  Created by Renato Resende on 4/29/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSprite.h"
#import "EnemyShot.h"

@interface Enemy : SMSprite {
    EnemyShot *shot;
}

@property(nonatomic, assign) EnemyShot *shot;

- (void)move:(ccTime)delta direction:(int)aDirection;

- (void)makeShot:(ccTime)delta direction:(int)aDiretion;

@end
