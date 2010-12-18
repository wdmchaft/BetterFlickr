//
//  DBPhoto.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/5/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBPhoto.h"
#import "Strings.h"

@implementation DBPhoto

@synthesize pid = _id;
@synthesize owner = _owner;
@synthesize secret = _secret;
@synthesize title = _title;
@synthesize farm = _farm;
@synthesize server = _server;
@synthesize isPublic = _isPublic;
@synthesize posted = _posted;
@synthesize updated = _updated;
@synthesize taken = _taken;
@synthesize descr = _desc;
@synthesize path = _path;
@synthesize comments = _comments;
@synthesize views = _views;
@synthesize favourites = _favourites;

#pragma mark Init Functions

- (DBPhoto*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement
{
	if (self = [super init])
	{
		_farm		= [NSString integerFromStatement:iStatement column:kPhotoFarmColumn];
		_server		= [NSString integerFromStatement:iStatement column:kPhotoServerColumn];
		_isPublic	= [NSString integerFromStatement:iStatement column:kPhotoIsPublicColumn];
		_posted		= [NSString integerFromStatement:iStatement column:kPhotoPostedColumn];
		_updated	= [NSString integerFromStatement:iStatement column:kPhotoUpdatedColumn];
		_views		= [NSString integerFromStatement:iStatement column:kPhotoViewsColumn];
		_comments	= [NSString integerFromStatement:iStatement column:kPhotoCommentsColumn];
		_favourites	= [NSString integerFromStatement:iStatement column:kPhotoFavouritesColumn];
		
		_id			= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoIdColumn];
		_owner		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoOwnerColumn];
		_secret		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoSecretColumn];
		_title		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoTitleColumn];
		_taken		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoTakenColumn];
		_desc		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoDescriptionColumn];
		_path		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoPathColumn];
	}
	
	return self;
	
}

- (DBPhoto*)initWithDictionary:(NSDictionary*)iDictionary
{
	if (self = [super init])
	{
		_id			= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoIdColumnName];
		_owner		= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoOwnerColumnName];
		_secret		= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoSecretColumnName];
		_title		= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoTitleColumnName];
		_taken		= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoTakenColumnName];
		_desc		= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoDescriptionColumnName];
		_path		= [[NSString alloc] initWithDictionary:iDictionary key:kPhotoPathColumnName];
		
		_farm		= [NSString integerFromDictionary:iDictionary key:kPhotoFarmColumnName];
		_server		= [NSString integerFromDictionary:iDictionary key:kPhotoServerColumnName];
		_isPublic	= [NSString integerFromDictionary:iDictionary key:kPhotoIsPublicColumnName];
		_posted		= [NSString integerFromDictionary:iDictionary key:kPhotoPostedColumnName];
		_updated	= [NSString integerFromDictionary:iDictionary key:kPhotoUpdatedColumnName];
		_views		= [NSString integerFromDictionary:iDictionary key:kPhotoViewsColumnName];
		_comments	= [NSString integerFromDictionary:iDictionary key:kPhotoCommentsColumnName];
		_favourites	= [NSString integerFromDictionary:iDictionary key:kPhotoFavouritesColumnName];
	}
	
	return self;
}

- (void)dealloc
{
	[_id release];
	[_owner release];
	[_secret release];
	[_title release];
	[_desc release];
	[_path release];
	[_taken release];
	
	[super dealloc];
}

#pragma mark Useful Functions

/*!
 * @method		photoIsStoredForSize:
 * @abstract	Returns YES if the photo has been locally downloaded for a given size (ex small)
 * @param		iSize	The size of the photo desired
 * @result		YES if stored locally
 */
- (BOOL)photoIsStoredForSize:(NSString*)iSize
{
	// Size can be null for example for OFFlickrMediumSize
	// So leave it empty
	NSString* aExt = @"";
	if ([iSize length])
		aExt = [NSString stringWithFormat:@"_%@", iSize];
	
	
	BOOL aIsStored = NO;
	
	if (_path != nil)
	{
		// The filemanager will be used to retreive the content of the file if the path is already set
		NSFileManager *aFileManager = [NSFileManager defaultManager];
		
		// Get Thumbnail
		NSString* aPhotoPath = [NSString stringWithFormat:@"%@%@.jpg", self.path, aExt];
		
		// Load the image with content of that file
		aIsStored = [aFileManager fileExistsAtPath:aPhotoPath];	
	}
	
	return aIsStored;
	
}

/*!
 * @method		pathForPhotoSize:
 * @abstract	Returns the flocally stored path based on the size of the photo desired
 * @param		inSizeModifier	The size of the photo desired. (see ObjectiveFlickr.h)
 * @result		The path for the desired photo if it's stored, nil otherwise
 */
- (NSString *)pathForPhotoSize:(NSString *)iSize
{
	// Size can be null for example for OFFlickrMediumSize
	// So leave it empty
	NSString* aExt = @"";
	if ([iSize length])
		aExt = [NSString stringWithFormat:@"_%@", iSize];
	
	
	NSString* aPhotoPath = nil; 
	
	if (_path != nil)
	{
		// The filemanager will be used to retreive the content of the file if the path is already set
		NSFileManager *aFileManager = [NSFileManager defaultManager];
		
		// Construct Path
		aPhotoPath = [NSString stringWithFormat:@"%@%@.jpg", self.path, aExt];
		
		if ([aFileManager fileExistsAtPath:aPhotoPath] == NO)
			aPhotoPath = nil;
			
	}
	
	return aPhotoPath;
	
}

/*!
 * @method		pathForPhotoSize:
 * @abstract	Returns the content of the locally stored image based on the size of the photo desired
 *				If the desired photo is not stored locally, this function will return nil
 * @param		inSizeModifier	The size of the photo desired. (see ObjectiveFlickr.h)
 * @result		The content for the desired photo if it's stored, nil otherwise
 */
- (NSData *)contentForPhotoSize:(NSString *)iSize
{
	// Size can be null for example for OFFlickrMediumSize
	// So leave it empty
	NSString* aExt = @"";
	if ([iSize length])
		aExt = [NSString stringWithFormat:@"_%@", iSize];
	
	
	NSData* aContent = nil; 
	
	if (_path != nil)
	{
		// The filemanager will be used to retreive the content of the file if the path is already set
		NSFileManager *aFileManager = [NSFileManager defaultManager];
		
		// Construct Path
		NSString* aPhotoPath = [NSString stringWithFormat:@"%@%@.jpg", self.path, aExt];
		
		// Get Content at Specified Path
		if ([aFileManager fileExistsAtPath:aPhotoPath] != NO)
			aContent = [aFileManager contentsAtPath:aPhotoPath];
		
	}
	
	return aContent;
	
}

/*!
 * @method		urlForPhotoSize:
 * @abstract	Returns the flickr URL based on the size of the photo desired
 * @param		inSizeModifier	The size of the photo desired. (see ObjectiveFlickr.h)
 * @result		A NSURL object with the flickr URL
 */
- (NSURL *)urlForPhotoSize:(NSString *)iSizeModifier
{
	// http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
	// http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
	
REQUIRE(_farm > 0)
REQUIRE(_server > 0)
REQUIRE([_secret length] > 0)
REQUIRE([_id length] > 0)
	
	
	NSMutableString *aURLString = [NSMutableString stringWithString:@"http://"];
	[aURLString appendFormat:@"farm%d.", _farm];

	
	[aURLString appendString:[kPhotoFlickrPhotoSource substringFromIndex:7]];
	[aURLString appendFormat:@"%d/%@_%@", _server, _id, _secret];
	
	if ([iSizeModifier length]) 
		[aURLString appendFormat:@"_%@.jpg", iSizeModifier];
	else 
		[aURLString appendString:@".jpg"];
	
	return [NSURL URLWithString:aURLString];
}

/*!
 * @method		updateFromPhoto:
 * @abstract	Sometimes a BOM object is not as complete as it could be
 *				but still holds some information that needs to be updated.
 *				The purpose of this function is therefore to reflect those changes 
 *				while keeping previous information unchanged.
 * @param		iPhoto	The BOM instance of the object to be based on update
 * @result		a self version updated from the parameter
 */
- (DBPhoto*)updateFromPhoto:(DBPhoto*)iPhoto
{
	if (iPhoto.descr)
		self.descr = iPhoto.descr;
	if (iPhoto.views)
		self.views = iPhoto.views;
	if (iPhoto.comments)
		self.comments = iPhoto.comments;
	if (iPhoto.favourites)
		self.favourites = iPhoto.favourites;
	if (iPhoto.taken)
		self.taken= iPhoto.taken;
	if (iPhoto.updated)
		self.updated= iPhoto.updated;
	if (iPhoto.posted)
		self.posted = iPhoto.posted;
		 
	return self;
	
}


@end
	