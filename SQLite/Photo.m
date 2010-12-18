@synthesize farm = _farm;
@synthesize server = _server;
@synthesize posted = _posted;
@synthesize updated = _updated;
@synthesize ispublic = _ispublic;
@synthesize id = _id;
@synthesize owner = _owner;
@synthesize secret = _secret;
@synthesize title = _title;
@synthesize taken = _taken;
@synthesize description = _description;
- (Photo*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement
{
	if (self = [super init])
	{
		_farm = sqlite3_column_int(iStatement, kPhotoFarmColumn);
		_server = sqlite3_column_int(iStatement, kPhotoServerColumn);
		_posted = sqlite3_column_int(iStatement, kPhotoPostedColumn);
		_updated = sqlite3_column_int(iStatement, kPhotoUpdatedColumn);
		_ispublic = sqlite3_column_int(iStatement, kPhotoIspublicColumn);
		_id = [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoIdColumn];
		_owner = [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoOwnerColumn];
		_secret = [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoSecretColumn];
		_title = [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoTitleColumn];
		_taken = [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoTakenColumn];
		_description = [[NSString alloc] initWithSQLiteStatement:iStatement column:kPhotoDescriptionColumn];
	}

	return self;
}
- (Photo*)initinitWithDictionary:(NSDictionary*)iDictionary
{
	if (self = [super init])
	{
		_farm = [NSString integerFromDictionary:iDictionary key:kPhotoFarmColumnName];
		_server = [NSString integerFromDictionary:iDictionary key:kPhotoServerColumnName];
		_posted = [NSString integerFromDictionary:iDictionary key:kPhotoPostedColumnName];
		_updated = [NSString integerFromDictionary:iDictionary key:kPhotoUpdatedColumnName];
		_ispublic = [NSString integerFromDictionary:iDictionary key:kPhotoIspublicColumnName];
		_id = [[NSString alloc] initWithDictionary:iDictionary key:kPhotoIdColumnName];
		_owner = [[NSString alloc] initWithDictionary:iDictionary key:kPhotoOwnerColumnName];
		_secret = [[NSString alloc] initWithDictionary:iDictionary key:kPhotoSecretColumnName];
		_title = [[NSString alloc] initWithDictionary:iDictionary key:kPhotoTitleColumnName];
		_taken = [[NSString alloc] initWithDictionary:iDictionary key:kPhotoTakenColumnName];
		_description = [[NSString alloc] initWithDictionary:iDictionary key:kPhotoDescriptionColumnName];
	}

	return self;
}
- (void)dealloc
{
	[_id release];
	[_owner release];
	[_secret release];
	[_title release];
	[_taken release];
	[_description release];

	[super dealloc];
}
