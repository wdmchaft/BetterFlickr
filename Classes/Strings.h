//
//  Strings.h
//  BetterFlickr
//
//  Created by Johan Attali on 11/7/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NSString (Common) 


/*! @method		initWithSQLiteStatement:column
 *	@abstract	Creates an initialized NSString based on sqlite statement
 *	@param		iStatement	The SQLite Statement holding the potential string
 *	@param		iColumn		The column number where to look for the string
 *	@result		The string init based on the statement or nil if not found
 */
- (NSString *)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

/*! @method		initWithDictionary:key
 *	@abstract	Creates an initialized NSString based on a dictionary and its key passed in parameter
 *	@param		iDict		The Dictionary holding the potential string
 *	@param		iKey		The key to lookup in the dictionary
 *	@result		The string init based on the statement or nil if not found
 */
- (NSString *)initWithDictionary:(NSDictionary*)iDict key:(NSString*)iKey;

/*!
 * @method		integerFromDictionary:key
 * @abstract	Returns an integer base on the result of [NSDictionary objectForKey]
 * @param		iDict		The Dictionary holding the potential string
 * @param		iKey		The key to lookup in the dictionary
 * @result		An Integer based from a String
 */
+ (NSInteger)integerFromDictionary:(NSDictionary*)iDict key:(NSString*)iKey;

/*!
 * @method		integerFromStatement
 * @abstract	Checks if the statement is not null before assigning it to an int
 * @param		iStatement		The SQLite statement (query must be valid)
 * @param		iColumn			The column to refer to
 * @result		An Integer or a NSIntegerMin if the refered statement
				and column do not match an interger
 */
+ (NSInteger)integerFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

- (__strong const char *)cSatementSafeString;

+ (__strong const char *)cSatementSafeStringFromInteger:(NSInteger)iInteger;

/*!
 * @method		isString:key
 * @abstract	Returns YES if the current object is a string.
 * @param		iStr		The Object to test
 * @result		YES if iStr is a NSString or NSMutableString NO otherwise
 */
+ (BOOL)isString:(NSObject*)iStr;

@end


@interface UILabel (VerticalAlign)

/*!
 * @method		alignTop:key
 * @abstract	Calculates the frame of the self UILabel in order to avoid
 *				having the text being set at the center.
 */
- (void)alignTop;
- (void)alignBottom;
@end


