//
//  DBPhoto.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/5/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "DBObject.h"

// Column Location in SQLite Database
#define kPhotoFarmColumn			0
#define kPhotoServerColumn			1
#define kPhotoPostedColumn			2
#define kPhotoUpdatedColumn			3
#define kPhotoIsPublicColumn		4
#define kPhotoViewsColumn			5
#define kPhotoCommentsColumn		6
#define kPhotoFavouritesColumn		7
#define kPhotoIdColumn				8
#define kPhotoOwnerColumn			9
#define kPhotoSecretColumn			10
#define kPhotoTitleColumn			11
#define kPhotoTakenColumn			12
#define kPhotoDescriptionColumn		13
#define kPhotoPathColumn			14



// Id and User
#define kPhotoIdColumnName			@"id"
#define kPhotoOwnerColumnName		@"owner"

// Flickr Info
#define kPhotoFarmColumnName		@"farm"
#define kPhotoServerColumnName		@"server"
#define kPhotoIsPublicColumnName	@"ispublic"
#define kPhotoSecretColumnName		@"secret"

// Dates
#define kPhotoTakenColumnName		@"taken"
#define kPhotoPostedColumnName		@"posted"
#define kPhotoUpdatedColumnName		@"updated"

// Description
#define kPhotoTitleColumnName		@"title"
#define kPhotoDescriptionColumnName @"description"

// Storage
#define kPhotoPathColumnName		@"path"

// Stats
#define kPhotoViewsColumnName		@"views"
#define kPhotoCommentsColumnName	@"comments"
#define kPhotoFavouritesColumnName	@"favourites"

// Other Pertinents Constants Info
#define kPhotoTableName				@"Photos"
#define kPhotoFlickrName			@"photo"
#define kPhotoPage					@"page"
#define kPhotoPages					@"pages"
#define kPhotoFavoritesTotal		@"total"
#define kPhotoFlickrPhotoSource		@"http://static.flickr.com/"

@interface DBPhoto : DBObject 
{
	NSString*	_id;
	NSString*	_owner;
	NSString*	_secret;
	
	NSString*	_taken;
	
	// Description
	NSString*	_title;
	NSString*	_desc;
	
	//Storage
	NSString*	_path;
	
	// Flickr
	NSInteger	_farm;
	NSInteger	_server;
	
	// Dates
	NSInteger	_posted;
	NSInteger	_updated;
	
	// Stats
	NSInteger	_comments;
	NSInteger	_views;
	NSInteger	_favourites;
	
	BOOL		_isPublic;
	
}

@property (nonatomic, retain) NSString*	pid;
@property (nonatomic, retain) NSString*	owner;
@property (nonatomic, retain) NSString*	secret;
@property (nonatomic, retain) NSString*	title;
@property (nonatomic, retain) NSString* taken;
@property (nonatomic, retain) NSString* descr;
@property (nonatomic, retain) NSString* path;

@property (nonatomic) NSInteger posted;
@property (nonatomic) NSInteger updated;
@property (nonatomic) NSInteger	farm;
@property (nonatomic) NSInteger	server;
@property (nonatomic) NSInteger	comments;
@property (nonatomic) NSInteger	views;
@property (nonatomic) NSInteger	favourites;
@property (nonatomic) BOOL isPublic;

/*!
 * @method		urlForPhotoSize:
 * @abstract	Returns the flickr URL based on the size of the photo desired
 * @param		inSizeModifier	The size of the photo desired. (see ObjectiveFlickr.h)
 * @result		A NSURL object with the flickr URL
 */
- (NSURL *)urlForPhotoSize:(NSString *)inSizeModifier;


/*!
 * @method		pathForPhotoSize:
 * @abstract	Returns the flocally stored path based on the size of the photo desired
 * @param		inSizeModifier	The size of the photo desired. (see ObjectiveFlickr.h)
 * @result		The path for the desired photo if it's stored, nil otheriwise
 */
- (NSString *)pathForPhotoSize:(NSString *)inSizeModifier;

/*!
 * @method		pathForPhotoSize:
 * @abstract	Returns the content of the locally stored image based on the size of the photo desired
 *				If the desired photo is not stored locally, this function will return nil
 * @param		inSizeModifier	The size of the photo desired. (see ObjectiveFlickr.h)
 * @result		The content for the desired photo if it's stored, nil otherwise
 */
- (NSData *)contentForPhotoSize:(NSString *)iSize;

/*!
 * @method		descriptionForWebView:
 * @abstract	Overrides the description field to be able to display in a UIWebView
 * @result		An HTML String with the photo description
 */
- (NSString *)descriptionForWebView;

/*!
 * @method		photoIsStoredForSize:
 * @abstract	Returns YES if the photo has been locally downloaded for a given size (ex small)
 * @param		iSize	The size of the photo desired
 * @result		YES if stored locally
 */
- (BOOL)photoIsStoredForSize:(NSString*)iSize;

/*!
 * @method		updateFromPhoto:
 * @abstract	Sometimes a BOM object is not as complete as it could be
 *				but still holds some information that needs to be updated.
 *				The purpose of this function is therefore to reflect those changes 
 *				while keeping previous information unchanged.
 * @param		iPhoto	The BOM instance of the object to be based on update
 * @result		a self version updated from the parameter
 */
- (DBPhoto*)updateFromPhoto:(DBPhoto*)iPhoto;


- (DBPhoto*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;
- (DBPhoto*)initWithDictionary:(NSDictionary*)iDictionary;

@end
