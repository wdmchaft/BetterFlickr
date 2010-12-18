//
//  DBUserAccessor.h
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBAccessor.h"

@class DBUser;

@interface DBUserAccessor : DBAccessor 
{

}

/*!
 * @method		getMainUser
 * @abstract	Returns the main user of the application, that is the one logged in
 * @result		A DBUser object if found or nil otherwise
 */
- (DBUser*) getMainUser;

/*!
 * @method		insertUser
 * @abstract	Creates a user from a BOM instance and store in the local database
 * @param		iUser	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) insertUser:(DBUser*)iUser;

@end
