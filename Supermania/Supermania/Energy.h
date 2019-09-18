//
//  Energy.h
//  Supermania
//
//  Created by Renato Resende on 5/6/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSprite.h"


@interface Energy : SMSprite{
    id blink;
    BOOL actionStarted;
}

- (int)drain:(int)value;
- (void)renew;

@end
