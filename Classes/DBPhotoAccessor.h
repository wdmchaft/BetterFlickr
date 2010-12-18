//
//  DBPhotoAccessor.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/7/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBAccessor.h"

@class DBPhoto;
@class DBUser;

@interface DBPhotoAccessor : DBAccessor
{

}


/*!
 * @method		insertPhoto:
 * @abstract	If the object is new, it is directly insterted into the local DB
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) insertPhoto:(DBPhoto*)iPhoto;

/*!
 * @method		updatePhoto:
 * @abstract	If the object is already stored in the local DB then its content is simply updated
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) updatePhoto:(DBPhoto*)iPhoto;

/*!
 * @method		savePhoto:
 * @abstract	Two behaviors possible depending on the object passed in parameter (call to updatePhoto:).
 *				If the object is already stored in the local DB then its content is simply updated (call to insertPhoto:)
 *				If the object is new, it is directly insterted into the local DB
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) savePhoto:(DBPhoto*)iPhoto;

/*!
 * @method		photoFromId:
 * @abstract	Retreives DBObject from its Object ID. nil is returned if not found
 * @param		iObjId	The object id
 * @result		An autoreleased instance of the object if found, nil otherwise
 */
- (DBPhoto*) photoFromId:(NSString*)iObjId;

/*!
 * @method		photosFromUser:
 * @abstract	Retreives a list of DBObjects based on the depending parameter
 * @param		iUser	The object id
 * @result		An array will all objects matching the request (can be empty if no objects found).
 */
- (NSArray*) photosFromUser:(DBUser*)iUser;

/*!
 * @method		photosFromSearch:
 * @abstract	Retreives a list of DBObjects based from a query to search
 * @param		iSearch	The string to search for
 * @result		An array will all objects matching the request (can be empty if no objects found).
 */
- (NSArray*) photosFromSearch:(NSString*)iSearch;

@end
