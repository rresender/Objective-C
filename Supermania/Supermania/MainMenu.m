//
//  MainMenu.m
//  Supermania
//
//  Created by Renato Resende on 5/5/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

@implementation MainMenu

-(id) init
{
	if( (self=[super init])) {
        
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"background-menu.png"];

        background.position = ccp(screenSize.width/2, screenSize.height/2);
        
        [self addChild:background];

        
		[CCMenuItemFont setFontSize:30];
		[CCMenuItemFont setFontName: @"Arial"];
        
    
        CCSprite *spriteNormalPlay = [CCSprite spriteWithFile:@"button-play.png"];
        
        CCSprite *spriteSelectedPlay = [CCSprite spriteWithFile:@"button-play-sel.png"];
        
        CCMenuItemSprite *menuPlay = [CCMenuItemSprite itemFromNormalSprite:spriteNormalPlay 
                                                          selectedSprite:spriteSelectedPlay 
                                                          disabledSprite:nil 
                                                                  target:self 
                                                                selector:@selector(menuPlayCallback:)];        
        menuPlay.position = ccp(0, 100);
        
        
        CCSprite *spriteNormalOptions = [CCSprite spriteWithFile:@"button-options.png"];
        
        CCSprite *spriteSelectedOptions = [CCSprite spriteWithFile:@"button-options-sel.png"];
        
        CCMenuItem *menuOptions = [CCMenuItemSprite itemFromNormalSprite:spriteNormalOptions
                                                          selectedSprite:spriteSelectedOptions
                                                          disabledSprite:nil 
                                                                  target:self 
                                                                selector:nil];   
        
        menuOptions.position = ccp(0, -100); 

    
        
		
		CCMenu *menu = [CCMenu menuWithItems: menuPlay, menuOptions, nil];
        
		// elastic effect
		CGSize s = [[CCDirector sharedDirector] winSize];
		int i=0;
		for( CCNode *child in [menu children] ) {
			CGPoint dstPoint = child.position;
			int offset = s.width/2 + 50;
			if( i % 2 == 0)
				offset = -offset;
			child.position = ccp( dstPoint.x + offset, dstPoint.y);
			[child runAction: 
			 [CCEaseElasticOut actionWithAction:
			  [CCMoveBy actionWithDuration:2 position:ccp(dstPoint.x - offset,0)]
										 period: 0.35f]
             ];
			i++;
		}
        
        
		[self addChild: menu];
	}
    
	return self;
}

- (void)menuPlayCallback:(id)sender
{    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1 scene:[GameScene node:1]]];
    
}


@end
