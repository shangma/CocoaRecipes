//
//  MasterViewController.m
//  ScaryBugsMac
//
//  Created by Sagar Natekar on 7/23/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "MasterViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import <Quartz/Quartz.h>
#import "NSImage+Extras.h"

@interface MasterViewController ()

@property (weak) IBOutlet NSTableView *bugsTableView;
@property (weak) IBOutlet NSTextField *bugTitleView;
@property (weak) IBOutlet NSImageView *bugImageView;
@property (weak) IBOutlet EDStarRating *bugRating;
@property (weak) IBOutlet NSButton *deleteButton;
@property (weak) IBOutlet NSButton *changePictureButton;

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) loadView
{
    [super loadView];
    self.bugRating.starImage = [NSImage imageNamed:@"star.png"];
    self.bugRating.starHighlightedImage = [NSImage imageNamed:@"shockedface2_full.png"];
    self.bugRating.starImage = [NSImage imageNamed:@"shockedface2_empty.png"];
    self.bugRating.maxRating = 5.0;
    self.bugRating.delegate = (id <EDStarRatingProtocol>)self;
    self.bugRating.horizontalMargin = 12;
    self.bugRating.editable=NO;
    self.bugRating.displayMode=EDStarRatingDisplayFull;

    self.bugRating.rating= 0.0;
}

//This method will be called by the OS for every row and column of the table view, and there you have to create the proper cell, and fill it with the information you need.
- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //Get a new cell view for that particular row and column
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"BugColumn"])
    {
        ScaryBugDoc *bugDoc = [self.bugs objectAtIndex:row];
        cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = bugDoc.data.title;
        return cellView;
    }
    
    return cellView;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.bugs count];
}

- (ScaryBugDoc *) selectedBugDoc
{
    NSInteger selectedRow = [self.bugsTableView selectedRow];
    if (selectedRow >= 0 && self.bugs.count > selectedRow) {
        ScaryBugDoc *selectedBug = [self.bugs objectAtIndex:selectedRow];
        return selectedBug;
    }
    return nil;
}

- (void) setDetailInfo:(ScaryBugDoc *) doc
{
    NSString *title = @"";
    NSImage *image = nil;
    float rating = 0.0;
    if (doc != nil) {
        title = doc.data.title;
        image = doc.fullImage;
        rating = doc.data.rating;
    }
    [self.bugTitleView setStringValue:title];
    [self.bugImageView setImage:image];
    [self.bugRating setRating:rating];
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    [self setDetailInfo:selectedDoc];
    BOOL buttonsEnabled = (selectedDoc != nil);
    [self.deleteButton setEnabled:buttonsEnabled];
    [self.changePictureButton setEnabled:buttonsEnabled];
    [self.bugRating setEditable:buttonsEnabled];
    [self.bugTitleView setEnabled:buttonsEnabled];
}

- (IBAction)addBug:(id)sender
{
    // 1. Create a new ScaryBugDoc object with a default name
    ScaryBugDoc *newDoc = [[ScaryBugDoc alloc] initWithTitle:@"New Bug" rating:0.0 thumbImage:nil fullImage:nil];
    
    // 2. Add the new bug object to our model (insert into the array)
    [self.bugs addObject:newDoc];
    NSInteger newRowIndex = self.bugs.count - 1;
    
    // 3. Insert new row in the table view
    [self.bugsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    
    // 4. Select the new bug and scroll to make sure it's visible
    [self.bugsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.bugsTableView scrollRowToVisible:newRowIndex];
}

- (IBAction)deleteBug:(id)sender
{
    // 1. Get selected doc
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc)
    {
        // 2. Remove the bug from the model
        [self.bugs removeObject:selectedDoc];
        // 3. Remove the selected row from the table view.
        [self.bugsTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.bugsTableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
        // Clear detail info
        [self setDetailInfo:nil];
        
        // 4. Select the last row and scroll to it
        NSInteger newRowIndex = self.bugs.count - 1;
        [self.bugsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
        [self.bugsTableView scrollRowToVisible:newRowIndex];
    }
}

- (IBAction)bugTitleDidEndEdit:(id)sender
{
    // 1. Get selected bug
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc )
    {
        // 2. Get the new name from the text field
        selectedDoc.data.title = [self.bugTitleView stringValue];
        // 3. Update the cell
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedDoc]];
        NSIndexSet *columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.bugsTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}

- (void) starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc )
    {
        selectedDoc.data.rating = self.bugRating.rating;
    }
}
- (IBAction)changePicture:(id)sender
{
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc) {
        [[IKPictureTaker pictureTaker] beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

- (void) pictureTakerDidEnd:(IKPictureTaker *) picker
                 returnCode:(NSInteger) code
                contextInfo:(void*) contextInfo
{
    NSImage *image = [picker outputImage];
    //when this is invoked, it means that the picture taker control has finished its work. But the user may have cancelled the operation, and you wouldn’t have any image available.For that, you check that the control returned OK (NSOKButton) and that you have a new image available.
    if( image !=nil && (code == NSOKButton) )
    {
        [self.bugImageView setImage:image];
        ScaryBugDoc * selectedBugDoc = [self selectedBugDoc];
        if( selectedBugDoc )
        {
            selectedBugDoc.fullImage = image;
            selectedBugDoc.thumbImage = [image imageByScalingAndCroppingForSize:CGSizeMake( 44, 44 )];
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedBugDoc]];
            
            NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
            [self.bugsTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }
}

@end
