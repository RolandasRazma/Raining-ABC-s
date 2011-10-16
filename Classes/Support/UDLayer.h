//
//  UDLayer.h
//
//  Created by Rolandas Razma on 8/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "CCLayer.h"


@interface UDLayer : CCLayer

@property(nonatomic, getter=isEnabled) BOOL enabled;

- (BOOL)touchBeganAtLocation:(CGPoint)location;
- (void)touchMovedToLocation:(CGPoint)location;
- (void)touchEndedAtLocation:(CGPoint)location;

@end
