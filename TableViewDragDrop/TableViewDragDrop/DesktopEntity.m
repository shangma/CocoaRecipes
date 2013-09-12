//
//  DesktopEntity.m
//  TableViewDragDrop
//
//  Created by Sagar Natekar on 9/11/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "DesktopEntity.h"

@implementation DesktopEntity

- (id)initWithFileURL:(NSURL *)fileURL
{
    if (self = [super init])
    {
        _fileURL = fileURL;
    }
    
    return self;
}

+ (DesktopEntity *) entityForURL:(NSURL *)url
{
    NSString *typeIdentifier;
    
    if ([url getResourceValue:&typeIdentifier forKey:NSURLTypeIdentifierKey error:nil])
    {
        NSArray *imgTypes = [NSImage imageTypes];
        if ([imgTypes containsObject:typeIdentifier])
        {
            return [[DesktopImageEntity alloc] initWithFileURL:url];
        }
        else if ([typeIdentifier isEqualToString:(NSString *)kUTTypeFolder])
        {
            return [[DesktopFolderEntity alloc] initWithFileURL:url];
        }
    }
    
    return nil;
}

- (NSString *) name
{
    NSString *fileName;
    if ([_fileURL getResourceValue:&fileName forKey:NSURLLocalizedNameKey error:nil])
    {
        return fileName;
    }
    return nil;
}

#pragma mark NSPasteBoardWriting

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard
{
    return [_fileURL writingOptionsForType:type pasteboard:pasteboard];
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return [_fileURL writableTypesForPasteboard:pasteboard];
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
    return [_fileURL pasteboardPropertyListForType:type];
}

#pragma mark NSPasteBoardReading

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return @[(id)kUTTypeFolder, (id)kUTTypeFileURL];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard
{
    return NSPasteboardReadingAsString;
}

- (id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type
{
    NSURL *url = [[NSURL alloc] initWithPasteboardPropertyList:propertyList ofType:type];
    return [DesktopEntity entityForURL:url];
}

@end


@implementation DesktopImageEntity

- (NSImage *) image
{
    if (!_image) {
        _image = [[NSImage alloc] initByReferencingURL:self.fileURL];
    }
    
    return _image;
}

@end

@implementation DesktopFolderEntity

@end