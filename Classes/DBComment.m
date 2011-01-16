//
//  DBComment.m
//  BetterFlickr
//
//  Created by Johan Attali on 12/19/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "DBComment.h"
#import "Strings.h"

#import "TFHpple.h"

@implementation DBComment

@synthesize cid = _id;
@synthesize content = _content;
@synthesize dateCreated = _dateCreated;
@synthesize refUser = _refUser;
@synthesize refPhoto = _refPhoto;

#pragma mark Init Functions

- (DBComment*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement
{
	if (self = [super init])
	{
		_id				= [[NSString alloc] initWithSQLiteStatement:iStatement column:kCommentIdColumn];
		_content		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kCommentContentColumn];
		_dateCreated	= [[NSString alloc] initWithSQLiteStatement:iStatement column:kCommentDateCreatedColumn];
		_refUser		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kCommentRefUserColumn];
		_refPhoto		= [[NSString alloc] initWithSQLiteStatement:iStatement column:kCommentRefPhotoColumn];
	}
	
	return self;
	
}

- (DBComment*)initWithDictionary:(NSDictionary*)iDictionary
{
	if (self = [super init])
	{	
		_id				= [[NSString alloc] initWithDictionary:iDictionary key:kCommentIdColumnName];
		_content		= [[NSString alloc] initWithDictionary:iDictionary key:kCommentContentDictName];
		_dateCreated	= [[NSString alloc] initWithDictionary:iDictionary key:kCommentDateCreatedDictName];
		_refUser		= [[NSString alloc] initWithDictionary:iDictionary key:kCommentRefUserDictName];
		
	}
	
	return self;
}

- (DBComment*)initWithDictionary:(NSDictionary*)iDictionary refPhotoId:(NSString*)refPhotoId
{
REQUIRE ([refPhotoId length])
	if (self = [self initWithDictionary:iDictionary])
		_refPhoto = [[NSString alloc] initWithString:refPhotoId];
	
	return self;
}

- (void)dealloc
{
	[_id release];
	[_content release];
	[_dateCreated release];
	[_refUser release];
	[_refPhoto release];
	
	[super dealloc];
}

#pragma mark Formating Functions

/*!
 * @method		contentForWebView:
 * @abstract	Overrides the description field to be able to display in a UIWebView
 * @result		An HTML String with the photo description
 */
- (NSString *)contentForWebView
{
	return [NSString stringWithFormat:@"<html><head>%s</head><body style=\"%@\">%@</body></html>",
			@"<style type=\"text/css\">p {color:blue} a {color:white} </style>",
			@"background-color:black;font-family:Verdana;font-size:11;color:#888;padding:0;margin:1px 5px;",
			self.content];
}

/*!
 * @method		contentWithoutHTML:
 * @abstract	Overrides the description field without html tags
 * @result		The description field of the comment with html tags
 */
- (NSString *)contentWithoutHTML
{
	TFHpple* aXPathParser	= [[TFHpple alloc] initWithHTMLData:[_content dataUsingEncoding:NSUTF8StringEncoding]];
	NSArray* aArrayAllText	= [aXPathParser search:@"//*/text()"]; // get the page title - this is xpath notation
	NSString* aStrippedHTML = @"";
	
	for (TFHppleElement* element in aArrayAllText)
			aStrippedHTML = [aStrippedHTML stringByAppendingString:[element content]];
	
	[aXPathParser release];
	
	return aStrippedHTML;
}

/*!
 * @method		dateCreatedFormatted:
 * @abstract	Overrides the dateCreated field to be readable
 * @result		A readable form of the dateCreated field
 */
- (NSString *)dateCreatedFormatted
{
	NSDate* aRefDate = [NSDate dateWithTimeIntervalSince1970:[_dateCreated doubleValue]];
	
	NSString *aDateFormat			= @"MMM dd yyyy";
	NSDateFormatter *aDateFormatter = [[NSDateFormatter alloc] init];
	
	[aDateFormatter setDateFormat:aDateFormat];
	
	NSString *newDateString = [aDateFormatter stringFromDate:aRefDate];
	
	[aDateFormatter release];
	
	return newDateString;
}


@end
