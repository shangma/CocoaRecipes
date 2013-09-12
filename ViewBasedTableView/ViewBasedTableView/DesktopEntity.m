//
//  DesktopEntity.m
//  ViewBasedTableView
//
//  Created by Sagar Natekar on 9/8/13.
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

//

@end