//
//  Singleton.m
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton

/*!
 * @method		instance
 * @abstract	Creates a static instance of the DB accessible from everywhere in the application. 
 * @result		A static instance of the local DB class
 */
+ (id)instance
{
	static Singleton* db = nil;
	if (db == nil)
		db = [[Singleton alloc] init];
	return db;
}


@end
