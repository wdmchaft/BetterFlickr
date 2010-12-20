//
//  DBComment.h
//  BetterFlickr
//
//  Created by Johan Attali on 12/19/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "DBObject.h"

// Column Location in SQLite Database
#define kCommentIdColumn			0
#define kCommentContentColumn		1
#define kCommentDateCreatedColumn	2
#define kCommentRefUserColumn		3
#define kCommentRefPhotoColumn		4

// Column Names in SQLite Database
#define kCommentIdColumnName			@"id"
#define kCommentContentColumnName		@"content"
#define kCommentDateCreatedColumnName	@"dateCreated"
#define kCommentRefUserColumnName		@"refUser"
#define kCommentRefPhotoColumnName		@"refPhoto"

// Dictionary Names
#define kCommentDicName				@"comment"
#define kCommentIdDictName			@"id"
#define kCommentContentDictName		@"_text"
#define kCommentDateCreatedDictName	@"datecreate"
#define kCommentRefUserDictName		@"author"
#define kCommentRefPhotoDictName	@"photo_id"

// Other Pertinents Constants Info
#define kCommentTableName			@"Comments"


@interface DBComment : DBObject
{
	NSString*	_id;
	NSString*	_content;
	NSString*	_dateCreated;
	
	// Foreign Keys
	NSString*	_refUser;
	NSString*	_refPhoto;
}

- (DBComment*)initWithDictionary:(NSDictionary*)iDictionary refPhotoId:(NSString*)refPhotoId;

/*!
 * @method		contentForWebView:
 * @abstract	Overrides the description field to be able to display in a UIWebView
 * @result		An HTML String with the photo description
 */
- (NSString *)contentForWebView;

@property (nonatomic, retain) NSString*	cid;
@property (nonatomic, retain) NSString*	content;
@property (nonatomic, retain) NSString*	dateCreated;
@property (nonatomic, retain) NSString*	refUser;
@property (nonatomic, retain) NSString* refPhoto;

@end
