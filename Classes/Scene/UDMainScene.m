//
//  UDMainScene.m
//  UDGame
//
//  Created by Rolandas Razma on 10/16/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "UDMainScene.h"
#import "UDLevelsScene.h"


@implementation UDMainScene


#pragma mark -
#pragma mark NSObject


- (id)init {
    if( (self = [super init]) ){
        UDMainLayer *layer = [UDMainLayer node];
        [self addChild:layer];
    }
    return self;
}


@end


@implementation UDMainLayer {

}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [super dealloc];
}


- (id)init {
	if( (self=[super init]) ) {
        [self setEnabled:YES];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        [bg setAnchorPoint:CGPointZero];
        [self addChild:bg];
        
        CCSprite *waves = [CCSprite spriteWithFile:@"waves.png"];
        [waves runAction: [CCRepeat actionWithAction:[CCSequence actions:
                                                       [CCMoveBy actionWithDuration:1 position:CGPointMake(-5, 5)],
                                                       [CCMoveBy actionWithDuration:1 position:CGPointMake(10, -10)],
                                                       [CCMoveBy actionWithDuration:1 position:CGPointMake(-5, 5)],
                                                       nil] times:999]];
        [waves setAnchorPoint:CGPointZero];
        [waves setPosition:CGPointZero];
        [self addChild:waves];
        
        
        CCSprite *playButton = [CCSprite spriteWithFile:@"play.png"];
        [playButton setPosition:CGPointMake(320 /2, 400)];
        [self addChild:playButton];
        
        CCSprite *multiButton = [CCSprite spriteWithFile:@"multi.png"];
        [multiButton setPosition:CGPointMake(320 /2, 330)];
        [self addChild:multiButton];
        
        CCSprite *helpButton = [CCSprite spriteWithFile:@"help.png"];
        [helpButton setPosition:CGPointMake(320 /2, 260)];
        [self addChild:helpButton];
        
    }
	return self;
}


#pragma mark -
#pragma mark UDLayer


- (BOOL)touchBeganAtLocation:(CGPoint)location {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration:0.8f scene:[UDLevelsScene node]]];
    return YES;
}


@end
