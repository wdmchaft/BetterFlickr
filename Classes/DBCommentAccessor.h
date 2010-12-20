//
//  DBCommentAccessor.h
//  BetterFlickr
//
//  Created by Johan Attali on 12/19/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBAccessor.h"

@class DBPhoto;
@class DBUser;
@class DBComment;

@interface DBCommentAccessor : DBAccessor
{

}

/*!
 * @method		insertComment:
 * @abstract	Saves the BOM object into the local database
 * @param		iPhoto	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) insertComment:(DBComment*)iComment;

/*!
 * @method		commentFromId:
 * @abstract	Retreives DBObject from its Object ID. nil is returned if not found
 * @param		iObjId	The object id
 * @result		An autoreleased instance of the object if found, nil otherwise
 */
- (DBComment*) commentFromId:(NSString*)iObjId;

/*!
 * @method		commentsForPhoto:
 * @abstract	Retreives a list of DBObjects based on the depending parameter
 * @param		iPhoto	The object id
 * @result		An array will all objects matching the request (can be empty if no objects found).
 */
- (NSArray*) commentsForPhoto:(DBPhoto*)iPhoto;

@end
