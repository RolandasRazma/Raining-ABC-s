//
//  UDFallingLetter.h
//  UDGame
//
//  Created by Rolandas Razma on 10/16/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "cocos2d.h"


@interface UDLetter : CCSprite

@property (nonatomic, copy) NSString *letter;

+ (id)randomLetter;
- (id)initWithLetter:(NSString *)letter dropping:(BOOL)dropping;
- (void)removeLetter;

@end
