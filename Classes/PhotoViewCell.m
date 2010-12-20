//
//  PhotoViewCell.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/11/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "PhotoViewCell.h"
#import "BetterFlickrAppDelegate.h"
#import "ObjectiveFlickrDelegate.h"

#import "DBPhoto.h"
#import "Downloader.h"

#import "Strings.h"

#import "QuartzViews.h"

@implementation PhotoViewCell

@synthesize preview = _preview;
@synthesize title = _title;
@synthesize photo = _photo;
@synthesize activity = _activity;
@synthesize description = _description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
       
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc
{	
	[_photo release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Layout Functions

- (void) layoutFromPhoto:(DBPhoto*)iPhoto
{
REQUIRE(iPhoto != nil)
REQUIRE([iPhoto pid] != nil)
	
	// Sets current photo
	_photo = [iPhoto retain];
	
	// Retreives application delegate for future callback
	BetterFlickrAppDelegate*aDelegate = (BetterFlickrAppDelegate*)[[UIApplication sharedApplication] delegate];

	// The filemanager will be used to retreive the content of the file if the path is already set
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	// Retreives photo info if not specified already
	// TODO: see if there can't be some improvement to be done here
	if ([iPhoto views] < 0)
	{
		[[aDelegate flickrDelegate] createRequestFromAPI:kFlickrPhotosInfo
											   arguments:[NSDictionary dictionaryWithObjectsAndKeys:
														  [iPhoto pid], @"photo_id",  nil]];

	}
	
	if ([iPhoto favourites] < 0)
	{
		[[aDelegate flickrDelegate] createRequestFromAPI:kFlickrPhotosFavorites
											   arguments:[NSDictionary dictionaryWithObjectsAndKeys:
														  [iPhoto pid], @"photo_id",  nil]];
	}
	
	// No path set yet: photo has not been downloaded yet
	// Start download in the background so we don't block the process
	if ([iPhoto photoIsStoredForSize:OFFlickrSmallSquareSize] == NO)
	{	
		_preview.image = nil;
		
		// Creates and start the downloader
		[[[Downloader alloc] initWithSender:self param:_photo] startDownloadPhotoOfSize:OFFlickrSmallSquareSize];
		
		// Starts loader
		[_activity startAnimating];
	}
	
	// Other path had already been set so retreive the photo
	// from the filesystem => no need to download it again
	else
	{
		// Get Thumbnail
		NSString* aThumbnailPath = [NSString stringWithFormat:@"%@_%@.jpg", iPhoto.path, OFFlickrSmallSquareSize];

		// Load the image with content of that file
		NSData* aData = [aFileManager contentsAtPath:aThumbnailPath];
NEEDS(aData != nil)
		UIImage* aImage = [[UIImage alloc] initWithData:aData];
		
		// Update preview
		_preview.image = aImage;
		
		// image is retained release it
		[aImage release];
		
	}
	
	// Title attribues
	_title.text = _photo.title;
	_title.font = [UIFont boldSystemFontOfSize:12];
	
	_description.text = _photo.descr;
	[_description alignTop];
	

}


@end
