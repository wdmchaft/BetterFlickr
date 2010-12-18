@synthesize main_user = _main_user;
@synthesize username = _username;
@synthesize nsid = _nsid;
- (User*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement
{
	if (self = [super init])
	{
		_main_user = sqlite3_column_int(iStatement, kUserMain_userColumn);
		_username = [[NSString alloc] initWithSQLiteStatement:iStatement column:kUserUsernameColumn];
		_nsid = [[NSString alloc] initWithSQLiteStatement:iStatement column:kUserNsidColumn];
	}

	return self;
}
- (User*)initinitWithDictionary:(NSDictionary*)iDictionary
{
	if (self = [super init])
	{
		_main_user = [NSString integerFromDictionary:iDictionary key:kUserMain_userColumnName];
		_username = [[NSString alloc] initWithDictionary:iDictionary key:kUserUsernameColumnName];
		_nsid = [[NSString alloc] initWithDictionary:iDictionary key:kUserNsidColumnName];
	}

	return self;
}
- (void)dealloc
{
	[_username release];
	[_nsid release];

	[super dealloc];
}
