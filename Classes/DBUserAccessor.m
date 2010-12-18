//
//  DBUserAccessor.m
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBUserAccessor.h"
#import "DBUser.h"

static const NSString* kUserUsernameColumnName	= @"username";
static const NSString* kUserNSIDColumnName		= @"nsid";
static const NSString* kUserMainUserColumnName	= @"main_user";

@implementation DBUserAccessor

+ (DBUserAccessor*)instance
{
	static DBUserAccessor* db = nil;
	if (db == nil)
		db = [[DBUserAccessor alloc] init];
	return db;
}

/*!
 * @method		getMainUser   
 * @abstract	Returns the main user of the application, that is the one logged in
 * @result		A DBUser object if found or nil otherwise
 */
- (DBUser*) getMainUser
{			
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@,%@,%@ FROM User WHERE main_user = 1",
						kUserUsernameColumnName,
						kUserNSIDColumnName,
						kUserMainUserColumnName];
	
	NSArray* aArray = [self arrayOfObjectsFromQuery:[aQuery UTF8String] object:[DBUser class]];
	
	// While the user has not logged in the array can be empty
	if ([aArray count] == 0)
		return nil;
	
	// Otherwise returns the first object
	return [aArray objectAtIndex:0];
	
}

/*!
 * @method		insertUser
 * @abstract	Creates a user from a BOM instance and store in the local database
 * @param		iUser	The BOM instance of the object to be stored
 * @result		True if correctly inserted, False otherwise
 */
- (BOOL) insertUser:(DBUser*)iUser
{
	// Create Insertion Query
	char* aQuery = sqlite3_mprintf("INSERT INTO User (%s,%s,%s) VALUES ('%s', '%s', %d)",
								   [kUserUsernameColumnName cStringUsingEncoding:NSUTF8StringEncoding],
								   [kUserNSIDColumnName cStringUsingEncoding:NSUTF8StringEncoding],
								   [kUserMainUserColumnName cStringUsingEncoding:NSUTF8StringEncoding],
								   
								   [[iUser username]	cStringUsingEncoding:NSUTF8StringEncoding],
								   [[iUser nsid]		cStringUsingEncoding:NSUTF8StringEncoding],
								   [iUser isMainUser]);
	
	
	// Execute
	BOOL result =  [self executeQuery:aQuery];
	
	// Free
	sqlite3_free(aQuery);
	
	
	// Return
	return result;
	
}

@end
