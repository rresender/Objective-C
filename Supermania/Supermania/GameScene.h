//
//  GameScene.h
//  Supermania
//
//  Created by Renato Resende on 4/29/11.
//  Copyright 2011 Avaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCLayer {

	CCParticleSystem *emitter_;
    
    int score;
    int enemyHitCount;
    int lifeCount;
    int fase;
    
    BOOL gameOver;
    BOOL startGame;
}

@property (readwrite,retain) CCParticleSystem *emitter;
@property int fase;

+(id) node:(int)aFase;

+(CCScene *) scene;

- (void)setEmitterPosition;

- (void)setupBackgroung;

- (void)setupLifeEnergy;

- (void)setupLives;

- (void)setupNave;

- (void)setupEnemies;

- (void)setupScore;

- (void)setupEnemiesMoviment;

@end
