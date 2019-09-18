//
//  EnemyShot.h
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SMSprite.h"


@interface EnemyShot : SMSprite {
    CGPoint startPosition;
}

@property(nonatomic) CGPoint startPosition;

- (void)setUpPosition:(CGPoint)position;

@end
