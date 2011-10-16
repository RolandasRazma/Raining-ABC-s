//
//  UDMenuScene.m
//  UDGame
//
//  Created by Rolandas Razma on 8/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "UDGameScene.h"
#import "UDLetter.h"
#import "UDMath.h"
#import "UDLevelsScene.h"


@implementation UDGameScene


#pragma mark -
#pragma mark NSObject


- (id)init {
    if( (self = [super init]) ){
        UDGameLayer *layer = [UDGameLayer node];
        [self addChild:layer];
    }
    return self;
}


@end


@interface UDGameLayer (Private)

- (UDLetter *)letterOnPuddle:(CCSprite *)puddle;
- (void)newLetter;

@end


@implementation UDGameLayer {
    CCLabelTTF  *_label;
    CCSprite    *_thirdPuddle;
    CCSprite    *_secondPuddle;
    CCSprite    *_firstPuddle;
    
    CCSprite    *_firstCloud;
    CCSprite    *_secondCloud;
    CCSprite    *_thirdCloud;
    
    CCSprite    *_firstBoat;
    CCSprite    *_secondBoat;
    CCSprite    *_thirdBoat;
    
    NSTimer     *_rainTimer;
    
    NSMutableArray  *_letters;
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [_rainTimer invalidate];
    [super dealloc];
}


- (id)init {
	if( (self=[super init]) ) {
        [self setEnabled:YES];
        
        _letters = [[NSMutableArray alloc] initWithCapacity:20];
        for( NSUInteger c=0; c<100; c++ ){
            [_letters addObject:@"C"];
            [_letters addObject:@"A"];
            [_letters addObject:@"T"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"A"];
            [_letters addObject:@"E"];
            [_letters addObject:@"I"];
            [_letters addObject:@"L"];
            [_letters addObject:@"N"];
            [_letters addObject:@"O"];
            [_letters addObject:@"R"];
            [_letters addObject:@"S"];
            [_letters addObject:@"T"];
            [_letters addObject:@"U"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"D"];
            [_letters addObject:@"G"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"B"];
            [_letters addObject:@"C"];
            [_letters addObject:@"M"];
            [_letters addObject:@"P"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"F"];
            [_letters addObject:@"H"];
            [_letters addObject:@"V"];
            [_letters addObject:@"W"];
            [_letters addObject:@"Y"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"K"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"V"];
            [_letters addObject:@"X"];
        }
        for( NSUInteger c=0; c<1; c++ ){
            [_letters addObject:@"Q"];
            [_letters addObject:@"Z"];
        }
        

        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        [bg setAnchorPoint:CGPointZero];
        [self addChild:bg];
        
        CCSprite *firstPath = [CCSprite spriteWithFile:@"path.png"];
        [firstPath setPosition:CGPointMake(65, 250)];
        [self addChild:firstPath];
        
        CCSprite *secondPath = [CCSprite spriteWithFile:@"path.png"];
        [secondPath setPosition:CGPointMake(165, 250)];
        [self addChild:secondPath];
        
        CCSprite *thirdPath = [CCSprite spriteWithFile:@"path.png"];
        [thirdPath setPosition:CGPointMake(265, 250)];
        [self addChild:thirdPath];
        
        
        _firstCloud = [CCSprite spriteWithFile:@"cloud.png"];
        [_firstCloud setPosition:CGPointMake(65, 400)];
        [self addChild:_firstCloud z:10];

        _secondCloud = [CCSprite spriteWithFile:@"cloud.png"];
        [_secondCloud setPosition:CGPointMake(165, 400)];
        [self addChild:_secondCloud z:10];
        
        _thirdCloud = [CCSprite spriteWithFile:@"cloud.png"];
        [_thirdCloud setPosition:CGPointMake(265, 400)];
        [self addChild:_thirdCloud z:10];
        
        
        _firstPuddle = [CCSprite spriteWithFile:@"puddle.png"];
        [_firstPuddle setPosition:CGPointMake(65, 110)];
        [self addChild:_firstPuddle];
        

        _secondPuddle = [CCSprite spriteWithFile:@"puddle.png"];
        [_secondPuddle setPosition:CGPointMake(165, 110)];
        [self addChild:_secondPuddle];
        
        
        _thirdPuddle = [CCSprite spriteWithFile:@"puddle.png"];
        [_thirdPuddle setPosition:CGPointMake(265, 110)];
        [self addChild:_thirdPuddle];
        
        
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

	}
	return self;
}


#pragma mark -
#pragma mark CCNode


- (void)onEnterTransitionDidFinish {
    _rainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(newLetter) userInfo:nil repeats:YES];
}


- (void)onExit {
    [_rainTimer invalidate], _rainTimer = nil;
    [super onExit];
}


#pragma mark -
#pragma mark UDLayer


- (BOOL)touchBeganAtLocation:(CGPoint)location {
    UDLetter *letter    = nil;
    CCSprite *boatSprite= nil;
    
    if( CGRectContainsPoint(_firstPuddle.boundingBox, location) && (letter = [self letterOnPuddle:_firstPuddle]) ){
        boatSprite = _firstBoat;
        
        if( !_firstBoat ){
            _firstBoat = [CCSprite spriteWithFile:@"rowboat.png"];
            [_firstBoat setPosition:CGPointMake(320, 20)];
            [_firstBoat runAction:[CCSequence actions:
                                   [CCMoveTo actionWithDuration:3 position:CGPointMake(65, 20)], nil]];
            [self addChild:_firstBoat];
            
            UDLetter *boatLetter = [[UDLetter alloc] initWithLetter:letter.letter dropping:NO];
            [boatLetter setPosition:CGPointMake(25, 28)];
            [_firstBoat addChild:boatLetter];
            [boatLetter release];
        }
        
    }else if( CGRectContainsPoint(_secondPuddle.boundingBox, location) && (letter = [self letterOnPuddle:_secondPuddle]) ){        
        boatSprite = _secondBoat;
        
        if( !_secondBoat ){
            _secondBoat = [CCSprite spriteWithFile:@"rowboat.png"];
            [_secondBoat setPosition:CGPointMake(320, 20)];
            [_secondBoat runAction:[CCSequence actions:
                                    [CCMoveTo actionWithDuration:3 position:CGPointMake(165, 20)], nil]];
            [self addChild:_secondBoat];
            
            UDLetter *boatLetter = [[UDLetter alloc] initWithLetter:letter.letter dropping:NO];
            [boatLetter setPosition:CGPointMake(25, 28)];
            [_secondBoat addChild:boatLetter];
            [boatLetter release];
        }
        
    }else if( CGRectContainsPoint(_thirdPuddle.boundingBox, location) && (letter = [self letterOnPuddle:_thirdPuddle]) ){        
        boatSprite = _thirdBoat;
        
        if( !_thirdBoat ){
            _thirdBoat = [CCSprite spriteWithFile:@"rowboat.png"];
            [_thirdBoat setPosition:CGPointMake(320, 20)];
            [_thirdBoat runAction:[CCSequence actions:
                                   [CCMoveTo actionWithDuration:3 position:CGPointMake(265, 20)], nil]];
            [self addChild:_thirdBoat];
            
            UDLetter *boatLetter = [[UDLetter alloc] initWithLetter:letter.letter dropping:NO];
            [boatLetter setPosition:CGPointMake(25, 28)];
            [_thirdBoat addChild:boatLetter];
            [boatLetter release];
        }
        
    }
    
    if( letter ){
        if( boatSprite && letter ){
            // fast way - boat should be seperate object...
            UDLetter *boatLetter = [[boatSprite children] objectAtIndex:0];
            [boatLetter setLetter: letter.letter];
            [boatLetter stopAllActions];
            [boatLetter runAction:[CCSequence actions: [CCScaleTo actionWithDuration:0.3f scale:1.2f], [CCScaleTo actionWithDuration:0.3f scale:1.0f], nil]];
        }
        [letter removeLetter];
    }
    
    
    // Ok, this is not like it should be, we didn't had dictionary so its fast hack :)
    if(
            [[(UDLetter *)[[_firstBoat children]  objectAtIndex:0] letter] isEqualToString:@"C"]
       &&   [[(UDLetter *)[[_secondBoat children] objectAtIndex:0] letter] isEqualToString:@"A"]
       &&   [[(UDLetter *)[[_thirdBoat children]  objectAtIndex:0] letter] isEqualToString:@"T"]
    ){
        
        // Add rainbow
        CCSprite *rainbow = [CCSprite spriteWithFile:@"rainbow.png"];
        [rainbow setOpacity:0.0f];
        [rainbow runAction:[CCSequence actions:[CCFadeIn actionWithDuration:2.0f], [CCScaleTo actionWithDuration:2.0f scale:1.3f], nil]];
        [rainbow setPosition:CGPointMake(480/2, 320/2 -20)];
        [self addChild:rainbow];
        
        // Fade out clouds
        [_firstCloud runAction:  [CCFadeTo actionWithDuration:1  opacity:80]];
        [_firstCloud runAction:  [CCScaleTo actionWithDuration:1 scale:0.7f]];
        
        [_secondCloud runAction: [CCFadeTo actionWithDuration:1 opacity:80]];
        [_secondCloud runAction: [CCScaleTo actionWithDuration:1 scale:0.7f]];
        
        [_thirdCloud runAction:  [CCFadeTo actionWithDuration:1  opacity:80]];
        [_thirdCloud runAction:  [CCScaleTo actionWithDuration:1 scale:0.7f]];
        
        [_rainTimer invalidate], _rainTimer = nil;
        
        // End game
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:4], [CCCallBlock actionWithBlock: ^{
            [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInL transitionWithDuration:0.8f scene:[UDLevelsScene node]]];
        }], nil]];
    }
    
    return YES;
}


#pragma mark -
#pragma mark UDGameLayer


- (void)newLetter {

    UDLetter *letterLabel = [[UDLetter alloc] initWithLetter: [_letters objectAtIndex:UDRand(0, _letters.count -1)] dropping:YES];
    
    // Put letter on track
    switch ( UDRand(0, 2) ) {
        case 0: {
            [letterLabel setPosition:CGPointMake(65, 380)];
            break;
        }
        case 1: {
            [letterLabel setPosition:CGPointMake(165, 380)];
            break;
        }
        case 2: {
            [letterLabel setPosition:CGPointMake(265, 380)];
            break;
        }
    }

    // Some fast randomization
    if( UDTrueWithPossibility(0.5f) ){
        [letterLabel setScale:1.1f];
    }else if( UDTrueWithPossibility(0.3f) ){
        [letterLabel setScale:1.05f];
    }
    
    [self addChild:letterLabel];
    [letterLabel release];
}


- (UDLetter *)letterOnPuddle:(CCSprite *)puddle {
    
    for( UDLetter *sprite in self.children ){
        if( [sprite isKindOfClass:[UDLetter class]] ){
            if( CGRectIntersectsRect(sprite.boundingBox, puddle.boundingBox) ){
                return sprite;
            }
        }
    }
    
    return nil;
}


@end
