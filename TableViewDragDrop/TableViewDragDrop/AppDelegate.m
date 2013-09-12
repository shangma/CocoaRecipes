//
//  AppDelegate.m
//  TableViewDragDrop
//
//  Created by Sagar Natekar on 9/11/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppDelegate.h"
#import "DesktopEntity.h"

@implementation AppDelegate {
    NSMutableArray *_tableContents;
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
    _tableContents = [[NSMutableArray alloc] init];
    //NSString *path = @"/Library/Application Support/Apple/iChat Icons/Flags";
    NSString *path = @"/Library/Application Support/Apple/iChat Icons/";
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtURL:url
                              includingPropertiesForKeys:nil
                                                 options:0
                                            errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                return YES;
                                            }];
    
    /*
     NSString *file;
     while (file = [dirEnum nextObject])
     {
     NSString *filePath = [path stringByAppendingFormat:@"/%@", file];
     NSDictionary *obj = @{@"image": [[NSImage alloc] initByReferencingFile:filePath],
     @"name": [file stringByDeletingPathExtension],
     @"filePath": filePath};
     [_tableContents addObject:obj];
     }
     */
    
    for (NSURL *fileURL in dirEnum) {
        DesktopEntity *entity = [DesktopEntity entityForURL:fileURL];
        [_tableContents addObject:entity];
    }
    [_tableView reloadData];
    
    //Accept drags
    [_tableView registerForDraggedTypes:@[(id)kUTTypeFileURL]];
    
    [_tableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
}

- (IBAction)insertNewRow:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSImage imageFileTypes]];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSInteger selectedRow = [_tableView selectedRow];
            selectedRow++;
            NSArray *urls = [openPanel URLs];
            [_tableView beginUpdates];
            for (NSURL *url in urls) {
                DesktopEntity *entity = [DesktopEntity entityForURL:url];
                if (entity) {
                    [_tableContents insertObject:entity atIndex:selectedRow];
                    [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
                    selectedRow++;

                }
            }
            [_tableView endUpdates];
            [_tableView scrollRowToVisible:selectedRow];
        }
    }];
}

- (IBAction)removeSelectedRows:(id)sender
{
    NSIndexSet *indexes = [_tableView selectedRowIndexes];
    [_tableContents removeObjectsAtIndexes:indexes];
    [_tableView removeRowsAtIndexes:indexes withAnimation:NSTableViewAnimationSlideDown];
}

- (IBAction)locateInFinder:(id)sender
{
    NSInteger selectedRow = [_tableView rowForView:sender];
    //NSDictionary *obj = _tableContents[selectedRow];
    DesktopEntity *entity = _tableContents[selectedRow];
    //[[NSWorkspace sharedWorkspace] selectFile:obj[@"filePath"] inFileViewerRootedAtPath:nil];
    [[NSWorkspace sharedWorkspace] selectFile:[entity.fileURL path] inFileViewerRootedAtPath:nil];
    
}

#pragma mark TableView datasource and delegate methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_tableContents count];
}

- (id<NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row
{
    return _tableContents[row];
    
}

- (NSDictionary *) pasteboardReadingOptions
{
    return @{NSPasteboardURLReadingFileURLsOnlyKey: @YES,
             NSPasteboardURLReadingContentsConformToTypesKey: [NSImage imageTypes]};
}

- (BOOL) containsAcceptableURLsFromPasteBoard:(NSPasteboard *) pasteboard
{
    return [pasteboard canReadObjectForClasses:@[[NSURL class]]
                                       options:[self pasteboardReadingOptions]];
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    if (dropOperation == NSTableViewDropAbove) {
        if ([info draggingSource] == tableView)
        {
            //Re-order happening within tableview...
        }
        else
        {
            //Drag-drop happening into table view from another source
            if ([self containsAcceptableURLsFromPasteBoard:[info draggingPasteboard]])
            {
                [info setAnimatesToDestination:YES];
                return NSDragOperationCopy;
            }
        }
    }
    
    return NSDragOperationNone;
}

- (void)tableView:(NSTableView *)tableView updateDraggingItemsForDrag:(id<NSDraggingInfo>)draggingInfo
{
    if ([draggingInfo draggingSource] != tableView)
    {
        NSArray *classes = @[[DesktopEntity class], [NSPasteboardItem class]];
        NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:@"ImageCell" owner:self];
        __block NSInteger validCount = 0;
        [draggingInfo enumerateDraggingItemsWithOptions:0 forView:tableView classes:classes searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
            if ([draggingItem.item isKindOfClass:[DesktopEntity class]])
            {
                DesktopEntity *entity = (DesktopEntity *)draggingItem.item;
                draggingItem.draggingFrame = [tableCellView frame];
                draggingItem.imageComponentsProvider = ^NSArray *{
                    
                    if ([entity isKindOfClass:[DesktopImageEntity class]])
                        [tableCellView.imageView setImage:[(DesktopImageEntity *)entity image]];

                    [tableCellView.textField setStringValue:entity.name];
                    return [tableCellView draggingImageComponents];
                };
                
                validCount++;
            }
            else
            {
                draggingItem.imageComponentsProvider = nil;
            }
        }];
        
        [draggingInfo setNumberOfValidItemsForDrop:validCount];
        [draggingInfo setDraggingFormation:NSDraggingFormationList];
    }
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    DesktopEntity *entity = _tableContents[row];
    if ([entity isKindOfClass:[DesktopFolderEntity class]])
    {
        NSTextField *groupCell = [tableView makeViewWithIdentifier:@"GroupCell" owner:self];
        [groupCell setStringValue:entity.name];
        return groupCell;
    }
    if ([entity isKindOfClass:[DesktopImageEntity class]]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"ImageCell" owner:self];
        [cellView.textField setStringValue:[entity.name stringByDeletingPathExtension]];
        [cellView.imageView setImage:((DesktopImageEntity *)entity).image];
        return cellView;
    }
    
    /*
     NSDictionary *flag = _tableContents[row];
     
     NSString *identifier = [tableColumn identifier];
     
     if ([identifier isEqualToString:@"MainCell"])
     {
     NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
     [cellView.imageView setImage:flag[@"image"]];
     [cellView.textField setStringValue:flag[@"name"]];
     return cellView;
     }
     */
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    DesktopEntity *entity = _tableContents[row];
    
    if ([entity isKindOfClass:[DesktopFolderEntity class]]) {
        return YES;
    }
    
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    DesktopEntity *entity = _tableContents[row];
    
    if ([entity isKindOfClass:[DesktopFolderEntity class]]) {
        return 22;
    }
    
    return [tableView rowHeight];
}

@end
