//
//  DBCommentAccessor.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/19/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBCommentAccessor.h"

#import "DBComment.h"
#import "DBPhoto.h"

#import "Strings.h"

@implementation DBCommentAccessor

#pragma mark -
#pragma mark Parents Functions

+ (DBCommentAccessor*)instance
{
	static DBCommentAccessor* db = nil;
	if (db == nil)
		db = [[DBCommentAccessor alloc] init];
	return db;
}

- (NSString*) preparationStatement
{
	return [NSString stringWithFormat:@"%@,%@,%@,%@,%@",
			
			// Integers
			kCommentIdColumnName,
			kCommentContentColumnName,
			kCommentDateCreatedColumnName,
			kCommentRefUserColumnName,
			kCommentRefPhotoColumnName
			];
}

#pragma mark -
#pragma mark INSERT/UPDATE Queries Functions

/*!
 * @method		insertComment:
 * @abstract	Saves the BOM object into the local database
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) insertComment:(DBComment*)iComment
{
REQUIRE(iComment != nil)
	
	DBComment* aComment = nil ;//[self photoFromId:iPhoto.pid];
	
	// Object is already in DB => no need to go further
	if (aComment != nil)
		return NO;
	
	// Creating Insertion Query
	char* aQuery = sqlite3_mprintf("INSERT INTO %s (%s) VALUES (%Q,%Q,%Q,%Q,%Q)",
								   [kCommentTableName cStringUsingEncoding:NSUTF8StringEncoding],
								   [[self preparationStatement] cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   [iComment.cid cSatementSafeString],
								   [iComment.content cSatementSafeString],
								   [iComment.dateCreated cSatementSafeString],
								   [iComment.refUser cSatementSafeString],
								   [iComment.refPhoto cSatementSafeString]
								   );
	
	// Execute
	BOOL result =  [self executeQuery:aQuery];
	
	// Free
	sqlite3_free(aQuery);
	
	// Return
	return result;
	
}

#pragma mark -
#pragma mark SELECT Queries Functions

/*!
 * @method		commentFromId:
 * @abstract	Retreives DBObject from its Object ID. nil is returned if not found
 * @param		iObjId	The object id
 * @result		An autoreleased instance of the object if found, nil otherwise
 */
- (DBComment*) commentFromId:(NSString*)iObjId
{
	// Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",
						[self preparationStatement],
						
						kCommentTableName,
						kCommentIdColumnName,
						iObjId];
	
	// Retrieve the DB object if already existing
	NSArray* aArray = [self arrayOfObjectsFromQuery:[aQuery UTF8String] object:[DBComment class]];
	
	// While the user has not logged in the array can be empty
	if ([aArray count] == 0)
		return nil;
	
	// Otherwise returns the first object
	return [aArray objectAtIndex:0];
	
}

/*!
 * @method		commentsForPhoto:
 * @abstract	Retreives a list of DBObjects based on the depending parameter
 * @param		iPhoto	The object id
 * @result		An array will all objects matching the request (can be empty if no objects found).
 */
- (NSArray*) commentsForPhoto:(DBPhoto*)iPhoto
{
REQUIRE(iPhoto != nil)
REQUIRE([iPhoto pid] != nil)
	
	// Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",
						[self preparationStatement],
						
						kCommentTableName,
						kCommentRefPhotoColumnName,
						[iPhoto pid]];
	
	// Retrieve the DB object if already existing
	NSArray* aArray = [self arrayOfObjectsFromQuery:[aQuery UTF8String] object:[DBComment class]];
	
	
	// Otherwise returns the first object
	return aArray;
	
}

@end
