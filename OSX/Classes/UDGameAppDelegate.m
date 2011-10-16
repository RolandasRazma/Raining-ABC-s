//
//  UDGameAppDelegate.m
//  UDGame
//
//  Created by Rolandas Razma on 8/12/11.
//  Copyright UD7 2011. All rights reserved.
//

#import "UDGameAppDelegate.h"
#import "UDMainScene.h"
#import "cocos2d.h"


@implementation UDGameAppDelegate {
	IBOutlet NSWindow	*window_;
	IBOutlet MacGLView	*glView_;
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window_ release];
	[super dealloc];
}


#pragma mark -
#pragma mark NSApplication


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:NO];
	
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	//[director setDisplayFPS:YES];
	
	[director setOpenGLView:glView_];

	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	// Use kCCDirectorResize_NoScale if you don't want auto-scaling.
	[director setResizeMode:kCCDirectorResize_AutoScale];
	[director runWithScene: [UDMainScene node]];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}


#pragma mark -
#pragma mark UDGameAppDelegate


- (IBAction)toggleFullScreen: (id)sender {
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}


@end
