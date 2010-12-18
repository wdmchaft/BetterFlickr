//
//  DBAccessor.m
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBAccessor.h"
#import "DBUser.h"
#import "DBPhoto.h"

#import <sqlite3.h>

@implementation DBAccessor

#pragma mark -
#pragma mark Arrays Returned



- (NSMutableArray*)arrayOfUsersFromQuery:(NSString*)iQuery
{
	NSMutableArray* aArray	= [[[NSMutableArray alloc] init] autorelease];
	NSString* aDBpath		= [self writableDBPath];
	
	// Holds the database connection
	sqlite3* aDatabase;
	
	if (sqlite3_open([aDBpath UTF8String], &aDatabase) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator. 
		NSInteger aResult = sqlite3_prepare_v2(aDatabase, [iQuery UTF8String], -1, &statement, NULL);
		if (aResult == SQLITE_OK) 
		{
			// We "step" through the results - once for each row.
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				// Use our own init function with the current statement
				DBUser* aUser = [[DBUser alloc] initWithSQLiteStatement:statement];
				[aArray addObject:aUser];
				// can be released since it's retained in the clips array
				[aUser release];			
			}
		}
		else
		{
			NSLog(@"An error occured while executing the following query: %@", iQuery);
		}

		// "Finalize" the statement - releases the resources associated with the statement.
		sqlite3_finalize(statement);
		
	}
	
	// Safely close database even if the connection was not done.
	sqlite3_close(aDatabase);
	
	return aArray;
	
}

/*!
 * @method		arrayOfObjectsFromQuery:object
 * @abstract	Creates the sqlite statement and does the sqlite3 call 
 *				to retreive elements with more than one matching element.
 * @param		iQuery The string that holding the query 
 * @param		iClass The object class that will be used during the array construction 
 * @result		An array built from matching objects
 */
- (NSMutableArray*)arrayOfObjectsFromQuery:(const char*)iQuery object:(Class)iClass
{
	NSMutableArray* aArray	= [[[NSMutableArray alloc] init] autorelease];
	NSString* aDBpath		= [self writableDBPath];
	
	// Holds the database connection
	sqlite3* aDatabase;
	
	if (sqlite3_open([aDBpath UTF8String], &aDatabase) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator. 
		NSInteger aResult = sqlite3_prepare_v2(aDatabase, iQuery, -1, &statement, NULL);
		if (aResult == SQLITE_OK) 
		{
			// We "step" through the results - once for each row.
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				
				// Use our own init function with the current statement
				DBObject* aDBObject = nil;
				if (iClass == [DBUser class])
					aDBObject = [[DBUser alloc] initWithSQLiteStatement:statement];
				else if (iClass == [DBPhoto class])
					aDBObject = [[DBPhoto alloc] initWithSQLiteStatement:statement];
				
				// Store object into returned array
				[aArray addObject:aDBObject];
				// can be released since it's retained in the clips array
				[aDBObject release];			
			}
		}
		else
		{
			NSLog(@"An error occured while executing the following query: %@", iQuery);
		}
		
		// "Finalize" the statement - releases the resources associated with the statement.
		sqlite3_finalize(statement);
		
	}
	
	// Safely close database even if the connection was not done.
	sqlite3_close(aDatabase);
	
	return aArray;
	
}


/*!
 * @method		execute
 * @abstract	Execute the given query and returns the last statement result
 * @param		query The string that holding the query
 * @result		The last statement result
 */
- (BOOL)executeQuery:(const char*)query
{
	NSString* DBpath		= [self writableDBPath];
	// Holds the database connection
	sqlite3* database;
	
	NSInteger ret = sqlite3_open([DBpath UTF8String], &database);
	
	if (ret == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator. 
		ret = sqlite3_prepare_v2(database, query, -1, &statement, NULL);
		
		if (ret == SQLITE_OK) 
			ret = sqlite3_step(statement);
		
		// "Finalize" the statement - releases the resources associated with the statement.
		sqlite3_finalize(statement);
		
	}
	
	// Safely close database even if the connection was not done.
	sqlite3_close(database);
	
	// Log Error if ret is not ok
	if (ret != SQLITE_OK && ret != SQLITE_DONE)
		NSLog(@"\n***********************************\n\tFailed to execute: \n\t%s\n***********************************",  query);
	
	return (ret == SQLITE_OK || ret == SQLITE_DONE);
}

#pragma mark -
#pragma mark Useful Methods


- (NSString*)writableDBPath
{
	NSArray *aPaths			= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *aDocFolder	= [aPaths objectAtIndex:0];
    NSString *aWritablePath	= [aDocFolder stringByAppendingPathComponent:kDatabaseName];
	return aWritablePath;
}

- (NSString*) preparationStatement
{
	return nil;
}


@end
