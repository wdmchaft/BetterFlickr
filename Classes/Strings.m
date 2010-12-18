//
//  Strings.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/7/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "Strings.h"
#import "ObjectiveFlickr.h"

#pragma mark -
#pragma mark NSString Overloads

@implementation NSString (Common) 

- (NSString *)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn
{
	const unsigned char* t = sqlite3_column_text(iStatement, iColumn);
	
	self = nil;
	if (t)
		self =  [[NSString alloc] initWithCString:(const char*)sqlite3_column_text(iStatement, iColumn)
										 encoding:NSUTF8StringEncoding];
	return self;
}

/*! @method		initWithDictionary:key
 *	@abstract	Creates an initialized NSString based on a dictionary and its key passed in parameter
 *				The value associated to the key can be of two formats:
 *				{ key: "string" } or
 *				{ key: { _text: "string" }}
 *	@param		iDict		The Dictionary holding the potential string
 *	@param		iKey		The key to lookup in the dictionary
 *	@result		The string init based on the statement or nil if not found
 */
- (NSString *)initWithDictionary:(NSDictionary*)iDict key:(NSString*)iKey
{
	NSString* aStr = @"";
	
	NSString* aValue = [iDict objectForKey:iKey];
	NSString* aTextValue = nil;
	
	if ([NSString isString:aValue])
		 aStr = aValue;
	else if (aValue && [aValue superclass] == [NSMutableDictionary class])
	{
		aTextValue = [[iDict valueForKeyPath:iKey] textContent];
		
		if ([NSString isString:aTextValue])
			aStr = aTextValue;
	}
	
	self = [[NSString alloc] initWithFormat:@"%@",aStr];

REQUIRE (self != aValue)
REQUIRE (self != aTextValue)
	
	return self;
}


- (__strong const char *)cSatementSafeString
{
	if (self != nil)
	{
		//NSString* aStr = [NSString stringWithFormat:@"'%@'", self];
		return [self cStringUsingEncoding:NSUTF8StringEncoding];
	}
	else return 0;
}

+ (__strong const char *)cSatementSafeStringFromInteger:(NSInteger)iInteger
{
	if (iInteger < 0)
		return "NULL";
	
	NSString* aStr = [NSString stringWithFormat:@"%d",iInteger];
	return [aStr cStringUsingEncoding:NSUTF8StringEncoding];
	
}

+ (BOOL)isString:(NSObject*)iStr;
{
	return (iStr && ([iStr class] == [NSString class] || [iStr superclass] == [NSMutableString class]));
}

/*!
 * @method		integerFromDictionary:key
 * @abstract	Returns an integer base on the result of [NSDictionary objectForKey]
 * @param		iDict		The Dictionary holding the potential string
 * @param		iKey		The key to lookup in the dictionary
 * @result		An Integer based from a String
 */
+ (NSInteger)integerFromDictionary:(NSDictionary*)iDict key:(NSString*)iKey
{
REQUIRE(iKey != nil)
REQUIRE(iDict != nil)	
REQUIRE([iKey class] == [NSString class] || [iKey superclass] == [NSMutableString class])
	
	NSInteger aRes = NSIntegerMin;
	NSString* aValue = [iDict objectForKey:iKey];
	
	if ([NSString isString:aValue])
		aRes  = [aValue integerValue];
	else if (aValue && [aValue superclass] == [NSMutableDictionary class])
	{
		NSString* aTextValue = [[iDict valueForKeyPath:iKey] textContent];
		if ([NSString isString:aTextValue])
			aRes  = [aTextValue integerValue];
	}
	
//	else
//		[NSException raise:@"String Parsing Exception"
//					format:@"Key %@ not found in dictionary",iKey];

	return aRes;
	
}

+ (NSInteger)integerFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn
{
	NSInteger aRes = NSIntegerMin;
	if (sqlite3_column_type(iStatement, iColumn) == SQLITE_INTEGER)
		aRes = (NSInteger)sqlite3_column_int(iStatement, iColumn);
	return aRes;
}

@end

#pragma mark -
#pragma mark UILabel Overloads

@implementation UILabel (VerticalAlign)

- (void)alignTop
{
    CGSize aFontSize = [self.text sizeWithFont:self.font];
	
    double aFinalH = aFontSize.height * self.numberOfLines;
    double aFinalW = self.frame.size.width;    //expected width of label
	
	
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(aFinalW, aFinalH) lineBreakMode:self.lineBreakMode];
	
	
    int newLinesToPad = (aFinalH  - theStringSize.height) / aFontSize.height;
	
    for(int i=1; i< newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n"];
}

- (void)alignBottom
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
	
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
	
	
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
	
	
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
	
    for(int i=1; i< newLinesToPad; i++)
    {
        self.text = [NSString stringWithFormat:@"\n%@",self.text];
    }
}
@end


