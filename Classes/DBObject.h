//
//  DBObject.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/3/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kDBUnkown -1;

@interface DBObject : NSObject 
{

}

///*!
// * @method		initFromStatement:column
// * @abstract	Creates an allocated string based on a sqlite3 statement and column number
// * @result		A NSString object allocated from a init method (!autoRelease)
// */
//
//- (NSString*)initFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)column;
//
///*!
// * @method		integerFromDictionary:key
// * @abstract	Returns an integer base on the result of [NSDictionary objectForKey]
// * @result		An Integer based from a String
// */
//- (NSInteger)integerFromDictionary:(NSDictionary*)dictionary key:(NSString*)key;

@end
