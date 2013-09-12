//
//  GraphView.h
//  Graphique
//
//  Created by Sagar Natekar on 8/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GraphTableViewController;

@interface GraphView : NSView

@property (assign) IBOutlet GraphTableViewController *controller;

@end
