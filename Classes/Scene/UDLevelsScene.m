//
//  UDLevelsScene.m
//  UDGame
//
//  Created by Rolandas Razma on 8/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "UDLevelsScene.h"
#import "UDGameScene.h"


@implementation UDLevelsScene


#pragma mark -
#pragma mark NSObject


- (id)init {
    if( (self = [super init]) ){
        UDLevelsLayer *layer = [UDLevelsLayer node];
        [self addChild:layer];
    }
    return self;
}


@end


@implementation UDLevelsLayer {

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

        
        CCLabelTTF *_rounds =  [CCLabelTTF labelWithString:@"Rounds" fontName:@"Marker Felt" fontSize:32];
        [_rounds setPosition:CGPointMake(320/2, 450)];
        [_rounds setColor:ccBLACK];
        [self addChild:_rounds];
        

        // movingWaves
        CCSprite *movingWaves = [CCSprite spriteWithFile:@"waves.png"];
        [movingWaves runAction: [CCRepeat actionWithAction:[CCSequence actions:
                                                       [CCMoveBy actionWithDuration:1 position:CGPointMake(-5, 5)],
                                                       [CCMoveBy actionWithDuration:1 position:CGPointMake(10, -10)],
                                                       [CCMoveBy actionWithDuration:1 position:CGPointMake(-5, 5)],
                                                       nil] times:999]];
        [movingWaves setAnchorPoint:CGPointZero];
        [movingWaves setPosition:CGPointZero];
        [self addChild:movingWaves];

        
        // Add levels
        CGFloat top = 380;
        for( NSUInteger level = 0; level<4; level++ ){
            
            CCSprite *cloud = [CCSprite spriteWithFile:@"cloud.png"];
            [cloud setPosition:CGPointMake((level%2?210:100), top)];
            [self addChild:cloud];
            
            CCLabelTTF *cloudLabel =  [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%u", level +1] fontName:@"Marker Felt" fontSize:32];
            [cloudLabel setColor:ccBLACK];
            [cloudLabel setPosition:CGPointMake(cloud.textureRect.size.width /2, cloud.textureRect.size.height /2 -2)];
            [cloud addChild:cloudLabel];
            
            if( level %2 ) top -= 100;
        }
    }
	return self;
}


#pragma mark -
#pragma mark UDLayer


- (BOOL)touchBeganAtLocation:(CGPoint)location {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration:0.8f scene:[UDGameScene node]]];
    return YES;
}


@end
