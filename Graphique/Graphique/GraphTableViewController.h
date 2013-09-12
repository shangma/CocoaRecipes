//
//  GraphTableViewController.h
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Equation.h"

@class GraphView;

@interface GraphTableViewController : NSViewController <NSTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *values;
@property (weak) IBOutlet NSTableView *graphTableView;
@property (nonatomic, assign) CGFloat interval;
@property (strong) IBOutlet GraphView *graphView;
@property (weak) IBOutlet NSTabView *tabView;

- (void) draw:(Equation *) equation;
- (NSBitmapImageRep *) exportAsImage;

@end
