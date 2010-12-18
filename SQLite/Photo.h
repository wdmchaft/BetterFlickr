#define kPhotoFarmColumn 0
#define kPhotoServerColumn 1
#define kPhotoPostedColumn 2
#define kPhotoUpdatedColumn 3
#define kPhotoIspublicColumn 4
#define kPhotoIdColumn 5
#define kPhotoOwnerColumn 6
#define kPhotoSecretColumn 7
#define kPhotoTitleColumn 8
#define kPhotoTakenColumn 9
#define kPhotoDescriptionColumn 10

#define kPhotoFarmColumnName @"farm"
#define kPhotoServerColumnName @"server"
#define kPhotoPostedColumnName @"posted"
#define kPhotoUpdatedColumnName @"updated"
#define kPhotoIspublicColumnName @"ispublic"
#define kPhotoIdColumnName @"id"
#define kPhotoOwnerColumnName @"owner"
#define kPhotoSecretColumnName @"secret"
#define kPhotoTitleColumnName @"title"
#define kPhotoTakenColumnName @"taken"
#define kPhotoDescriptionColumnName @"description"

@interface Photo : NSObject
{) NSInteger _farm;
) NSInteger _server;
) NSInteger _posted;
) NSInteger _updated;
	BOOL	_ispublic;
	NSString*	_id;
	NSString*	_owner;
	NSString*	_secret;
	NSString*	_title;
	NSString*	_taken;
	NSString*	_description;
}

@property (nonatomic) NSInteger farm;
@property (nonatomic) NSInteger server;
@property (nonatomic) NSInteger posted;
@property (nonatomic) NSInteger updated;
@property (nonatomic) BOOL ispublic;
@property (nonatomic,retain) NSString* id;
@property (nonatomic,retain) NSString* owner;
@property (nonatomic,retain) NSString* secret;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* taken;
@property (nonatomic,retain) NSString* description;

- (Photo*)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;
- (Photo*)initWithDictionary:(NSDictionary*)iDictionary;

@end
