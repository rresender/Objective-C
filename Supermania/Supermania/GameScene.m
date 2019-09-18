//
//  GameScene.m
//  Supermania
//
//  Created by Renato Resende on 4/29/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import "GameScene.h"
#import "Enemy.h"
#import "Globals.h"
#import "Nave.h"
#import "NaveShot.h"
#import "MainMenu.h"
#import "Background.h"
#import "Energy.h"
#import "GameSoundManager.h"

CGPoint randomPoint() {
    
    float y = random() % 390;
    
    if(y < MIN_LIMIT_Y)
        y = MIN_LIMIT_Y; 
    
    if(y > MAX_LIMIT_Y)
        y = MAX_LIMIT_Y; 
    
    float x = random() % 256;
    
    if(x < MIN_LIMIT_X)
        x = MIN_LIMIT_X; 
    
    if(x > MAX_LIMIT_X)
        x = MAX_LIMIT_X; 
    
    
    return CGPointMake(x, y);
}

@implementation GameScene

@synthesize emitter = emitter_, fase;

SimpleAudioEngine *soundEngine;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

+(id) node:(int)aFase
{
	return [[[self alloc] init:aFase] autorelease];
}

- (id)init:(int)aFase
{	
    if( (self=[super init])) {
        
        fase = aFase;
                
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
        
        [self setupBackgroung];
        
        [self setupLifeEnergy];
        
        [self setupLives];
        
        [self setupNave];
        
        [self setupEnemies];
        
        [self setupScore];
    
		[self schedule: @selector(tick:)];
        
        soundEngine = [GameSoundManager sharedManager].soundEngine;
	}
	return self;
}

- (void)setupBackgroung
{
    Background *background = [Background spriteWithFile:[NSString stringWithFormat:@"background-%d.png", fase]];
    background.position = ccp(SCREEN_SIZE_WIDTH/2, SCREEN_SIZE_HEIGHT/2);
    background.velocity = CGPointMake(20.0f, -50.0f);
    [self addChild:background z:0 tag:BACKGROUND_TAG];
}

- (void)setupLifeEnergy
{
    Energy *energy = [Energy spriteWithFile:ENERGY_IMAGE];
    energy.position = ccp(SCREEN_SIZE_WIDTH/2, SCREEN_SIZE_HEIGHT-12);    
    [self addChild:energy z:0 tag:ENERGY_TAG];
}

- (void)setupLives
{
    int initLifePositioX = 305;
    int initLifePositioY = 468;
    
    for (int idx = 0; idx < MAX_LIFES; idx++) {
        CCSprite *life = [CCSprite spriteWithFile:NAVE_IMAGE rect:CGRectMake(21, 0 , 20, 30)];
        life.scale = .6;
        life.position = ccp(initLifePositioX, initLifePositioY);
        [self addChild:life z:0 tag:LIFE_TAG + idx];
        initLifePositioX -= 12;
    }
    
    lifeCount = MAX_LIFES;
}

- (void)setupNave
{
    Nave *nave = [Nave spriteWithFile:NAVE_IMAGE rect:CGRectMake(21, 0 , 20, 30)];
    
    nave.tag = NAVE_TAG;
    
    nave.position = ccp(SCREEN_SIZE_WIDTH/2, MIN_LIMIT_Y);
    
    nave.scale = 1.2;
    
    [self addChild:nave z:0 tag:nave.tag];
    
    [nave setOriginalPositionForShot];
    
    [[nave shot] setRotation: -90];
    
    [[nave shot] setVisible:NO];
    
    [self addChild:[nave shot] z:1 tag:nave.shot.tag];
}

- (void)setupEnemies
{
    enemyHitCount = 0;
    
    Enemy *enemy;
    EnemyShot *enemyShot;
    
    int x1 = 40;
    int x2 = x1+15;
    int x3 = x1;
    
    
//    CCSpriteBatchNode *node =[CCSpriteBatchNode batchNodeWithTexture:[enemy texture] capacity: MAX_ENEMIES];
    
    
    for (int idx = 0; idx < MAX_ENEMIES; idx++) {
        
        enemy = [Enemy spriteWithFile:[NSString stringWithFormat:@"enemy-%d.png", fase] rect:CGRectMake(0, 0 , 20, 30)];
        
        enemyShot = [EnemyShot spriteWithFile: [NSString stringWithFormat:@"enemy-shot-%d.png", fase]];
        
        if(fase == 2)
            enemy.scale = 1.5;
        
        enemy.tag = ENEMY_TAG + idx;
        
        enemy.velocity = CGPointMake(20.0f, -100.0f);
        
        if(idx < 9)
        {
            enemy.position = ccp(x1, 800);
            x1 += 30;
        }
        else if(idx < 17)
        {
            enemy.position = ccp(x2, 770);
            x2 += 30;
        }
        else
        {
            enemy.position = ccp(x3, 740);
            x3 += 30;
        }
        
        enemyShot.tag = ENEMY_SHOT_TAG + idx;
        
        enemyShot.velocity = CGPointMake(20.0f, 250.0);
        
        enemyShot.position = enemy.position;
        
        [enemyShot setVisible: NO];
        
        [enemy setShot:enemyShot];
        
        [self addChild:enemy z:1 tag:enemy.tag];
        
        [self addChild:enemyShot z:1 tag:enemyShot.tag];
    }   
}

- (void)setupScore
{
    score = 0;
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", score] fontName:@"Thonburi" fontSize:14];
    
    [scoreLabel setPosition: ccp(5, 460)];
    
    [scoreLabel setAnchorPoint:ccp(0, 0)];
    
    [self addChild: scoreLabel z:0 tag:SCORE_LABEL_TAG];   
}

- (void) onEnter
{
	[super onEnter];
    
    Nave *nave = (Nave*)[self getChildByTag:NAVE_TAG];
    
    [nave runAction:[CCBlink actionWithDuration:1.5f blinks:10]];
    
    Enemy *enemy;
    
    for (int idx = 0; idx < MAX_ENEMIES; idx++) {
        
        int aTag = ENEMY_TAG + idx;
        
        enemy = [(Enemy *)[self getChildByTag:aTag] retain];
        
        if(enemy == NULL)
            continue;
        
    
        CCSequence *action = [CCSequence actions:
                    [CCMoveTo actionWithDuration:1  position:ccp(enemy.position.x, enemy.position.y - 400)],
                    [CCDelayTime actionWithDuration:1],
                    [CCCallFuncN actionWithTarget:self selector:@selector(startMakeShot:)], 
                     nil];
        
        [enemy runAction:action];
        
        [self setupEnemiesMoviment];
        
    }
    
    
    soundEngine.backgroundMusicVolume = 1.0f;
    [soundEngine rewindBackgroundMusic];
    [soundEngine playBackgroundMusic:@"background-song.3gp"];

}

- (void)setupEnemiesMoviment
{
    
//    switch (fase) {
//        case 1:
//        {
//            
//            break;
//        }
//        case 2:
//        {
//            Enemy *enemy;
//            
//            for (int idx = 0; idx < MAX_ENEMIES; idx++) {
//                
//                int aTag = ENEMY_TAG + idx;
//                
//                enemy = [(Enemy *)[self getChildByTag:aTag] retain];
//                
//                if(enemy == NULL)
//                    continue;
//                CCAnimation* animation = [CCAnimation animation];
//                
//                CCTexture2D* tx = [[[CCTexture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"enemy-%d.png", fase]]] autorelease];
//                
//                [animation addFrameWithTexture:tx rect:CGRectMake(20, 0 , 20, 30)];
//                [animation addFrameWithTexture:tx rect:CGRectMake(0, 0 , 20, 30)];
//                
//                id action2 = [CCAnimate actionWithDuration:.3 animation:animation restoreOriginalFrame:NO];
//                
//                id action_back = [action2 reverse];
//                
//                [enemy runAction: [CCRepeatForever actionWithAction:[CCSequence actions: action2, action_back, nil]]];
//                
//            }
//            
//            break;    
//        }   
//            
//        default:
//            break;
//    }
    
}

- (void) startMakeShot:(id)sender
{
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Mission %d", fase] fontName:@"Trebuchet MS" fontSize:24];
    
    label.position = ccp(0, SCREEN_SIZE_HEIGHT/2);
    
    id action = [CCSequence actions:[CCMoveTo actionWithDuration:1 position:ccp(SCREEN_SIZE_WIDTH/2, SCREEN_SIZE_HEIGHT/2)], 
                 [CCDelayTime actionWithDuration:1],
                 [CCCallFuncN actionWithTarget:self selector:@selector(menuGameStartCallback:)], 
                 nil];
    
    [label runAction:action];
    [label runAction:[CCTintTo actionWithDuration:1 red:255 green:255 blue:0]];
    
    [self addChild:label z:0 tag:LABEL_START_GAME_TAG];
    
    Enemy *enemy;
    
    for (int idx = 0; idx < MAX_ENEMIES; idx++) {
        
        int aTag = ENEMY_TAG + idx;
        
        enemy = [(Enemy *)[self getChildByTag:aTag] retain];
        
        if(enemy == NULL)
            continue;
        
        
        EnemyShot *enemyShot = [[self getChildByTag:enemy.shot.tag] retain];
        
        if(enemyShot == NULL)
            continue;
        
        enemyShot.position = enemy.position;
        
        if(fase == 2){
            id moveTo = [CCMoveTo actionWithDuration:1 position:ccp(enemy.position.x + 10, enemy.position.y)];
            id moveBack = [CCMoveTo actionWithDuration:1 position:ccp(enemy.position.x - 10, enemy.position.y)];
            
            CCAnimation* animation = [CCAnimation animation];
            
            CCTexture2D* tx = [[[CCTexture2D alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"enemy-%d.png", fase]]] autorelease];
            
            [animation addFrameWithTexture:tx rect:CGRectMake(20, 0 , 20, 30)];
            [animation addFrameWithTexture:tx rect:CGRectMake(0, 0 , 20, 30)];
            
            id action2 = [CCAnimate actionWithDuration:.3 animation:animation restoreOriginalFrame:NO];
            
            id action_back = [action2 reverse];
            
            [enemy runAction:[CCRepeatForever actionWithAction:[CCSequence actions:action2, action_back, nil]]];
            
            [enemy runAction:[CCRepeatForever actionWithAction:[CCSequence actions: moveTo, moveBack, nil]]];
            
            [enemyShot runAction:[CCTintTo actionWithDuration:1 red:0 green:255 blue:0]];
        }
        
    }
}

-(void)menuGameStartCallback:(id)sender
{
    startGame = YES;
    [self removeChildByTag:LABEL_START_GAME_TAG cleanup:YES];
}

-(void) setEmitterPosition
{
	if( CGPointEqualToPoint( emitter_.sourcePosition, CGPointZero ) ) 
		emitter_.position = ccp(200, 70);
}  

-(void) draw
{
    
}

-(void) tick: (ccTime) dt
{
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    Nave *nave = (Nave*)[self getChildByTag:NAVE_TAG];
    
    if(startGame == YES)
        [nave makeShot:dt direction:kEnemyDiretctionUp];    
    
    BOOL naveHit  = NO;
    
    Energy *energy = (Energy *)[self getChildByTag:ENERGY_TAG];
    
    int energyValue = 1;
       
    Enemy *enemy;
    
    for (int idx = 0; idx < MAX_ENEMIES; idx++) {
        
        int aTag = ENEMY_TAG + idx;
        
        enemy = [(Enemy *)[self getChildByTag:aTag] retain];
        
        if(enemy == NULL)
            continue;
        
        EnemyShot *enemyShot = [[self getChildByTag:enemy.shot.tag] retain];
        
        if(enemyShot == NULL)
            continue;
        
        BOOL enemyHit = NO;
        
        if(startGame == YES)
            [enemy makeShot:dt direction:kEnemyDiretctionDown];
        
        if([nave.shot collideWithSprite:enemyShot] == YES){
            
            self.emitter = [CCParticleGalaxy node];
            self.emitter.totalParticles = 10;
            self.emitter.duration = .5;
            self.emitter.life = .5;
            self.emitter.lifeVar = .1;
            self.emitter.autoRemoveOnFinish = YES;
            self.emitter.position = nave.shot.position;
            
            [self addChild:self.emitter];
            
            [nave setOriginalPositionForShot];
            
            [enemyShot setUpPosition: enemy.position];
            
            score += POINT_VALUE_FOR_SHOT;
            
            enemyHit = YES;
            
        }else if([enemy collideWithSprite:nave.shot] == YES){
            
            [[[GameSoundManager sharedManager] soundEngine]setEffectsVolume:1.5];
            [[[GameSoundManager sharedManager] soundEngine] playEffect:@"enemy-explode.3gp"];
            
            score += POINT_VALUE_FOR_ENEMY;
            
            self.emitter = [CCParticleExplosion node];
            
            self.emitter.totalParticles = 5;
            self.emitter.duration = .1;
            self.emitter.life = .1;
            self.emitter.lifeVar = 1;
            self.emitter.emitterMode = kCCParticleModeGravity;
            
            ccColor4F startColor = {0.6f, 1.0f, 0.0f, 1.0f};
            self.emitter.startColor = startColor;
            
            ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
            self.emitter.startColorVar = startColorVar;
            
            ccColor4F endColor = {0.0f, 0.0f, 0.0f, 1.0f};
            self.emitter.endColor = endColor;
            
            ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};	
            self.emitter.endColorVar = endColorVar;
            
            self.emitter.autoRemoveOnFinish = YES;
            
            if( CGPointEqualToPoint(self.emitter.sourcePosition, CGPointZero ) ) 
                self.emitter.position = enemy.position;
            
            [self addChild:self.emitter];
            
            enemyHit = YES;
                
            [self removeChild:enemy cleanup:NO];
            [self removeChild:enemyShot cleanup:NO];
            
            ++enemyHitCount;
            
            [nave setOriginalPositionForShot];
            
        }
        
        if ([enemyShot collideWithSprite:nave]) {
            energyValue = [energy drain:enemyShot.drainEnergy];
            [enemyShot setUpPosition: enemy.position];
            naveHit = YES;
        }
        
        if ([enemy collideWithSprite:nave]) {
            energyValue = [energy drain:enemy.drainEnergy];
            naveHit = YES;
        }
        
        if(naveHit == YES){
            
            [[[GameSoundManager sharedManager] soundEngine]setEffectsVolume:1.5];
            [[[GameSoundManager sharedManager] soundEngine] playEffect:@"nave-hit.3gp"];
            
            self.emitter = [CCParticleFire node];
            self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
            self.emitter.totalParticles = 5;
            self.emitter.duration = .1;
            self.emitter.life = .1;
            self.emitter.lifeVar = 1;
            self.emitter.emitterMode = kCCParticleModeGravity;
            self.emitter.position = nave.position;
            self.emitter.autoRemoveOnFinish = YES;
            
            [self addChild:self.emitter z:10];
        }
        
       
        if(enemyHit == YES){
            CCLabelTTF *scoreLabel = (CCLabelTTF *)[self getChildByTag:SCORE_LABEL_TAG];
            [scoreLabel setString:[NSString stringWithFormat:@"Score: %d", score]];
        }
        
        [enemy release];
        [enemyShot release];
    
    }
    
    if(energyValue <= 0){
        
        [[[GameSoundManager sharedManager] soundEngine]setEffectsVolume:1.5];
        [[[GameSoundManager sharedManager] soundEngine] playEffect:@"nave-explode.3gp"];
        
        int aLifeCount = --lifeCount;
        CCSprite *life = (CCSprite *)[[self getChildByTag:LIFE_TAG+aLifeCount] retain];
        [self removeChild:life cleanup:YES];
        self.emitter = [CCParticleSystemQuad particleWithFile:@"ExplodingRing.plist"];
        self.emitter.position = nave.position;
        self.emitter.duration = .5;
        [self addChild: self.emitter z:0];
        
        nave.position = ccp(screenSize.width/2, MIN_LIMIT_Y);
        [nave runAction:[CCBlink actionWithDuration:1.5f blinks:10]];
        [life release];
        [energy renew];
    }
    
    if((enemyHitCount == MAX_ENEMIES || lifeCount == 0) && gameOver == NO){
        
        gameOver = YES;
        
        [self removeChildByTag:NAVE_TAG cleanup:YES];
        [self removeChildByTag:NAVE_SHOT_TAG cleanup:YES];
        
        for (int idx = 0; idx < MAX_ENEMIES; idx++) {
            
            int aTag = ENEMY_TAG + idx;
            
            enemy = [(Enemy *)[self getChildByTag:aTag] retain];
            
            if(enemy == NULL)
                continue;
            
            EnemyShot *enemyShot = [[self getChildByTag:enemy.shot.tag] retain];
            
            if(enemyShot == NULL)
                continue;

            [self removeChild:enemy cleanup:NO];
            [self removeChild:enemyShot cleanup:NO];
            
        }
        
        [soundEngine stopBackgroundMusic];
        
        [CCMenuItemFont setFontSize:30 ];
        [CCMenuItemFont setFontName: @"Trebuchet MS"];
        
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString: @"--> Main Menu" target:self selector:@selector(menuGameOverCallback:)];
        
        item1.position = ccp(SCREEN_SIZE_WIDTH/2, SCREEN_SIZE_HEIGHT/2 +50);
        
        CCMenuItemFont *item2 = [CCMenuItemFont itemFromString: @"--> Next Level" target:self selector:@selector(menuGameNextLevelCallback:)];
        
        item2.position = ccp(SCREEN_SIZE_WIDTH/2, SCREEN_SIZE_HEIGHT/2 -50);
        
        id spin1 = [CCRotateBy actionWithDuration:1 angle:-360];
        id spin2 = [spin1 reverse];
        
        [item1 runAction: spin1];
        
        [item2 runAction: spin2];
        
        CCMenu *menu = [CCMenu menuWithItems: item1, item2, nil];	
        
		menu.position = ccp(0,0);
        
        [self addChild: menu];
        
    }
    
    if(gameOver == NO){
        Background *background = (Background*)[self getChildByTag:BACKGROUND_TAG];        
        [background move:dt direction:kEnemyDiretctionUp];
        [self stopAllActions];
    }
        
    
}

- (void)menuGameOverCallback:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionRadialCCW transitionWithDuration:1 scene:[MainMenu node]]];
}

- (void)menuGameNextLevelCallback:(id)sender
{
    if(fase == 3)
        fase = 1;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1 scene:[GameScene node:2]]];
}

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCNode *node = [self getChildByTag:NAVE_TAG];
    CCSprite *sprite = (CCSprite *)node;
    [sprite setTextureRect:CGRectMake(21, 0 , 20 , 30)];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
    
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];
	
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
	CGPoint diff = ccpSub(touchLocation,prevLocation);
	
	CCNode *node = [self getChildByTag:NAVE_TAG];
    
    CGPoint currentPos = [node position];
    
    BOOL changed = false;
        
    if (currentPos.x < MIN_LIMIT_X){
        [node setPosition: CGPointMake(MIN_LIMIT_X, currentPos.y)];
        changed = true;
    }
    
    if (currentPos.y < MIN_LIMIT_Y){
        [node setPosition: CGPointMake(currentPos.x, MIN_LIMIT_Y)];
        changed = true;
    }
    
    if (currentPos.x > MAX_LIMIT_X){
        [node setPosition: CGPointMake(MAX_LIMIT_X, currentPos.y)];
        changed = true;
    }
    
    if (currentPos.y > MAX_LIMIT_Y){
        [node setPosition: CGPointMake(currentPos.x, MAX_LIMIT_Y)];
        changed = true;
    }
    
    if(!changed){
        [node setPosition: ccpAdd(currentPos, diff)];
        changed = true;
    }

    CCSprite *sprite = (CCSprite *)node;
    
    if(touchLocation.x < prevLocation.x)
        [sprite setTextureRect:CGRectMake(41, 0 , 21, 30)];
    else if(touchLocation.x > prevLocation.x)
        [sprite setTextureRect:CGRectMake(0, 0 , 20, 30)];
    else
        [sprite setTextureRect:CGRectMake(21, 0 , 20 , 30)];
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    
}

@end

