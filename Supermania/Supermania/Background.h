//
//  Background.h
//  Supermania
//
//  Created by Renato Resende on 5/5/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSprite.h"


@interface Background : SMSprite {
    
}

- (void)move:(ccTime)delta direction:(int)aDirection;

@end
