//
//  Nave.h
//  Supermania
//
//  Created by Renato Resende on 5/2/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSprite.h"
#import "NaveShot.h"

@interface Nave : SMSprite{
    NaveShot *shot;
}

@property(nonatomic, retain) NaveShot *shot;

- (void)makeShot:(ccTime)delta direction:(int)aDiretion;

- (void)setOriginalPositionForShot;


@end
