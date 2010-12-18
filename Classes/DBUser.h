//
//  DBUser.h
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "DBObject.h"

#define kUserUnkownID -1


@interface DBUser : DBObject 
{

	NSInteger	user_id;
	NSString*	username;
	NSString*	nsid;
	BOOL		isMainUser;
}

@property (nonatomic, retain) NSString*	username;
@property (nonatomic, retain) NSString*	nsid;
@property (nonatomic) NSInteger	user_id;
@property (nonatomic) BOOL	isMainUser;

- (DBUser*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;
- (DBUser*)initWithDictionary:(NSDictionary*)iDictionary;

@end
