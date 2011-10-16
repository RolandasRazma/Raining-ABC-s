//
//  UDFallingLetter.m
//  UDGame
//
//  Created by Rolandas Razma on 10/16/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "UDLetter.h"
#import "UDMath.h"


@implementation UDLetter {
    NSString    *_letter;
    BOOL        _dropping;
    CCLabelTTF *_letterLabel;
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [_letter release];
    [super dealloc];
}


#pragma mark -
#pragma mark CCNode


- (void)onEnter {
    if( _dropping ){
        [self runAction: [CCSequence actions: 
                          [CCMoveTo actionWithDuration:4 position:CGPointMake(self.position.x, 35)], 
                          [CCCallFunc actionWithTarget:self selector:@selector(removeLetter)], nil]];
    }
    [super onEnter];
}


#pragma mark -
#pragma mark UDLetter


+ (id)randomLetter {
    NSArray *letters = [NSArray arrayWithObjects:@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"L", @"K", @"J", @"H", @"G", @"F", @"D", @"S", @"A", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", nil];
    return [[[self alloc] initWithLetter: [letters objectAtIndex:UDRand(0, letters.count -1)] dropping:NO] autorelease];
}


- (id)initWithLetter:(NSString *)letter dropping:(BOOL)dropping {
    if( (self = [super initWithFile:@"drop.png"]) ){
        _letter     = [letter copy];
        _dropping   = dropping;
        
        _letterLabel =  [CCLabelTTF labelWithString:_letter fontName:@"Marker Felt" fontSize:15];
        [_letterLabel setPosition:CGPointMake(self.textureRect.size.width /2, self.textureRect.size.height /2 -2)];
        [_letterLabel setColor:ccWHITE];
        [self addChild:_letterLabel];
    }
    return self;
}


- (void)removeLetter {
    
    CCSprite *splash = [CCSprite spriteWithFile:@"splash.png"];
    [splash setPosition:self.position];
    [splash runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1], [CCCallBlock actionWithBlock: ^{
        [splash removeFromParentAndCleanup:YES];
    }], nil]];
    [self.parent addChild:splash];
    
    [self stopAllActions];
    [self removeFromParentAndCleanup:YES];
    
}


- (void)setLetter:(NSString *)letter {
    [_letter release], _letter = [letter copy];
    [_letterLabel setString:_letter];
}


@synthesize letter=_letter;
@end
