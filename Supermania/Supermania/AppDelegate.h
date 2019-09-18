//
//  AppDelegate.h
//  Supermania
//
//  Created by Renato Resende on 4/29/11.
//  Copyright Avaya 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
