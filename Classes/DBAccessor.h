//
//  DBAccessor.h
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface DBAccessor : Singleton
{

}

/*!
 * @method		writableDBPath
 * @abstract	Returns the exact path where the local sqlite 
 *				database is stored. (This should never change)
 * @result		A string with the corresponding path
 */
- (NSString*)writableDBPath;

/*!
 * @method		preparationStatement
 * @abstract	Returns the statement located into SELECT or INSERT queries
 *				and will vary depending on the subclass called
 * @result		An autoreleased string object
 */
- (NSString*) preparationStatement;

/*!
 * @method		arrayOfUsersFromQuery
 * @abstract	Creates the sqlite statement and does the sqlite3 call 
 *				to retreive elements with more than one matching element.
 * @param		query The string that holding the query 
 * @result		An array built from matching objects
 */
- (NSMutableArray*)arrayOfUsersFromQuery:(NSString*)query;

/*!
 * @method		arrayOfObjectsFromQuery:object
 * @abstract	Creates the sqlite statement and does the sqlite3 call 
 *				to retreive elements with more than one matching element.
 * @param		iQuery The string that holding the query 
 * @param		iClass The object class that will be used during the array construction 
 * @result		An array built from matching objects
 */
- (NSMutableArray*)arrayOfObjectsFromQuery:(const char*)iQuery object:(Class)iClass;


/*!
 * @method		execute
 * @abstract	Execute the given query and returns the last statement result
 * @param		query The string that holding the query
 * @result		True if correctly processed. False otherwise
 */
- (BOOL)executeQuery:(const char*)query;




@end
