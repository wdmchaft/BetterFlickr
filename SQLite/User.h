#define kUserMain_userColumn 0
#define kUserUsernameColumn 1
#define kUserNsidColumn 2

#define kUserMain_userColumnName @"main_user"
#define kUserUsernameColumnName @"username"
#define kUserNsidColumnName @"nsid"

@interface User : NSObject
{	BOOL	_main_user;
	NSString*	_username;
	NSString*	_nsid;
}

@property (nonatomic) BOOL main_user;
@property (nonatomic,retain) NSString* username;
@property (nonatomic,retain) NSString* nsid;

- (User*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;
- (User*)initWithDictionary:(NSDictionary*)iDictionary;

@end
