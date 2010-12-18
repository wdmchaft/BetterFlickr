//
//  DBPhotoAccessor.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/7/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBPhotoAccessor.h"
#import "DBPhoto.h"
#import "DBUser.h"

#import "Strings.h"

@implementation DBPhotoAccessor


#pragma mark -
#pragma mark Parents Functions

+ (DBPhotoAccessor*)instance
{
	static DBPhotoAccessor* db = nil;
	if (db == nil)
		db = [[DBPhotoAccessor alloc] init];
	return db;
}

- (NSString*) preparationStatement
{
	return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@, %@,%@,%@,%@,%@,%@,%@",
			
			// Integers
			kPhotoFarmColumnName,
			kPhotoServerColumnName,
			kPhotoPostedColumnName,
			kPhotoUpdatedColumnName,
			kPhotoIsPublicColumnName,
			kPhotoViewsColumnName,
			kPhotoCommentsColumnName,
			kPhotoFavouritesColumnName,
			
			// Strings
			kPhotoIdColumnName,
			kPhotoOwnerColumnName,
			kPhotoSecretColumnName,
			kPhotoTitleColumnName,
			kPhotoTakenColumnName,
			kPhotoDescriptionColumnName,
			kPhotoPathColumnName
			
			];
}


#pragma mark -
#pragma mark INSERT/UPDATE Queries Functions

/*!
 * @method		savePhoto
 * @abstract	Two behaviors possible depending on the object passed in parameter.
 *				If the object is already stored in the local DB then its content is simply updated
 *				If the object is new, it is directly insterted into the local DB
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) savePhoto:(DBPhoto*)iPhoto
{
REQUIRE(iPhoto != nil)
	
	DBPhoto* aPhoto = [self photoFromId:iPhoto.pid];
	BOOL aSuccess	= NO;
	if (aPhoto == nil)
		aSuccess = [self insertPhoto:iPhoto];
	else
		aSuccess = [self updatePhoto:iPhoto];

	return aSuccess;
}

/*!
 * @method		insertPhoto:
 * @abstract	If the object is new, it is directly insterted into the local DB
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) insertPhoto:(DBPhoto*)iPhoto
{
REQUIRE(iPhoto != nil)
	
	DBPhoto* aPhoto = [self photoFromId:iPhoto.pid];
	
	// Photo is already in DB => no need to go further
	if (aPhoto != nil)
		return NO;
	
	// Creating Insertion Query
	char* aQuery = sqlite3_mprintf("INSERT INTO %s (%s) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%Q,%Q,%Q,%Q,%Q,%Q,%Q)",
								   [kPhotoTableName cStringUsingEncoding:NSUTF8StringEncoding],
								   [[self preparationStatement] cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   [NSString cSatementSafeStringFromInteger:iPhoto.farm],
								   [NSString cSatementSafeStringFromInteger:iPhoto.server],
								   [NSString cSatementSafeStringFromInteger:iPhoto.posted],
								   [NSString cSatementSafeStringFromInteger:iPhoto.updated],
								   [NSString cSatementSafeStringFromInteger:iPhoto.isPublic],
								   [NSString cSatementSafeStringFromInteger:iPhoto.views],
								   [NSString cSatementSafeStringFromInteger:iPhoto.comments],
								   [NSString cSatementSafeStringFromInteger:iPhoto.favourites],
								   
								   [iPhoto.pid cSatementSafeString],
								   [iPhoto.owner cSatementSafeString],
								   [iPhoto.secret cSatementSafeString],
								   [iPhoto.title  cSatementSafeString],
								   [iPhoto.taken cSatementSafeString],
								   [iPhoto.descr cSatementSafeString],
								   [iPhoto.path  cSatementSafeString]
								   );
	
	// Execute
	BOOL result =  [self executeQuery:aQuery];
	
	// Free
	sqlite3_free(aQuery);
	
	// Return
	return result;
	
}

/*!
 * @method		updatePhoto:
 * @abstract	If the object is already stored in the local DB then its content is simply updated
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) updatePhoto:(DBPhoto*)iPhoto
{
REQUIRE(iPhoto != nil)
	
	DBPhoto* aPhoto = [self photoFromId:iPhoto.pid];
	
	// Photo is already in DB => no need to go further
	if (aPhoto == nil)
		return NO;
	
	// Creating Insertion Query
	char* aQuery = sqlite3_mprintf("UPDATE %s SET %s = %s, %s = %s, %s = %s, %s = %s, %s = %s, %s = %s, %s = %s, %s = %s, %s = %Q, %s = %Q, %s = %Q, %s = %Q, %s = %Q, %s = %Q WHERE %s = %Q",
								   [kPhotoTableName cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   // Non Strings
								   [kPhotoFarmColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[NSString cSatementSafeStringFromInteger:iPhoto.farm],
								   [kPhotoServerColumnName  cStringUsingEncoding:NSUTF8StringEncoding],		[NSString cSatementSafeStringFromInteger:iPhoto.server],
								   [kPhotoIsPublicColumnName cStringUsingEncoding:NSUTF8StringEncoding],	[NSString cSatementSafeStringFromInteger:iPhoto.isPublic],
								   [kPhotoPostedColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[NSString cSatementSafeStringFromInteger:iPhoto.updated],
								   [kPhotoUpdatedColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[NSString cSatementSafeStringFromInteger:iPhoto.posted],
								   [kPhotoViewsColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[NSString cSatementSafeStringFromInteger:iPhoto.views],
								   [kPhotoCommentsColumnName cStringUsingEncoding:NSUTF8StringEncoding],	[NSString cSatementSafeStringFromInteger:iPhoto.comments],
								   [kPhotoFavouritesColumnName cStringUsingEncoding:NSUTF8StringEncoding],	[NSString cSatementSafeStringFromInteger:iPhoto.favourites],
								   
								   // Strings
								   [kPhotoOwnerColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[iPhoto.owner cSatementSafeString],
								   [kPhotoSecretColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[iPhoto.secret cSatementSafeString],
								   [kPhotoPathColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[iPhoto.path  cSatementSafeString],
								   [kPhotoDescriptionColumnName cStringUsingEncoding:NSUTF8StringEncoding],	[iPhoto.descr  cSatementSafeString],
								   [kPhotoTakenColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[iPhoto.taken  cSatementSafeString],
								   [kPhotoTitleColumnName cStringUsingEncoding:NSUTF8StringEncoding],		[iPhoto.title  cSatementSafeString],
								   
								   // WHERE
								   [kPhotoIdColumnName cStringUsingEncoding:NSUTF8StringEncoding], [iPhoto.pid cSatementSafeString]
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
 * @method		photoFromId:
 * @abstract	Retreives DBObject from its Object ID. nil is returned if not found
 * @param		iObjId	The object id
 * @result		An autoreleased instance of the object if found, nil otherwise
 */
- (DBPhoto*) photoFromId:(NSString*)iObjId
{			 
	// Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",
						[self preparationStatement],
						
						kPhotoTableName,
						kPhotoIdColumnName,
						iObjId];
	
	// Retrieve the DB object if already existing
	NSArray* aArray = [self arrayOfObjectsFromQuery:[aQuery UTF8String] object:[DBPhoto class]];
	
	// While the user has not logged in the array can be empty
	if ([aArray count] == 0)
		return nil;
	
	// Otherwise returns the first object
	return [aArray objectAtIndex:0];
	
}



/*!
 * @method		photosFromUser:
 * @abstract	Retreives a list of DBObjects based on the depending parameter
 * @param		iUser	The object id
 * @result		An array will all objects matching the request (can be empty if no objects found).
 */
- (NSArray*) photosFromUser:(DBUser*)iUser
{
REQUIRE(iUser != nil)
REQUIRE([iUser nsid] != nil)
	
	// Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",
						[self preparationStatement],
						
						kPhotoTableName,
						kPhotoOwnerColumnName,
						[iUser nsid]];
	
	// Retrieve the DB object if already existing
	NSArray* aArray = [self arrayOfObjectsFromQuery:[aQuery UTF8String] object:[DBPhoto class]];
	
	
	// Otherwise returns the first object
	return aArray;
}

/*!
 * @method		photosFromSearch:
 * @abstract	Retreives a list of DBObjects based from a query to search
 * @param		iSearch	The string to search for
 * @result		An array will all objects matching the request (can be empty if no objects found).
 */
- (NSArray*) photosFromSearch:(NSString*)iSearch
{
REQUIRE(iSearch != nil)
	
	// Creating Insertion Query
	char* aQuery = sqlite3_mprintf("SELECT %s FROM %s WHERE %s LIKE '%%%q%%' OR %s LIKE '%%%q%%'",
								   [[self preparationStatement] cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   [kPhotoTableName cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   [kPhotoTitleColumnName cStringUsingEncoding:NSUTF8StringEncoding],
								   [iSearch cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   [kPhotoDescriptionColumnName cStringUsingEncoding:NSUTF8StringEncoding],
								   [iSearch cStringUsingEncoding:NSUTF8StringEncoding]);
								  
								   
								  	
	// Execute
	NSArray* aArray = [self arrayOfObjectsFromQuery:aQuery object:[DBPhoto class]];
	
	// Free
	sqlite3_free(aQuery);
	
	
	// Otherwise returns the first object
	return aArray;
}


@end
