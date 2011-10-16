//
//  iOSX.h
//
//  Created by Rolandas Razma on 8/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//


#if defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
static NSString *NSStringFromCGPoint(CGPoint point){
    return [NSString stringWithFormat:@"{%g, %g}", point.x, point.y];
}

static NSString *NSStringFromCGRect(CGRect rect){
    return [NSString stringWithFormat:@"{{%g, %g}, {%g, %g}}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

#endif