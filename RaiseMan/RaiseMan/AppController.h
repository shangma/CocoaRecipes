//
//  AppController.h
//  RaiseMan
//
//  Created by Sagar Natekar on 8/12/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreferenceController;

@interface AppController : NSObject <NSApplicationDelegate>
{
    PreferenceController *preferenceController;
}

- (IBAction)showPreferencePanel:(id)sender;

@end
