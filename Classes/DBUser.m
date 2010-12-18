//
//  DBUser.m
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBUser.h"
#import "Strings.h"

static const NSInteger kUserUsernameColumn	= 0;
static const NSInteger kUserNSIDColumn		= 1;
static const NSInteger kUserMainUserColumn	= 2;


@implementation DBUser

@synthesize username;
@synthesize nsid;
@synthesize user_id;
@synthesize isMainUser;

- (DBUser*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement
{
	if (self = [super init])
	{
		user_id		= kUserUnkownID;
		isMainUser	= sqlite3_column_int(iStatement, kUserMainUserColumn);
		nsid		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kUserNSIDColumn];
		username	= [[NSString alloc] initWithSQLiteStatement:iStatement column:kUserUsernameColumn];
	}
	return self;
}

- (DBUser*)initWithDictionary:(NSDictionary*)iDictionary
{
	if (self = [super init])
	{
		user_id		= kUserUnkownID;
		isMainUser	= NO;
		username	= [[NSString alloc] initWithDictionary:iDictionary key:@"username"];
		nsid		= [[NSString alloc] initWithDictionary:iDictionary key:@"nsid"];
	}
	
	return self;
}

- (void)dealloc
{
	[username release];
	[nsid release];
	
	[super dealloc];
}

@end
