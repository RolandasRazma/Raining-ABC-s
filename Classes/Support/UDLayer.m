//
//  UDLayer.m
//
//  Created by Rolandas Razma on 8/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "UDLayer.h"
#import "cocos2d.h"


@implementation UDLayer {
    BOOL _touchActive;
}


- (void)setEnabled:(BOOL)enabled {
    if( [self isEnabled] == enabled ) return;
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [self setIsTouchEnabled: enabled];
    if( isRunning_ ){
        if( enabled ){
            [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        }else{
            [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
        }
    }
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    [self setIsMouseEnabled: enabled];
#endif
}


- (BOOL)isEnabled {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    return [self isTouchEnabled];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    return [self isMouseEnabled];
#endif
    return NO;
}


- (BOOL)touchBeganAtLocation:(CGPoint)location {
    // Overwrite me
    return NO;
}
    

- (void)touchMovedToLocation:(CGPoint)location {
    // Overwrite me
}


- (void)touchEndedAtLocation:(CGPoint)location {
    // Overwrite me
}


#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED


- (void)onEnter {
    if( [self isEnabled] ){
                    NSLog(@"addTargetedDelegate");
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self
                                                         priority: 0
                                                  swallowsTouches: YES];
    }
    [super onEnter];
}


- (void)onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if( !visible_ ) return NO;
	
	for( CCNode *c = self.parent; c != nil; c = c.parent ){
		if( c.visible == NO ) return NO;
    }

    _touchActive = [self touchBeganAtLocation: [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]]];
    return _touchActive;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self touchMovedToLocation: [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]]];
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self touchEndedAtLocation: [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]]];
}


#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)


- (BOOL)ccMouseDown:(NSEvent *)event {
    if( !visible_ ) return NO;
    _touchActive = [self touchBeganAtLocation: [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event]];
    return _touchActive;
}


- (BOOL)ccMouseDragged:(NSEvent *)event {
    if( !visible_ || !_touchActive ) return NO;
    [self touchMovedToLocation: [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event]];
    return YES;
}


- (BOOL)ccMouseUp:(NSEvent *)event {
    if( !visible_ || !_touchActive ) return NO;
    [self touchEndedAtLocation: [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event]];
    _touchActive = NO;
    return YES;
}


#endif


@end
