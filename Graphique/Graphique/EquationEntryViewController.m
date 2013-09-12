//
//  EquationEntryViewController.m
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "EquationEntryViewController.h"
#import "GraphiqueAppDelegate.h"
#import "Equation.h"
#import "GraphTableViewController.h"
#import "EquationToken.h"
#import "RecentlyUsedEquationsViewController.h"

static NSDictionary *COLORS;

@interface EquationEntryViewController ()

@end

@implementation EquationEntryViewController

@synthesize feedback;

+ (void)initialize
{
    COLORS = [NSDictionary dictionaryWithObjectsAndKeys:
              [NSColor whiteColor], [NSNumber numberWithInt:EquationTokenTypeInvalid],
              [NSColor blackColor], [NSNumber numberWithInt:EquationTokenTypeNumber],
              [NSColor blueColor], [NSNumber numberWithInt:EquationTokenTypeVariable],
              [NSColor brownColor], [NSNumber numberWithInt:EquationTokenTypeOperator],
              [NSColor purpleColor], [NSNumber numberWithInt:EquationTokenTypeOpenParen],
              [NSColor purpleColor], [NSNumber numberWithInt:EquationTokenTypeCloseParen],
              [NSColor orangeColor], [NSNumber numberWithInt:EquationTokenTypeExponent],
              [NSColor cyanColor], [NSNumber numberWithInt:EquationTokenTypeSymbol],
              [NSColor magentaColor], [NSNumber numberWithInt:EquationTokenTypeTrigFunction],
              [NSColor whiteColor], [NSNumber numberWithInt:EquationTokenTypeWhitespace],
              nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo
{
    
}

- (IBAction)equationEntered:(id)sender
{
    GraphiqueAppDelegate *delegate = NSApplication.sharedApplication.delegate;
    
    Equation *equation = [[Equation alloc] initWithString:[self.textField stringValue]];
    
    NSError *error = nil;
    
    if (![equation validate:&error])
    {
        //Display error
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Something went wrong"];
        [alert setInformativeText:[NSString stringWithFormat:@"Error %ld: %@", [error code], [error localizedDescription]]];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        [alert beginSheetModalForWindow:delegate.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
    else
    {
        [delegate.recentlyUsedEquationsViewController remember:equation];
        [delegate.graphTableViewController draw:equation];
    }
}

#pragma mark NSControlDelegate method

//Real-time validation alongwith coloring of entered equation

- (void) controlTextDidChange:(NSNotification *)obj
{
    Equation *equation = [[Equation alloc] initWithString: [self.textField stringValue]];
    
    //Create a mutable attributed string, initialized with the contents of equation text field
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:[self.textField stringValue]];
    
    // Get the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Get the selected font
    NSData *fontData = [userDefaults dataForKey:@"equationFont"];
    NSFont *equationFont = (NSFont *)[NSUnarchiver unarchiveObjectWithData:fontData];
    // Set the selected font in the font panel
    [[NSFontManager sharedFontManager] setSelectedFont:equationFont isMultiple:NO];
    
    // Set the font for the equation to the selected font
    [attributedString addAttribute:NSFontAttributeName value:equationFont range:NSMakeRange(0, [attributedString length])];
    
    int i=0;
    
    //Looping through tokens
    for (EquationToken *token in equation.tokens)
    {
        NSRange range = NSMakeRange(i, [token.value length]);
        
        //Adding foreground color
        [attributedString addAttribute:NSForegroundColorAttributeName value:[COLORS objectForKey:[NSNumber numberWithInt:token.type]] range:range];
        
        // Adding the background color
        [attributedString addAttribute:NSBackgroundColorAttributeName value:token.valid ?
         [NSColor whiteColor] : [NSColor redColor] range:range];
        
        //Superscripting the exponent
        if (token.type == EquationTokenTypeExponent)
        {
            CGFloat height = [equationFont pointSize] * 0.5;
            
            //Exponent font height
            [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:equationFont.fontName size:height] range:range];
            
            //Exponent shift upward
            [attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:height] range:range];
        }
        
        // Advancing to the next token
        i += [token.value length];
    }
    
    //Adjust height of equation entry text field to fit the new font size
    NSSize size = [self.textField frame].size;
    size.height = ceilf([equationFont ascender]) - floorf([equationFont descender]) + 4.0;
    [self.textField setFrameSize:size];
    
    //Displaying attributed string
    [self.textField setAttributedStringValue:attributedString];
    
    NSError *error = nil;
    if(![equation validate:&error])
    {
        // Validation failed, display the error
        [feedback setStringValue:[NSString stringWithFormat:@"Error %ld: %@", [error code],[error localizedDescription]]];
    }
    else
    {
        [feedback setStringValue:@""];
    }
}

@end
