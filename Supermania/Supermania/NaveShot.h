//
//  NaveShot.h
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSprite.h"


@interface NaveShot : SMSprite {
    CGPoint startPosition;
}

@property(nonatomic) CGPoint startPosition;

@end
